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
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageLoader(store: store)
        trackForeMemoryLeak(store, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
}
