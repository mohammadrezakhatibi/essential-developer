//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/13/22.
//

import Foundation

public struct FeedImage: Equatable {
    
    public var id: UUID
    public var description: String?
    public var location: String?
    public var url: URL
    
    public init(id: UUID,
                description: String? = nil,
                location: String? = nil,
                url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
