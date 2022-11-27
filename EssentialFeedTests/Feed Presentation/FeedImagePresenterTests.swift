//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 11/27/22.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) {
        
    }
}

final class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForeMemoryLeak(view, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, view)
    }
    
    private final class ViewSpy {
        let messages = [Any]()
    }
}
