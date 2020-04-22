//
//  TextField.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/17.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TextField: UITextField {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialErrorIcon()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        initialErrorIcon()
    }
    
    func initialErrorIcon() {
        let errorImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 16))
        errorImageView.image = UIImage(named: "error")
        errorImageView.contentMode = .scaleAspectFit
        
        self.rightView = errorImageView
        self.rightViewMode = .always
        self.rightView?.isHidden = true
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor(red: 229, green: 229, blue: 229, alpha: 0.75) {
        didSet {
            let attributedString = [
                NSAttributedString.Key.foregroundColor: placeholderColor,
                NSAttributedString.Key.font: self.font!
            ]
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributedString)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor(red: 229, green: 229, blue: 229, alpha: 0.75) {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
