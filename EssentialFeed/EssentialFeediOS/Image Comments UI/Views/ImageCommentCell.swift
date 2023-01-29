//
//  ImageCommentCell.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 1/25/23.
//

import UIKit

public final class ImageCommentCell: UITableViewCell {
    public let headerStackView = UIStackView()
    
    public lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.label
        return label
    }()
    
    private var containerStackView: UIStackView!
    
    private let descriptionLabelContainer = UIView()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addLayoutAndSubviews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLayoutAndSubviews() {
        
        containerStackView = UIStackView()
        containerStackView?.alignment = .top
        containerStackView?.axis = .vertical
        containerStackView.spacing = 8
        containerStackView?.distribution = .fill
        containerStackView?.addArrangedSubview(headerStackView)
        containerStackView?.addArrangedSubview(descriptionLabel)
        
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        usernameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        usernameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        headerStackView.alignment = .center
        headerStackView.axis = .horizontal
        headerStackView.distribution = .equalSpacing
        headerStackView.spacing = 16
        
        headerStackView.addArrangedSubview(usernameLabel)
        headerStackView.addArrangedSubview(dateLabel)
        
        
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView
            .widthAnchor
            .constraint(equalTo: containerStackView.widthAnchor)
            .isActive = true
        
        
        addSubview(containerStackView!)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView
            .widthAnchor
            .constraint(equalTo: widthAnchor, constant: -32)
            .isActive = true
        containerStackView
            .centerXAnchor
            .constraint(equalTo: centerXAnchor)
            .isActive = true
        containerStackView
            .topAnchor
            .constraint(equalTo: topAnchor)
            .isActive = true
        containerStackView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -32)
            .isActive = true
    }
}

private extension UIView {
    func stickToEdge(of parent: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: parent.widthAnchor, constant: constant).isActive = true
        heightAnchor.constraint(equalTo: parent.heightAnchor ).isActive = true
        centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
    }
}
