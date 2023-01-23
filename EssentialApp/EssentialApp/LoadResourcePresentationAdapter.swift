//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 12/16/22.
//

import EssentialFeed
import EssentialFeediOS

public final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    
    private let loader: FeedLoader
    var presenter: LoadResourcePresenter<Resource, View>?
    
    public init(loader: FeedLoader) {
        self.loader = loader
    }
    
}

extension LoadResourcePresentationAdapter: FeedRefreshViewControllerDelegate where Resource == [FeedImage] {

    public func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        loader.load { [weak self] result in
            switch result {
            case let .success(resource):
                self?.presenter?.didFinishLoading(with: resource)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}
