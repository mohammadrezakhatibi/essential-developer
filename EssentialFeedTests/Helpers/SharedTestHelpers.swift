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
