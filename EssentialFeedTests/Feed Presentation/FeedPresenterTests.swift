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
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    //MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackForeMemoryLeak(view, file: file, line: line)
        trackForeMemoryLeak(view, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy {
        
        let messages = [Any]()
    }
}
