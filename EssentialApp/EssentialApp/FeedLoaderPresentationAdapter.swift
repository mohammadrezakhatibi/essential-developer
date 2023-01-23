//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 12/16/22.
//

import EssentialFeed
import EssentialFeediOS

public final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
    
    private let feedLoader: FeedLoader
    var presenter: LoadResourcePresenter<[FeedImage], FeedViewAdapter>?
    
    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    public func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoading(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
    
}
