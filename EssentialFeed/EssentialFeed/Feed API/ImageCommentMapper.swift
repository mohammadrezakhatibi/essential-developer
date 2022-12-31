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
    
    internal static func map(_ data: Data, response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentLoader.Error.invalidData
        }
        
        return root.items
    }
}
