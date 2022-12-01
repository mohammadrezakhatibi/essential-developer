//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/1/22.
//

import XCTest
import EssentialFeed

final class FeedLoaderCacheDecorator: FeedLoader {
    
    let decoratee: FeedLoader
    
    init(decoratee: FeedLoader) {
        self.decoratee = decoratee
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(completion: completion)
    }
}

final class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {
    
    func test_loadFeed_deliversFeedOnLoaderSuccess() {
        let feed = anyUniqueFeed()
        let feedLoader = FeedLoaderStub(result: .success(feed))
        let sut = FeedLoaderCacheDecorator(decoratee: feedLoader)
        
        expect(sut, toCompleteWith: .success(feed))
    }
    
    func test_loadFeed_failsOnLoaderFailure() {
        let feedLoader = FeedLoaderStub(result: .failure(anyNSError()))
        let sut = FeedLoaderCacheDecorator(decoratee: feedLoader)
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
}
