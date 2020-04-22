//
//  UIView+Shadow.swift
//  MultiTabBrowserApp
//
//  Created by Alex Brown on 09/12/2019.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSurroundShadow(color: CGColor = UIColor.black.cgColor) {
        let opacity: Float = 0.5
        addCustomShadow(offset: CGSize(width: 0, height: 0), radius: 2, opacity: opacity, color: color)
    }
    
    func addDepthShadow(offset: CGFloat = 3, radius: CGFloat = 3) {
        let opacity: Float = 0.5
        addCustomShadow(offset: CGSize(width: offset, height: offset), radius: radius, opacity: opacity)
    }
    
    func subViewShadow() {
        let opacity: Float = 0.3
        addCustomShadow(offset: CGSize(width: 0, height: 0), radius: 3, opacity: opacity)
    }
    
    func addCustomShadow(offset: CGSize, radius: CGFloat, opacity: Float, color: CGColor = UIColor.black.cgColor) {
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
