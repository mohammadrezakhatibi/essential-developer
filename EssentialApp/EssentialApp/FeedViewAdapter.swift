//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 12/16/22.
//

import Foundation
import EssentialFeed
import UIKit
import EssentialFeediOS

public final class FeedViewAdapter: ResourceView {
    private weak var controller: FeedViewController?
    private let loader: (URL) -> FeedImageDataLoader.Publisher
    
    init(forwardingTo controller: FeedViewController, loader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        self.loader = loader
    }
    
    public func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map{ model in
            
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: loader)
            let view = FeedImageCellController(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init)
            
            return view
        })
    }
}
