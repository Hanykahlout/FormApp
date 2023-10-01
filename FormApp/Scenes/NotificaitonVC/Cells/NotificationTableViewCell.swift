//
//  NotificationTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/23/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data:NotificationData){
        titleLabel.text = data.title ?? "----"
        subTitleLabel.text = data.body ?? "----"
        dateLabel.text = data.createdAt ?? ""
    }
    
    private func getStringDate(date:String)->String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormater.date(from: date){
            dateFormater.dateFormat = "yyyy/MM/dd hh:mm:ss"
            return dateFormater.string(from: date)
        }
        return ""
    }
    
}
