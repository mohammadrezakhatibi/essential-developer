//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 11/27/22.
//

import XCTest
import EssentialFeed

final class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingImageData_displayLoadingView() {
        let (sut, view) = makeSUT()
        let model = uniqueImage()
        
        sut.didStartLoadingImageData(for: model)
        
        let message = view.messages.first
        
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(model.description, message?.description)
        XCTAssertEqual(model.location, message?.location)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.image)
    }
    
    func test_didStartLoadingImageData_displayRetryButtonOnFailedImageTransformation() {
        let (sut, view) = makeSUT(imageTransformer: fail)
        let model = uniqueImage()
        
        sut.didFinishLoadingImageData(with: Data(), for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(model.description, message?.description)
        XCTAssertEqual(model.location, message?.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }
    
    func test_didStartLoadingImageData_displayImageOnSuccessfulTransformation() {
        let model = uniqueImage()
        let transformedData = AnyImage()
        
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        
        sut.didFinishLoadingImageData(with: Data(), for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(model.description, message?.description)
        XCTAssertEqual(model.location, message?.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertEqual(message?.image, transformedData)
    }
    
    func test_didStartLoadingImageData_displayRetryButtonOnFailedLoadingData() {
        let model = uniqueImage()
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingImageData(with: anyNSError(), for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(model.description, message?.description)
        XCTAssertEqual(model.location, message?.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertEqual(message?.image, nil)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil }, file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
        trackForeMemoryLeak(view, file: file, line: line)
        trackForeMemoryLeak(sut, file: file, line: line)
        return (sut, view)
    }
    
    private var fail: (Data) -> AnyImage? {
        return { _ in nil }
    }
    
    private struct AnyImage: Equatable {}
    
    private final class ViewSpy: FeedImageView {
        
        var messages = [FeedImageViewModel<AnyImage>]()
        
        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(model)
        }
    }
}
