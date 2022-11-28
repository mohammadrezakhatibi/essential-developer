//
//  LocalFeedImageLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 11/28/22.
//

import Foundation
import XCTest
import EssentialFeed

final class LocalFeedImageLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestStoredDataFromURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
        
    }
    
    func test_loadImageDataFromURL_failsOnStoreFailureRetrieval() {
        let (sut, store) = makeSUT()
        let error = LocalFeedImageLoader.Error.failed
        
        expect(sut, toCompleteWith: .failure(error), when: {
            store.complete(with: error)
        })
    }
    
    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: notFound(), when: {
            store.complete(with: .none)
        })
    }
    
    func test_loadImageDataFromURL_deliversStoredDataOnFoundData() {
        let (sut, store) = makeSUT()
        let data = anyData()
        
        expect(sut, toCompleteWith: .success(data), when: {
            store.complete(with: data)
        })
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterCancellingTask() {
        let (sut, store) = makeSUT()
        let foundData = anyData()
        
        var received = [FeedImageDataLoader.Result]()
        let task = sut.loadImageData(from: anyURL(), completion: { received.append($0) })
        task.cancel()
        
        store.complete(with: foundData)
        store.complete(with: .none)
        store.complete(with: anyNSError())
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after cancelling task")
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        
        let store = StoreSpy()
        var sut: LocalFeedImageLoader? = LocalFeedImageLoader(store: store)
        
        var received = [FeedImageDataLoader.Result]()
        _ = sut?.loadImageData(from: anyURL(), completion: { received.append($0) })
        
        sut = nil
        
        store.complete(with: anyData())
        store.complete(with: .none)
        store.complete(with: anyNSError())
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after instance has been deallocated")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageLoader(store: store)
        trackForeMemoryLeak(store, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedImageLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let url = anyURL()
        
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: url) { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(expectedData), .success(receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)
                
            case (.failure(let expectedError as LocalFeedImageLoader.Error), .failure(let receivedError as LocalFeedImageLoader.Error)):
                XCTAssertEqual(expectedError , receivedError , file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
                
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func notFound() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageLoader.Error.notFound)
    }
    
    private func never(file: StaticString = #file, line: UInt = #line) {
        XCTFail("Expected no no invocations", file: file, line: line)
    }
    
    private class StoreSpy: FeedImageDataStore {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        var receivedMessages = [Message]()
        var completions = [(FeedImageDataStore.Result) -> Void]()
        
        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
            receivedMessages.append(.retrieve(dataFor: url))
            completions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
        
        func complete(with data: Data?, at index: Int = 0) {
            completions[index](.success(data))
        }
    }
}

