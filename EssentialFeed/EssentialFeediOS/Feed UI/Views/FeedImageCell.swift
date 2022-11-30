//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 11/9/22.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()
    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let containerStackView = UIStackView()
    private let descriptionLabelContainer = UIView()
    private let headerStackView = UIStackView()
    
    var onRetry: (() -> Void)?
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addLayoutAndSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLayoutAndSubviews() {
        locationLabel.textColor = .black
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        
        headerStackView.spacing = 16
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .equalSpacing
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerStackView.addArrangedSubview(locationLabel)
        
        containerStackView.addArrangedSubview(headerStackView)
        containerStackView.addArrangedSubview(feedImageContainer)
        containerStackView.addArrangedSubview(descriptionLabelContainer)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabelContainer.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: descriptionLabelContainer.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: descriptionLabelContainer.topAnchor, constant: 16).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: descriptionLabelContainer.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: descriptionLabelContainer.trailingAnchor, constant: -16).isActive = true
        
        containerStackView.alignment = .top
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        
        addSubview(containerStackView)
        containerStackView.stickToEdge(of: self)
        
        headerStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor).isActive = true
        headerStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        feedImageContainer.backgroundColor = .lightGray
        feedImageContainer.widthAnchor.constraint(equalTo: containerStackView.widthAnchor).isActive = true
        feedImageContainer.heightAnchor.constraint(equalTo: containerStackView.widthAnchor).isActive = true
        
        feedImageContainer.addSubview(feedImageView)
        feedImageView.stickToEdge(of: feedImageContainer, constant: -16)
        
    }
}

private extension UIView {
    func stickToEdge(of parent: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: parent.widthAnchor, constant: constant).isActive = true
        heightAnchor.constraint(equalTo: parent.heightAnchor, constant: constant).isActive = true
        centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
    }
}
