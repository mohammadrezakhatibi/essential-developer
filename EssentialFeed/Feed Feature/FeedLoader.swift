//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by mohammadreza on 10/13/22.
//

import Foundation

typealias LoadFeedResult = Result<FeedItem, Error>

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
