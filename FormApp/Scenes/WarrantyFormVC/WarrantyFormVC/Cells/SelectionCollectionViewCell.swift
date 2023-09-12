//
//  SelectionCollectionViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/11/23.
//

import UIKit

class SelectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data:Warranty){
        
        titleLabel.text = data.workOrderNumber
        
        if data.isSelected {
            mainView.border_width = 0
            mainView.backgroundColor = .orange
        }else{
            mainView.border_width = 1
            mainView.backgroundColor = UIColor(hex: "#FFFFFF",alpha: 0.07)
        }
        
    }
}
