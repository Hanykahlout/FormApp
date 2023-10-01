//
//  WarrantyListTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/17/23.
//

import UIKit

class WarrantyListTableViewCell: UITableViewCell {

    @IBOutlet weak var workOrderNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var reportedProblemLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func setData(data:Warranty){
        workOrderNumberLabel.text = data.workOrderNumber ?? "-----"
        addressLabel.text = data.workAddress ?? "-----"
        customerLabel.text = data.builder ?? "-----"
        reportedProblemLabel.text = data.reportedProblem ?? "-----"
    }
    
}
