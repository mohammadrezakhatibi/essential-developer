//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 11/27/22.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    associatedtype Image
    
    func display(_ model: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage)  {
        guard let image = imageTransformer(data) else {
            return view.display(FeedImageViewModel(
                description: model.description,
                location: model.location,
                image: nil,
                isLoading: false,
                shouldRetry: true))
        }
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: false,
            shouldRetry: false))
    }
}

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
        let data = Data("a data".utf8)
        
        sut.didFinishLoadingImageData(with: data, for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(model.description, message?.description)
        XCTAssertEqual(model.location, message?.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }
    
    func test_didStartLoadingImageData_displayImageOnSuccessfulTransformation() {
        let data = Data()
        let model = uniqueImage()
        let transformedData = AnyImage()
        
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        
        sut.didFinishLoadingImageData(with: data, for: model)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(model.description, message?.description)
        XCTAssertEqual(model.location, message?.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertEqual(message?.image, transformedData)
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
