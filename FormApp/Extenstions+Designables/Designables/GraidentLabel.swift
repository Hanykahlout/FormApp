//
//  GraidentLabel.swift
//  Aloo
//
//  Created by Hany Alkahlout on 25/09/2021.
//

import UIKit


class GraidentLabel: UILabel {

    var gradient: CAGradientLayer?
    @IBInspectable var firstColor: UIColor = #colorLiteral(red: 0.7725490196, green: 0.3450980392, blue: 0.3490196078, alpha: 1)
    @IBInspectable var secondColor: UIColor = #colorLiteral(red: 0.5647058824, green: 0.1098039216, blue: 0.1137254902, alpha: 1)
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 1)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)

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
