//
//  CacheFeedImageDataUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 11/29/22.
//

import Foundation
import XCTest
import EssentialFeed

final class CacheFeedImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotSendMessageUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        sut.save(data, for: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.save(data: data, for: url)])
        
    }
    
    func test_saveImageDataURL_failsOnImageDataInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = LocalFeedImageLoader.SaveError.failed
        
        expect(sut, toCompleteWith: failed(), when: {
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeInsertion()
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageLoader(store: store)
        trackForeMemoryLeak(store, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedImageLoader,
                        toCompleteWith expectedResult: LocalFeedImageLoader.SaveResult,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.save(anyData(), for: anyURL()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError as LocalFeedImageLoader.SaveError),
                  .failure(let receivedError as LocalFeedImageLoader.SaveError)):
                XCTAssertEqual(expectedError, receivedError, "Expected failure, got \(receivedResult) instead", file: file, line: line)
                
            case (.success(()), .success(())):
                break
                
            default:
                XCTFail("Expected failure, got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failed() -> LocalFeedImageLoader.SaveResult {
        return .failure(LocalFeedImageLoader.SaveError.failed)
    }
    
}
