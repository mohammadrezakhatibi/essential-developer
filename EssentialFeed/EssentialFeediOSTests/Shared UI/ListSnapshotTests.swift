//
//  ListSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 1/25/23.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

final class ListSnapshotTests: XCTestCase {
    
    func test_emptyList() {
        let sut = makeSUT()
        
        sut.display(emptyList())
        
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .light)), named: "EMPTY_LIST_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .dark)), named: "EMPTY_LIST_DARK")
    }
    
    func test_listWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(ResourceErrorViewModel(message: "An error message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .light)), named: "LIST_WITH_ERROR_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .dark)), named: "LIST_WITH_ERROR_DARK")
    }
    
    func test_listWithMultilineErrorMessage() {
        let sut = makeSUT()
        
        sut.display(ResourceErrorViewModel(message: "This is \na multiline \nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .light)), named: "LIST_WITH_MULTILINE_ERROR_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13Pro(style: .dark)), named: "LIST_WITH_MULTILINE_ERROR_DARK")
    }
    
    // MARK: - Helpler
    
    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyList() -> [CellController] {
        return []
    }
}
