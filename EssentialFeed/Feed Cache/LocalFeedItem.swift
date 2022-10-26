//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/26/22.
//

import Foundation

public struct LocalFeedItem: Equatable {
    public var id: UUID
    public var description: String?
    public var location: String?
    public var imageURL: URL
    
    public init(id: UUID,
                description: String? = nil,
                location: String? = nil,
                imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
