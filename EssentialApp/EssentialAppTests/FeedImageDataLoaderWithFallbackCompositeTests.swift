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
    let fallback: FeedImageDataLoader
    
    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    private struct Task: FeedImageDataLoaderTask {
        var wrapper: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapper?.cancel()
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        var task = Task()
        task.wrapper = primary.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                task.wrapper = self?.fallback.loadImageData(from: url, completion: completion)
            }
        }
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
    
    func test_load_deliversFallbackImageDataOnPrimaryImageDataLoadFailure() {
        let fallbackData = anyData()
        
        let primaryLoader = LoaderStub(.failure(anyNSError()))
        let fallbackLoader = LoaderStub(.success(fallbackData))
        
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "Wait for load completion")
        let _ = sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let .success(receivedData):
                XCTAssertEqual(receivedData, fallbackData)
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
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "an error", code: 1)
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
