//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/2/22.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
    
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
    
    func test_loadImageData_deliverErrorOnLoaderFailure() {
        let (sut, loader) = makeSUT()
        let expectedError = anyNSError()
        
        expect(sut, toComplete: .failure(expectedError), when: {
            loader.complete(with: expectedError)
        })
    }
    
    func test_loadImageData_cachesLoadedDataOnLoaderSuccess() {
        let cache = FeedImageDataCacheSpy()
        let (sut, loader) = makeSUT(cache: cache)
        let data = anyData()
        
        expect(sut, toComplete: .success(data), when: {
            loader.complete(with: data)
        })
        
        XCTAssertEqual(cache.messages, [.save(data)])
    }
    
    func test_loadImageData_doesNotCacheOnLoaderFailure() {
        let cache = FeedImageDataCacheSpy()
        let (sut, loader) = makeSUT(cache: cache)
        
        expect(sut, toComplete: .failure(anyNSError()), when: {
            loader.complete(with: anyNSError())
        })
        
        XCTAssertTrue(cache.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(cache: FeedImageDataCacheSpy = .init(),file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageDataLoaderCacheDecorator, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private class FeedImageDataCacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save(Data)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
            messages.append(.save(data))
            completion(.success(()))
        }
    }
}