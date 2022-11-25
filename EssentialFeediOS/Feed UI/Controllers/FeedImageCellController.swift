//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Mohammadreza on 11/12/22.
//

import UIKit

final class FeedImageCellController: FeedImageView {
    private let presenter: FeedImagePresenter<FeedImageCellController, UIImage>
    private let cell = FeedImageCell()
    
    init(presenter: FeedImagePresenter<FeedImageCellController, UIImage>) {
        self.presenter = presenter
    }
    
    func view() -> UITableViewCell {
        presenter.loadImageData()
        return cell
    }
    
    func preload() {
        presenter.loadImageData()
    }
    
    func cancelLoad() {
        presenter.cancelLoad()
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        
        cell.feedImageView.image = viewModel.image
        
        cell.feedImageContainer.isShimmering = viewModel.isLoading
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell.onRetry = presenter.loadImageData
    }
    
}
