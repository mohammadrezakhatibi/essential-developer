//
//  LoadCacheItemTests.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 10/27/22.
//

import XCTest
import EssentialFeed

final class LoadCacheItemTests: XCTestCase {

    func test_init_doesNotCallDeletionUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessage, [])
    }
    
    func test_load_requestRetrieveCachedItems() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_load_doesNotDeliverItemsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        
        var capturedError: Error?
        sut.load { result in
            switch result {
            case let .failure(error):
                capturedError = error
            default:
                XCTFail("expecting failure got \(result) instead")
            }
        }
        
        store.completeRetrieval(with: expectedError)
        
        XCTAssertEqual(capturedError as NSError?, expectedError)
    }
    
    func test_load_deliverEmptyItemsOnRetrievalEmptyResult() {
        let (sut, store) = makeSUT()
        
        let exp = expectation(description: "Waiting for load completion")
        
        var expectedResult: [FeedItem]?
        sut.load { result in
            switch result {
            case let .success(items):
                expectedResult = items
                exp.fulfill()
                
            default:
                XCTFail("expecting failure got \(result) instead")
            }
        }

        store.completeRetrievalSuccessfully()

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(expectedResult, [])
    }
    
    func test_load_deliverItemsOnSuccessfulRetrievalWithItems() {
        let (sut, store) = makeSUT()
        
        let items = [uniqueItem(), uniqueItem()]
        let exp = expectation(description: "Waiting for load completion")
        
        var expectedResult: [FeedItem]?
        sut.load { result in
            switch result {
            case let .success(items):
                expectedResult = items
                exp.fulfill()
                
            default:
                XCTFail("expecting failure got \(result) instead")
            }
        }

        store.completeRetrievalSuccessfully(items)

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(expectedResult, items)
    }
    
    // MARK: Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForeMemoryLeak(store, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "an error", code: 1)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://a-url.com")!
    }
}
