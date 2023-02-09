//
//  FeedAcceptanceTests.swift
//  EssentialAppTests
//
//  Created by mohammadreza on 12/16/22.
//

import XCTest
import Foundation
@testable import EssentialApp
import EssentialFeediOS
import EssentialFeed

final class FeedAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysRemoteFeedWhenCustomersHasConnectivity() {
        let sut = launch(httpClient: .online(response), store: .empty)
        
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(sut.renderedFeedImageData(at: 0), makeImageData())
        XCTAssertEqual(sut.renderedFeedImageData(at: 1), makeImageData())
        
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomersHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)
        
        let offlineStore = launch(httpClient: .offline, store: sharedStore)
        XCTAssertEqual(offlineStore.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(offlineStore.renderedFeedImageData(at: 0), makeImageData())
        XCTAssertEqual(offlineStore.renderedFeedImageData(at: 1), makeImageData())
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 0)
    }
    
    func test_onFeedImageSelection_displaysComment() {
         let comments = showCommentsForFirstFeedImage()

        XCTAssertEqual(comments.numberOfRenderedCommentsViews(), 1)
        XCTAssertEqual(comments.commentMessage(at: 0), makeCommentMessage())
        XCTAssertEqual(comments.commentUsername(at: 0), "a username")
    }
    
    // MARK: - Helpers
    
    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryFeedStore = .empty
    ) -> ListViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func showCommentsForFirstFeedImage() -> ListViewController {
        let feed = launch(httpClient: .online(response), store: .empty)
        
        feed.simulateTapOnFeedImage(at: 0)
        RunLoop.current.run(until: Date())
        
        let nav = feed.navigationController
        return nav?.topViewController as! ListViewController
        
    }
    
    private class HTTPClientStub: HTTPClient {
        
        private class Task: HTTPClientTask {
            func cancel() {}
        }
        
        private let stub: (URL) -> HTTPClient.Result
        
        init(stub: @escaping (URL) -> HTTPClient.Result) {
            self.stub = stub
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            completion(stub(url))
            return Task()
        }
        
        static var offline: HTTPClientStub {
            return HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0))})
        }
        
        static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
            return HTTPClientStub(stub: { url in .success(stub(url))})
        }
    }

    private class InMemoryFeedStore: FeedStore, FeedImageDataStore {
        private var feedCache: CachedFeed?
        private var feedImageDataCache: [URL: Data] = [:]

        func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
            feedCache = nil
            completion(.success(()))
        }

        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
            feedCache = CachedFeed(feed: feed, timestamp: timestamp)
            completion(.success(()))
        }

        func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
            completion(.success(feedCache))
        }

        func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
            feedImageDataCache[url] = data
            completion(.success(()))
        }

        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
            completion(.success(feedImageDataCache[url]))
        }

        static var empty: InMemoryFeedStore {
            InMemoryFeedStore()
        }
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/image1", "/image2":
            return makeImageData()
                
        case "/essential-feed/v1/image/2239CBA2-CB35-4392-ADC0-24A37D38E010/comments":
            return makeCommentsData()
        
        case "/essential-feed/v1/feed":
            return makeFeedData()
                
        default:
            return Data()
        }
        
    }
    
    private func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items" : [
            ["id": "2239CBA2-CB35-4392-ADC0-24A37D38E010", "image": "http://feed.com/image1"],
            ["id": UUID().uuidString, "image": "http://feed.com/image2"],
        ]])
    }
    
    private func makeCommentsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items" : [
            [
                "id": UUID().uuidString,
                "message": makeCommentMessage(),
                "created_at": "2020-05-20T11:24:59+0000",
                "author": [
                    "username": "a username"
                ]
            ],
        ]])
    }
    
    private func makeCommentMessage() -> String {
        "a message"
    }
}
