//
//  UIControl+Simulate.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 11/25/22.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
