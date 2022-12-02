//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/2/22.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedImageDataLoaderCacheDecorator {
    
    init(decoratee: FeedImageDataLoader) {
        
    }
}

final class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let loader = LoaderSpy()
        let _ = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        XCTAssertTrue(loader.messages.isEmpty)
    }
    
    private class LoaderSpy: FeedImageDataLoader {
        
        var messages = [Any]()
        
        private class Task: FeedImageDataLoaderTask {
            func cancel() {
                
            }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            return Task()
        }
    }
    
}
