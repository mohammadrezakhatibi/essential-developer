//
//  ImageCommentMapper.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 12/30/22.
//

import Foundation

internal final class ImageCommentMapper {

    private struct Root: Decodable {
        var items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        
        guard isOK(response), let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentLoader.Error.invalidData
        }
        
        return root.items
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
