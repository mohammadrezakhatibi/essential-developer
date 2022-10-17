//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 10/17/22.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
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
    
    func test_getFromURL_failsOnRequestError() {
        URLProtocolSpy.startInterceptingRequests()
        let url = URL(string: "http://a-url.com")!
        let error = NSError(domain: "a error", code: 1)
        URLProtocolSpy.stub(url: url, data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
            default:
               XCTFail("Should be failed with \(error) instead \(result)")
            }
            exp.fulfill()
            
        }
    
        wait(for: [exp], timeout: 1.0)
        URLProtocolSpy.stopInterceptingRequests()
    }
    
    private class URLProtocolSpy: URLProtocol {
        var receivedURLs = [URL]()
        private static var stub = [URL: Stub]()
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(url: URL, data: Data?, response: URLResponse?, error: Error? = nil) {
            stub[url] = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolSpy.self)
        }
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolSpy.self)
            stub = [:]
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else {
                return false
            }
            
            return URLProtocolSpy.stub[url] != nil
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }
        
        override func startLoading() {
            
            guard let url = request.url, let stub = URLProtocolSpy.stub[url] else { return }
            
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
                
        }
        
        override func stopLoading() {
            
        }
        
    }
}
