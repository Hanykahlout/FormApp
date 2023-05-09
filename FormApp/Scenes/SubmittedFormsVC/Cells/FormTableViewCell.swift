//
//  FormTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 19/03/2023.
//

import UIKit

class FormTableViewCell: UITableViewCell ,NibLoadableView{

    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var formTypeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:FormInfo){
        jobNameLabel.text = data.job?.title ?? "----"
        formTypeLabel.text = data.form?.title ?? "----"
    }

    
}
