//
//  FeedViewController+Helpers.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 11/25/22.
//
import UIKit
import EssentialFeediOS

extension ListViewController {
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        feedImageView(at: index) as? FeedImageCell
    }
    
    func simulateFeedImageViewNotVisible(at row: Int) {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    }
    
    func simulateFeedImageNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func simulateTapOnErrorMessage() {
        errorView.button.simulateTap()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }
    
    var errorMessage: String? {
        return errorView.message
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    func numberOfRenderedCommentsViews() -> Int {
        return tableView.numberOfRows(inSection: commentsSection)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFeedImageViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    private var feedImagesSection: Int {
        return 0
    }
    
    private var commentsSection: Int {
        return 0
    }
    
    func commentMessage(at index: Int) -> String? {
        return commentsView(at: index)?.descriptionLabel.text
    }
    
    func commentUsername(at index: Int) -> String? {
        return commentsView(at: index)?.usernameLabel.text
    }
    
    func commentDate(at index: Int) -> String? {
        return commentsView(at: index)?.dateLabel.text
    }
    
    func commentsView(at row: Int) -> ImageCommentCell? {
        guard numberOfRenderedCommentsViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: commentsSection)
        return ds?.tableView(tableView, cellForRowAt: index) as? ImageCommentCell
    }

}
