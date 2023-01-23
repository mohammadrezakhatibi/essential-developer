//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 12/16/22.
//

import EssentialFeed
import EssentialFeediOS

public final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    
    private let loader: () -> FeedLoader.Publisher
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: @escaping () -> FeedLoader.Publisher) {
        self.loader = loader
    }
    
}

extension LoadResourcePresentationAdapter: FeedRefreshViewControllerDelegate where Resource == [FeedImage] {

    public func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        
        loader().sink { completion in
            switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.presenter?.didFinishLoading(with: error)
            }
        } receiveValue: { [weak self] resource in
            self?.presenter?.didFinishLoading(with: resource)
        }
    }
}
