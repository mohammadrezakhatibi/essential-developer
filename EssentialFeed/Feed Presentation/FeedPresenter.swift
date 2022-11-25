//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by mohammadreza on 11/25/22.
//

import Foundation

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public struct FeedLoadingViewModel {
    public  let isLoading: Bool
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public struct FeedErrorViewModel {
    public let message: String?
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public final class FeedPresenter {
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    
    private var feedLoadError: String {
        return NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed...")
    }
    
    public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }
    
    public func didStartLoadingFeed() {
        errorView.display(FeedErrorViewModel(message: .none))
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(message: feedLoadError))
    }
}
