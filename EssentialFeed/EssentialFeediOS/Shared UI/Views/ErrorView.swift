//
//  Copyright © Essential Developer. All rights reserved.
//

import UIKit

public final class ErrorView: UIView {
    private(set) public var button = UIButton()

    public var message: String? {
        get { return isVisible ? button.title(for: .normal) : nil }
    }

    private var isVisible: Bool {
        return alpha > 0
    }
    
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = .red
        button.titleLabel?.numberOfLines = 0
        button.setTitle(nil, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        alpha = 0
        
        addSubview(button)
        button.stickToEdge(of: self)
    }

    func show(message: String) {
        button.setTitle(message, for: .normal)

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @objc func buttonTap() {
        hideMessage()
    }
    
    func hideMessage() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed {
                    self.button.setTitle(nil, for: .normal)
                }
            })
    }
}

private extension UIView {
    func stickToEdge(of parent: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: parent.widthAnchor, constant: constant),
            heightAnchor.constraint(equalTo: parent.heightAnchor, constant: constant),
            centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            centerYAnchor.constraint(equalTo: parent.centerYAnchor),
        ])
    }
}
