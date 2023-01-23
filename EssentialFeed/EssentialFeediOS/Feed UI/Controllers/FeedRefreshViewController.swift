//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/12/22.
//

import UIKit
import EssentialFeed

public protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()
    
    private var delegate: FeedRefreshViewControllerDelegate?
    
    public init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc func refresh() {
        delegate?.didRequestFeedRefresh()
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.display(viewModel) }
        }
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
}
