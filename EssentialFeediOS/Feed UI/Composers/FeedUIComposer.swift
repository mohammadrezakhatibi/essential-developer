//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/12/22.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposeWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = FeedViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = FeedPresenter(feedView: FeedViewAdapter(forwardingTo: feedController, loader: imageLoader), loadingView:  WeakRefVirtualProxy(refreshController))
        
        return feedController
    }
}

// Avoid from forcing memory management specific implementation into presenter object
// memory management implementation is belongs to composer not into MVP component
// We use WeakRefVirtualProxy to simulate weak reference

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(with viewModel: FeedImageViewModel<UIImage>) {
        object?.display(with: viewModel)
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let loader: FeedImageDataLoader
    
    init(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) {
        self.controller = controller
        self.loader = loader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map{ model in
            let adapter = FeedLoadImagePresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: loader)
            let view = FeedImageCellController(delegate: adapter)
            let presenter = FeedImagePresenter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            adapter.presenter = presenter
            return view
        }
    }
}

private final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
    
}

private final class FeedLoadImagePresentationAdapter<View: FeedImageView, UIImage>: FeedImageCellControllerDelegate where View.Image == UIImage {
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    var presenter: FeedImagePresenter<View, UIImage>?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func loadImageData() {
        presenter?.didStartLoadImageData(for: model)
        let model = self.model
        task = imageLoader.loadImageData(from: self.model.url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadImageData(with: data, for: model)
            case let .failure(error):
                self?.presenter?.didFinishLoadImageData(with: error, for: model)
                
            }
        }
    }
    
    func cancelImageLoadData() {
        task?.cancel()
    }
    
    
}
