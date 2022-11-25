//
//  UIImage+Make.swift
//  EssentialFeediOSTests
//
//  Created by mohammadreza on 11/25/22.
//

import UIKit

extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        return UIGraphicsImageRenderer(bounds: rect, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }
}
