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
        
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        alpha = 0
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
