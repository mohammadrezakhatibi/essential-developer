//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/12/22.
//

import UIKit

final class FeedImageCellController: FeedImageView {
    private let cell = FeedImageCell()
    var loadImageData: () -> Void
    var cancelLoadData: () -> Void
    
    init(loadImageData: @escaping () -> Void, cancelLoadData: @escaping () -> Void) {
        self.loadImageData = loadImageData
        self.cancelLoadData = cancelLoadData
    }
    
    func view() -> UITableViewCell {
        loadImageData()
        return cell
    }
    
    func preload() {
        loadImageData()
    }
    
    func cancelLoad() {
        cancelLoadData()
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        
        cell.feedImageView.image = viewModel.image
        
        cell.feedImageContainer.isShimmering = viewModel.isLoading
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell.onRetry = loadImageData
    }
    
}
