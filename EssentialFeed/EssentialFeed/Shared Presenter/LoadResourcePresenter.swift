//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Mohammadreza on 1/21/23.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    func display(_ viewModel: ResourceViewModel)
}

public protocol ResourceLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public protocol ResourceErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    private let resourceView: View
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    private let mapper: Mapper
    
    private var resourceLoadError: String {
        return NSLocalizedString(
            "GENERIC_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed...")
    }
    
    public init(resourceView: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView, mapper: @escaping (Resource) -> View.ResourceViewModel) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        errorView.display(FeedErrorViewModel(message: .none))
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoading(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(message: resourceLoadError))
    }
}
