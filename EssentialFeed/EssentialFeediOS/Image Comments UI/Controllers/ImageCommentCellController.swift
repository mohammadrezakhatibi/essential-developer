//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 1/25/23.
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: CellController {
    
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        tableView.register(for: ImageCommentCell.self)
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.descriptionLabel.text = model.message
        cell.dateLabel.text = model.date
        cell.usernameLabel.text = model.username
        return cell
    }
    
    public func preload() {
        
    }
    
    public func cancelLoad() {
        
    }
}
