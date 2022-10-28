//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 10/28/22.
//

import Foundation

struct RemoteFeedItem: Decodable {
    
    public var id: UUID
    public var description: String?
    public var location: String?
    public var image: URL
    
    public init(id: UUID,
                description: String? = nil,
                location: String? = nil,
                image: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.image = image
    }
}
