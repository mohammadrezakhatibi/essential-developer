//
//  WeakVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by mohammadreza on 12/16/22.
//

import Foundation
import EssentialFeed
import UIKit

// Avoid from forcing memory management specific implementation into presenter object
// memory management implementation is belongs to composer not into MVP component
// We use WeakRefVirtualProxy to simulate weak reference
public final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    public init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceErrorView where T: ResourceErrorView {
    public func display(_ viewModel: EssentialFeed.ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceView where T: ResourceView, T.ResourceViewModel == UIImage {
    public func display(_ viewModel: UIImage) {
        object?.display(viewModel)
    }
}
