//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by mohammadreza on 12/1/22.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
