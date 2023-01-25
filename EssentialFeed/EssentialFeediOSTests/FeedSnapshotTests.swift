//
//  FeedSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 1/25/23.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

final class FeedSnapshotTests: XCTestCase {
    
    func test_emptyList() {
        let sut = makeSUT()
        
        sut.display(emptyFeed())
        
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .light)), named: "EMPTY_FEED_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .dark)), named: "EMPTY_FEED_DARK")
    }
    
    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .light)), named: "FEED_WITH_CONTENT_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .dark)), named: "FEED_WITH_CONTENT_DARK")
    }
    
    func test_feedWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(ResourceErrorViewModel(message: "An error message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .light)), named: "FEED_WITH_ERROR_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .dark)), named: "FEED_WITH_ERROR_DARK")
    }
    
    func test_feedWithMultilineErrorMessage() {
        let sut = makeSUT()
        
        sut.display(ResourceErrorViewModel(message: "An multiline \nerror message \nis so so so so amazing"))
        
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .light)), named: "FEED_WITH_MULTILINE_ERROR_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .dark)), named: "FEED_WITH_MULTILINE_ERROR_DARK")
    }
    
    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()

        sut.display(feedWithFailedImageLoading())

        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_DARK")
    }
    
    // MARK: - Helpler
    
    private func makeSUT() -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! FeedViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyFeed() -> [FeedImageCellController] {
        return []
    }
    
    private func feedWithContent() -> [ImageStub] {
        return [
            ImageStub(
                description: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                location: "East Side Gallery\nMemorial in Berlin, Germany",
                image: UIImage.make(withColor: .red)
            ),
            ImageStub(
                description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                location: "Garth Pier",
                image: UIImage.make(withColor: .green)
            )
        ]
    }
    
    private func feedWithFailedImageLoading() -> [ImageStub] {
        return [
            ImageStub(
                description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                location: "Cannon Street, London",
                image: nil
            ),
            ImageStub(
                description: nil,
                location: "Brighton Seafront",
                image: nil
            )
        ]
    }
}

private extension FeedViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [FeedImageCellController] = stubs.map { stub in
            let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub)
            stub.controller = cellController
            return cellController
        }

        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {
    let image: UIImage?
    weak var controller: FeedImageCellController?
    let viewModel: FeedImageViewModel

    init(description: String?, location: String?, image: UIImage?) {
        self.image = image
        viewModel = FeedImageViewModel(description: description, location: location)
    }

    func didRequestImage() {
        if let image {
            controller?.display(image)
        } else {
            controller?.display(ResourceErrorViewModel(message: "any error message"))
        }
        controller?.display(ResourceLoadingViewModel(isLoading: false))
    }

    func didCancelImageRequest() {}
}
