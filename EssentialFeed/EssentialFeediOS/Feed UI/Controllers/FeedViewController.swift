//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/8/22.
//

import UIKit
import EssentialFeed

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedErrorView {
    
    private var refreshController: FeedRefreshViewController?
    private(set) public var errorView = ErrorView()
    
    var tableModel = [FeedImageCellController]() {
        didSet { tableView.reloadData() }
    }
        
    convenience init(refreshController: FeedRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public func display(_ viewModel: EssentialFeed.FeedErrorViewModel) {
        if let message = viewModel.message {
            self.errorView.show(message: message)
            self.errorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        } else {
            self.errorView.hideMessage()
            self.errorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        
        tableView.register(FeedImageCell.self, forCellReuseIdentifier: "FeedImageCell")
        tableView.prefetchDataSource = self
        tableView.tableHeaderView = errorView
        tableView.separatorStyle = .none
        refreshController?.refresh()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}
