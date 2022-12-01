//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/1/22.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
