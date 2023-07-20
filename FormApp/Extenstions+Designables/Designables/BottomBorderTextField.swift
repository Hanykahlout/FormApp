//
//  L102Localizer.swift
//  Advertiser
//
//  Created by HanyMac on 1/24/18.
//  Copyright © 2018 Hany Alkahlout. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BottomBorderTextField: UITextField {
    
    @IBInspectable var LineColor: UIColor = UIColor.white
    @IBInspectable var LineHeight: CGFloat = 1.0
    @IBInspectable var LineSpace: CGFloat = 0.0
    
    @IBInspectable var placeholderTextColor: UIColor = UIColor.white
    
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
      
        
        borderStyle = UITextField.BorderStyle.none
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height + LineSpace, width: self.frame.width, height: LineHeight)
        bottomLine.backgroundColor = LineColor.cgColor
        layer.addSublayer(bottomLine)
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView2()
        }
    }
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var imagePadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = rightImage {
          rightViewMode = UITextField.ViewMode.always
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .center
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
    func updateView2() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .center
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
}
