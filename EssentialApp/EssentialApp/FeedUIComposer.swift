//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/12/22.
//

import EssentialFeed
import UIKit
import EssentialFeediOS

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposeWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = FeedViewController(refreshController: refreshController)
        feedController.title = FeedPresenter.title
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(forwardingTo: feedController, loader: MainQueueDispatchDecorator(decoratee: imageLoader)),
            loadingView:  WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map)
        
        return feedController
    }
}
