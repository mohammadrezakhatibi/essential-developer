//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 10/17/22.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject,
                             file: StaticString = #filePath,
                             line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
