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
    
    private let loader: () -> RemoteLoader<Resource>.Publisher
    var presenter: LoadResourcePresenter<Resource, View>?
    private var cancellable: Cancellable?
    
    init(loader: @escaping () -> RemoteLoader<Resource>.Publisher) {
        self.loader = loader
    }
    
    func loadResource() {
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

extension LoadResourcePresentationAdapter: FeedRefreshViewControllerDelegate where Resource == [FeedImage] {

    public func didRequestFeedRefresh() {
        loadResource()
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    
    public func didRequestImage() {
        loadResource()
    }
    
    public func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
