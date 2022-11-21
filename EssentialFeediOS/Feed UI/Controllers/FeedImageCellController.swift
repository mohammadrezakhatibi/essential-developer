//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/12/22.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func loadImageData()
    func cancelImageLoadData()
}

final class FeedImageCellController: FeedImageView{
    
    private let cell = FeedImageCell()
    private let delegate: FeedImageCellControllerDelegate?
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view() -> UITableViewCell {
        delegate?.loadImageData()
        return cell
    }
    
    func preload() {
        delegate?.loadImageData()
    }
    
    func cancelLoad() {
        delegate?.cancelImageLoadData()
    }
    
    func display(with viewModel: FeedImageViewModel<UIImage>) {
        cell.feedImageContainer.isShimmering = viewModel.isLoading
        cell.feedImageRetryButton.isHidden = !viewModel.isRetry
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.feedImageView.image = viewModel.image
        cell.onRetry = delegate?.loadImageData
    }
}
