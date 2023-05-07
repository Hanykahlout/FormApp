//
//  L102Localizer.swift
//  Advertiser
//
//  Created by HanyMac on 1/24/18.
//  Copyright © 2018 Hany Alkahlout. All rights reserved.
//

import UIKit
@IBDesignable
class UIImageViewDesignable: UIImageView {
    
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = UIColor.black
    
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = UIColor.gray
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    @IBInspectable var shadowOpacity: Float = 0
    
    @IBInspectable var flipInRTL: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = cornerRadius
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        
//        if flipInRTL {
//            if MOLHLanguage.currentAppleLanguage().elementsEqual("ar"){
//                if let _img = image {
//                    image =  _img.imageFlippedForRightToLeftLayoutDirection()
//                }
//            }
//        }
    }
}
