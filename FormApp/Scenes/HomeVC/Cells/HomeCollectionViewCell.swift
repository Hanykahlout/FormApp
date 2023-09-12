//
//  HomeCollectionViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/6/23.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data:HomeAction){
        titleLabel.text = data.rawValue
        switch data {
        case .Forms:
            
            mainView.backgroundColor = UIColor(hex: "#0E508C")
            iconView.backgroundColor = UIColor(hex: "#0E508C")
            iconImageView.image = UIImage(named: "form")!
            
        case .PORequest:
            
            mainView.backgroundColor = UIColor(hex: "#B0E00E")
            iconView.backgroundColor = UIColor(hex: "#B0E00E")
            iconImageView.image = UIImage(named: "form")!
            
        case .Materials:
            
            mainView.backgroundColor = UIColor(hex: "#F1A05A")
            iconView.backgroundColor = UIColor(hex: "#F1A05A")
            iconImageView.image = UIImage(named: "material")!
            
        case .jobEntry:
            mainView.backgroundColor = UIColor(hex: "#6AB1DF")
            iconView.backgroundColor = UIColor(hex: "#6AB1DF")
            iconImageView.image = UIImage(named: "job")!
        case .warrantyForm:
            mainView.backgroundColor = UIColor(hex: "#B0E00E")
            iconView.backgroundColor = UIColor(hex: "#B0E00E")
            iconImageView.image = UIImage(named: "form")!
        }
        
    }
    
}
