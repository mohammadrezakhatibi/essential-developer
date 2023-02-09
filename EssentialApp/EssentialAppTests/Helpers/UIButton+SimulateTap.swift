//
//  UIButton+SimulateTap.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 11/25/22.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
