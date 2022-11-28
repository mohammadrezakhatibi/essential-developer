//
//  RemoteFeedImageLoaderTests.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 11/28/22.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageDataLoader {
    
    init(client: Any) {
        
    }
}

final class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForeMemoryLeak(client, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }
    
    private final class HTTPClientSpy {
        let requestedURLs = [URL]()
    }
}
