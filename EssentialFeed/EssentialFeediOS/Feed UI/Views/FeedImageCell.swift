//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 11/9/22.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public let locationContainer = UIView()
    
    public lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 180/256, green: 180/256, blue: 180/256, alpha: 1)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 88/256, green: 88/256, blue: 88/256, alpha: 1)
        return label
    }()
    
    public let feedImageContainer = UIView()
    public lazy var pinIcon: UILabel = {
        let pin = UILabel()
        pin.font = .preferredFont(forTextStyle: .subheadline)
        pin.adjustsFontForContentSizeCategory = true
        pin.text = "📍"
        return pin
    }()
    
    
    public lazy var feedImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(red: 244/256, green: 244/256, blue: 244/256, alpha: 1)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "exclamationmark.arrow.circlepath"), for: .normal)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 220/256, green: 220/256, blue: 220/256, alpha: 1), for: .normal )
        return button
    }()
    
    private var containerStackView: UIStackView?
    
    private let descriptionLabelContainer = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    public var isLoading: Bool = true {
        didSet {
            if isLoading {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    var onRetry: (() -> Void)?
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addLayoutAndSubviews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLayoutAndSubviews() {
        accessibilityIdentifier = "feed-image-cell"
        feedImageView.accessibilityIdentifier = "feed-image-view"
        containerStackView = UIStackView()
        containerStackView?.alignment = .top
        containerStackView?.axis = .vertical
        containerStackView?.distribution = .fill
        containerStackView?.addArrangedSubview(locationContainer)
        containerStackView?.addArrangedSubview(feedImageContainer)
        containerStackView?.addArrangedSubview(descriptionLabelContainer)
        
        locationContainer.addSubview(locationLabel)
        locationContainer.addSubview(pinIcon)
        
        pinIcon.translatesAutoresizingMaskIntoConstraints = false
        pinIcon
            .widthAnchor
            .constraint(equalToConstant: 24)
            .isActive = true
        pinIcon
            .heightAnchor
            .constraint(equalToConstant: 24)
            .isActive = true
        pinIcon
            .topAnchor
            .constraint(equalTo: locationContainer.topAnchor, constant: 16)
            .isActive = true
        pinIcon
            .leftAnchor
            .constraint(equalTo: locationContainer.leftAnchor, constant: 16)
            .isActive = true
        
        locationLabel
            .centerYAnchor
            .constraint(equalTo: pinIcon.centerYAnchor)
            .isActive = true
        locationContainer
            .rightAnchor
            .constraint(equalTo: locationLabel.rightAnchor, constant: 16)
            .isActive = true
        locationLabel
            .leftAnchor
            .constraint(equalTo: pinIcon.rightAnchor, constant: 4)
            .isActive = true
        
        locationLabel
            .bottomAnchor
            .constraint(equalTo: locationContainer.bottomAnchor)
            .isActive = true
        
        descriptionLabelContainer.addSubview(descriptionLabel)
        descriptionLabel
            .centerXAnchor
            .constraint(equalTo: descriptionLabelContainer.centerXAnchor)
            .isActive = true
        descriptionLabel
            .topAnchor
            .constraint(equalTo: descriptionLabelContainer.topAnchor)
            .isActive = true
        descriptionLabel
            .bottomAnchor
            .constraint(equalTo: descriptionLabelContainer.bottomAnchor, constant: 0)
            .isActive = true
        descriptionLabel
            .leadingAnchor
            .constraint(equalTo: descriptionLabelContainer.leadingAnchor, constant: 16)
            .isActive = true
        descriptionLabelContainer
            .trailingAnchor
            .constraint(equalTo: descriptionLabel.trailingAnchor, constant: 16)
            .isActive = true
        
        feedImageContainer
            .widthAnchor
            .constraint(equalTo: containerStackView!.widthAnchor)
            .isActive = true
        feedImageContainer
            .heightAnchor
            .constraint(equalTo: containerStackView!.widthAnchor)
            .isActive = true
        
        feedImageContainer.addSubview(feedImageView)
        feedImageView.stickToEdge(of: feedImageContainer, constant: -32)
        
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        feedImageContainer.addSubview(loadingIndicator)
        loadingIndicator
            .centerXAnchor
            .constraint(equalTo: feedImageContainer.centerXAnchor)
            .isActive = true
        
        loadingIndicator
            .centerYAnchor
            .constraint(equalTo: feedImageContainer.centerYAnchor)
            .isActive = true
        
        feedImageRetryButton.isHidden = true
        feedImageRetryButton.translatesAutoresizingMaskIntoConstraints = false
        feedImageContainer.addSubview(feedImageRetryButton)
        feedImageRetryButton
            .centerXAnchor
            .constraint(equalTo: feedImageContainer.centerXAnchor)
            .isActive = true
        
        feedImageRetryButton
            .centerYAnchor
            .constraint(equalTo: feedImageContainer.centerYAnchor)
            .isActive = true
        
        feedImageRetryButton
            .widthAnchor
            .constraint(equalToConstant: 44)
            .isActive = true
        
        feedImageRetryButton
            .heightAnchor
            .constraint(equalToConstant: 44)
            .isActive = true
        
        addSubview(containerStackView!)
        containerStackView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView!.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: containerStackView!.trailingAnchor),
            containerStackView!.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: containerStackView!.bottomAnchor, constant: 16),
        ])
    }
    
    public override func prepareForReuse() {
        containerStackView = nil
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
