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
    
    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_CONTENT_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_CONTENT_DARK")
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_LIGHT_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_DARK_extraExtraExtraLarge")
    }
    
    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()

        sut.display(feedWithFailedImageLoading())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_DARK")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_FAILED_IMAGE_LOADING_LIGHT_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_FAILED_IMAGE_LOADING_DARK_extraExtraExtraLarge")
    }
    
    // MARK: - Helpler
    
    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
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

private extension ListViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [CellController] = stubs.map { stub in
            let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, onSelect: {})
            stub.controller = cellController
            return CellController(cellController)
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
