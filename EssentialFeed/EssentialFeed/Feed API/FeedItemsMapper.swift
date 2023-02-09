//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/14/22.
//

import Foundation

public final class FeedItemsMapper {

    private struct Root: Decodable {
        private let items: [RemoteFeedItem]
        
        private struct RemoteFeedItem: Decodable {
            public let id: UUID
            public let description: String?
            public let location: String?
            public let image: URL
        }
        
        var images: [FeedImage] {
            return items.map {
                FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image)
            }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, for response: HTTPURLResponse) throws -> [FeedImage] {
        
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.images
    }
}
