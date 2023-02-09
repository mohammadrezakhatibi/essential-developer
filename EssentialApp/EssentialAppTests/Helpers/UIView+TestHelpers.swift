//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Mohammadreza on 12/17/22.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
