//
//  CacheFeedUseCaseTest.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 10/25/22.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    var store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

final class CacheFeedUseCaseTest: XCTestCase {

    func test_init_doseNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
}
