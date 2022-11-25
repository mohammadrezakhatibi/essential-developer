//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by mohammadreza on 11/25/22.
//

import XCTest


final class FeedPresenter {
    init(view: Any) {
        
    }
}

final class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    private class ViewSpy {
        
        let messages = [Any]()
    }
}
