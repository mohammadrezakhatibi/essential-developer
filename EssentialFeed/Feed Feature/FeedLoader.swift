//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/13/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
