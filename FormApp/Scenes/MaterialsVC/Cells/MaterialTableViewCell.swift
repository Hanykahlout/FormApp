//
//  MaterialTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 09/05/2023.
//

import UIKit
protocol MaterialCellDelegate{
    func editMaterialAction(material:Material)
}

typealias MaterialTableViewCellDelegate = MaterialCellDelegate & UIViewController

class MaterialTableViewCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    weak var delegate:MaterialTableViewCellDelegate?
    private var material:Material?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        binding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data:Material){
        material = data
        titleLabel.text = data.name ?? "----"
        amountLabel.text = data.quantity ?? "----"
    }
    
    
}
// MARK: - Binding
extension MaterialTableViewCell{
    private func binding(){
        editButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case editButton:
            if let material = material{
                delegate?.editMaterialAction(material: material)
            }
        default:break
        }
    }
    
}
