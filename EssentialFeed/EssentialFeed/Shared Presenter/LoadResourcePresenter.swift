//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 1/21/23.
//

import Foundation

public protocol ResourceView {
    func display(_ viewModel: String)
}

public protocol ResourceLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public protocol ResourceErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public final class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    private let resourceView: ResourceView
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    private let mapper: Mapper
    
    private var resourceLoadError: String {
        return NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed...")
    }
    
    public init(resourceView: ResourceView, loadingView: ResourceLoadingView, errorView: ResourceErrorView, mapper: @escaping (String) -> String) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        errorView.display(FeedErrorViewModel(message: .none))
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(message: resourceLoadError))
    }
}
