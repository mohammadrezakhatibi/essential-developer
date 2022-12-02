//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/2/22.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    
    let decoratee: FeedImageDataLoader
    
    init(decoratee: FeedImageDataLoader) {
        self.decoratee = decoratee
    }
    
    private class Task: FeedImageDataLoaderTask {
        func cancel() {
            
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = decoratee.loadImageData(from: url, completion: completion)
        return task
    }
}

final class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let loader = LoaderSpy()
        let _ = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        XCTAssertTrue(loader.loaderURLs.isEmpty)
    }
    
    func test_loadImageData_loadFromLoader() {
        let url = anyURL()
        let loader = LoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(loader.loaderURLs, [url])
    }
    
    private class LoaderSpy: FeedImageDataLoader {
        
        var loaderURLs = [URL]()
        
        private class Task: FeedImageDataLoaderTask {
            func cancel() {
                
            }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            loaderURLs.append(url)
            return Task()
        }
    }
    
}
