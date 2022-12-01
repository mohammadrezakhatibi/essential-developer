//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/1/22.
//

import XCTest
import EssentialFeed

final class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    
    let primary: FeedImageDataLoader
    
    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
    }
    
    private struct Task: FeedImageDataLoaderTask {
        private let wrapper: FeedImageDataLoaderTask
        
        init(_ wrapper: FeedImageDataLoaderTask) {
            self.wrapper = wrapper
        }
        
        func cancel() {
            wrapper.cancel()
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(primary.loadImageData(from: url, completion: completion))
        return task
    }
}

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryImageDataOnPrimaryImageDataLoad() {
        let primaryData = anyData()
        let fallbackData = anyData()
        
        let primaryLoader = LoaderStub(.success(primaryData))
        let fallbackLoader = LoaderStub(.success(fallbackData))
        
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "Wait for load completion")
        let _ = sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let .success(receivedData):
                XCTAssertEqual(receivedData, primaryData)
            case .failure:
                XCTFail("Expected success, got failure instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://a-url.com")!
    }

    private func anyData() -> Data {
        return Data("any data".utf8)
    }

    private class Task: FeedImageDataLoaderTask {
        func cancel() {
            
        }
    }
    
    private class LoaderStub: FeedImageDataLoader {
        let result: FeedImageDataLoader.Result
        
        init(_ result: FeedImageDataLoader.Result) {
            self.result = result
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> EssentialFeed.FeedImageDataLoaderTask {
            completion(result)
            return Task()
        }
    }
}
