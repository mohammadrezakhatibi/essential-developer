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
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url, completion: completion)
    }
}

final class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.loaderURLs.isEmpty)
    }
    
    func test_loadImageData_loadFromLoader() {
        let url = anyURL()
        let (sut, loader) = makeSUT()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(loader.loaderURLs, [url])
    }
    
    func test_loadImageData_cancelsLoaderTask() {
        let url = anyURL()
        let (sut, loader) = makeSUT()
        
        let task = sut.loadImageData(from: url, completion: { _ in })
        task.cancel()
        
        XCTAssertEqual(loader.canceledURLs, [url])
    }
    
    func test_loadImageData_deliverDataOnLoaderSuccess() {
        let (sut, loader) = makeSUT()
        let expectedData = anyData()
        
        expect(sut, toComplete: .success(expectedData), when: {
            loader.complete(with: expectedData)
        })
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageDataLoaderCacheDecorator, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func expect(_ sut: FeedImageDataLoaderCacheDecorator, toComplete expectedResult: FeedImageDataLoader.Result, when action: () -> Void) {
        let url = anyURL()
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: url, completion: { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData)
                
            case let (.failure(receivedError), .failure(expectedResult)):
                XCTAssertEqual(receivedError as NSError?, expectedResult as NSError?)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead")
                
            }
            exp.fulfill()
        })
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class LoaderSpy: FeedImageDataLoader {
        
        var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        var loaderURLs: [URL] {
            return messages.map { $0.url }
        }
        var canceledURLs = [URL]()
        
        private struct Task: FeedImageDataLoaderTask {
            var callback: () -> Void
            
            func cancel() {
                callback()
            }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.canceledURLs.append(url)
            }
        }
        
        func complete(with data: Data, at index: Int = 0) {
            messages[index].completion(.success(data))
        }
    }
    
}
