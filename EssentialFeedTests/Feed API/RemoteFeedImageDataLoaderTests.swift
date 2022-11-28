//
//  RemoteFeedImageLoaderTests.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 11/28/22.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageDataLoader {
    
    var client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadData(from url: URL) {
        client.get(from: url, completion: { _ in })
    }
}

final class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestDataFromURL() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        
        sut.loadData(from: url)
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForeMemoryLeak(client, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(url)
        }
    }
}
