//
//  LocalFeedImageLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 11/28/22.
//

import Foundation
import XCTest
import EssentialFeed

protocol FeedImageDataStore {
    func retrieve(dataForURL url: URL)
}

final class LocalFeedImageLoader {
    let store: FeedImageDataStore
    
    private class Task: FeedImageDataLoaderTask {
        func cancel() { }
    }
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping () -> Void) -> FeedImageDataLoaderTask {
        store.retrieve(dataForURL: url)
        return Task()
    }
}

final class LocalFeedImageLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestStoredDataFromURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        sut.loadImageData(from: url) { }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageLoader(store: store)
        trackForeMemoryLeak(store, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class StoreSpy: FeedImageDataStore {
        
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        var receivedMessages = [Message]()
        
        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(dataFor: url))
        }
    }
}

