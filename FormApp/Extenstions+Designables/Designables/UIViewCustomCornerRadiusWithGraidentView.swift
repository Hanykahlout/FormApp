//
//  UIViewCustomCornerRadiusWithGraidentView.swift
//  Aloo
//
//  Created by Hany Alkahlout on 23/09/2021.
//

import UIKit

class UIViewCustomCornerRadiusWithGraidentView: UIViewCustomCornerRadius{
    
    var gradient: CAGradientLayer?
    @IBInspectable var firstColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.8862745098, blue: 0.7137254902, alpha: 1)
    @IBInspectable var secondColor: UIColor = #colorLiteral(red: 0.007843137255, green: 0.2352941176, blue: 0.5019607843, alpha: 1)
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setButtonGradient()
    }
    
    func setButtonGradient() {
        if let g = gradient {
            g.removeFromSuperlayer()
        }
        let colours = [firstColor,secondColor]
        gradient = CAGradientLayer()
        gradient!.frame = self.bounds
        gradient!.colors = colours.map { $0.cgColor }
        gradient!.startPoint = startPoint
        gradient!.endPoint = endPoint
        self.layer.insertSublayer(gradient!, at: 0)
    }
}
