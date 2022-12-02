//
//  XCTestCase+FeedImageDataLoader.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/2/22.
//

import Foundation
import XCTest
import EssentialFeed

protocol FeedImageDataLoaderTestCase: XCTestCase { }

extension FeedImageDataLoaderTestCase {
    func expect(_ sut: FeedImageDataLoaderCacheDecorator, toComplete expectedResult: FeedImageDataLoader.Result, when action: () -> Void) {
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
}
