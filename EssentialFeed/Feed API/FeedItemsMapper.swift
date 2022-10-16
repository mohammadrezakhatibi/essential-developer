//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/14/22.
//

import Foundation

internal final class FeedItemsMapper {

    private struct Root: Decodable {
        var items: [Item]
    }

    private struct Item: Decodable {
        var id: UUID
        var description: String?
        var location: String?
        var image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    private static var OK_200: Int {
        return 200
    }

    internal static func map(_ data: Data, response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        let items = root.items.map { $0.item }
        return .success(items)
    }
}
