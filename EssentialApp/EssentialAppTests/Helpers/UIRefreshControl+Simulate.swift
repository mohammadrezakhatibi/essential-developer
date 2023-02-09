//
//  UIRefreshControl+simulate.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 11/25/22.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
