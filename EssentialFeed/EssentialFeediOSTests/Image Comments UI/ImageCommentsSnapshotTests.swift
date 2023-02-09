//
//  ImageCommentsSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 1/25/23.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

final class ImageCommentsSnapshotTests: XCTestCase {
    
    func test_listWithComments() {
        let sut = makeSUT()
        
        sut.display(comments())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "IMAGE_COMMENT_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "IMAGE_COMMENT_DARK")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENT_LIGHT_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENT_DARK_extraExtraExtraLarge")
    }
    
    
    // MARK: - Helpler
    
    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func comments() -> [CellController] {
        commentControllers().map { CellController($0) }
    }
    
    private func commentControllers() -> [ImageCommentCellController] {
        return [
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                    date: "1000 days ago",
                    username: "a.long.long.long.long.long.username")
            ),
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "The East Side Gallery is an open-air gallery in Berlin.",
                    date: "10 days ago",
                    username: "a.username")
            ),
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "nice.",
                    date: "now",
                    username: "a")
            ),
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "How it possible.",
                    date: "1 hour ago",
                    username: "username")
            ),
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "The gallery has official status as a Denkmal, or heritage-protected landmark.",
                    date: "21 days ago",
                    username: "black")
            ),
        ]
    }
}
