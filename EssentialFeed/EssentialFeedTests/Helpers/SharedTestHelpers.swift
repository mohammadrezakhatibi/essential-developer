//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 10/29/22.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "an error", code: 1)
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["items": items]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
