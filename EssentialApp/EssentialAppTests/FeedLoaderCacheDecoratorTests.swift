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

final class FeedLoaderCacheDecoratorTests: XCTestCase {
    
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
    
    //MARK: - Helpers
    
    private func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (expectedResult, receivedResult) {
            case (let .success(expectedFeed), let .success(receivedFeed)):
                XCTAssertEqual(expectedFeed, receivedFeed, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
