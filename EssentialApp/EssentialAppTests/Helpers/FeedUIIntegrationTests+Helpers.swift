//
//  FeedUIIntegrationTests+Helpers.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 11/25/22.
//

import Foundation
import EssentialFeed
import EssentialFeediOS
import XCTest

extension FeedUIIntegrationTests {
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) { }
    }
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }
    
}
