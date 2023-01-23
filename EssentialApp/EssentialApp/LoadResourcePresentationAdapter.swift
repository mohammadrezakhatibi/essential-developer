//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 12/16/22.
//

import EssentialFeed
import EssentialFeediOS
import Combine

public final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    
    private let loader: () -> RemoteLoader.Publisher
    var presenter: LoadResourcePresenter<Resource, View>?
    private var cancellable: Cancellable?
    
    init(loader: @escaping () -> RemoteLoader.Publisher) {
        self.loader = loader
    }
    
}

extension LoadResourcePresentationAdapter: FeedRefreshViewControllerDelegate where Resource == [FeedImage] {

    public func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        
        cancellable = loader().sink { [weak self] completion in
            switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
            }
        } receiveValue: { [weak self] resource in
            self?.presenter?.didFinishLoading(with: resource)
        }
    }
}
