//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 11/27/22.
//

import XCTest
import EssentialFeed

final class FeedImagePresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.location, image.location)
        XCTAssertEqual(viewModel.description, image.description)
    }
    
}
