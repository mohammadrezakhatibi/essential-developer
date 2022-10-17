//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 10/17/22.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
}
protocol HTTPSessionTask {
    func resume()
}
class URLSessionHTTPClient {
    var session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_resumeDataTaskWithURL() {
        let url = URL(string: "http://a-url.com")!
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
         
        sut.get(from: url) { _ in }
    
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://a-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "error", code: 1)
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "Wait for completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
               XCTAssertEqual(receivedError, error)
            default:
               XCTFail("Should be failed with \(error) instead \(result)")
            }
            exp.fulfill()
            
        }
    
        wait(for: [exp], timeout: 1.0)
    }
    
    private class HTTPSessionSpy: HTTPSession {
        var receivedURLs = [URL]()
        private var stub = [URL: Stub]()
        
        private struct Stub {
            var task: HTTPSessionTask
            var error: Error?
        }
        
        func stub(url: URL, task: HTTPSessionTask = URLSessionDataTaskSpy(), error: Error? = nil) {
            stub[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
            receivedURLs.append(url)
            guard let stub = stub[url] else {
                fatalError("Couldn't find stub")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class URLSessionDataTaskSpy: HTTPSessionTask {
        
        var resumeCallCount = 0
        func resume() {
            resumeCallCount += 1
        }
    }
}
