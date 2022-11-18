//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/12/22.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()
    
    private var loadFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    @objc func refresh() {
        loadFeed()
    }

    func display(_ viewModel: FeedLoadingViewModel) {
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
