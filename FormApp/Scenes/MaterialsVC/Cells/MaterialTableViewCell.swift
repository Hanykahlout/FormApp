//
//  MaterialTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 09/05/2023.
//

import UIKit

class MaterialTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data:Material){
        titleLabel.text = data.name ?? "----"
        amountLabel.text = data.quantity ?? "----"
    }
}
