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
        label.textColor = UIColor(red: 180/256, green: 180/256, blue: 180/256, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 180/256, green: 180/256, blue: 180/256, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 88/256, green: 88/256, blue: 88/256, alpha: 1)
        return label
    }()
    
    private var containerStackView: UIStackView?
    
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
        containerStackView?.distribution = .fill
        containerStackView?.addArrangedSubview(headerStackView)
        containerStackView?.addArrangedSubview(descriptionLabelContainer)
        
        headerStackView.alignment = .center
        headerStackView.axis = .horizontal
        headerStackView.distribution = .fill
        
        
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
        descriptionLabel
            .trailingAnchor
            .constraint(equalTo: descriptionLabelContainer.trailingAnchor, constant: -16)
            .isActive = true
        
        
        addSubview(containerStackView!)
        containerStackView?.stickToEdge(of: self)
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
