//
//  UserFormItemTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 20/05/2023.
//

import UIKit
protocol UserFormItemDelegate{
    func selectionAction(type:NewFormItemType,Index:Int)
}

typealias UserItemDelegate = UserFormItemDelegate & UIViewController

class UserFormItemTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var valueTitleLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceStackView: UIStackView!
    
    weak var delegate:UserItemDelegate?
    var index:Int?
    var type:NewFormItemType?
    private var gesture:UITapGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gesture = UITapGestureRecognizer(target: self, action: #selector(addSelectionAction))
        
    }
    
    func setData(data:DataDetails,index:Int){
        self.index = index
        self.type = data.new_item_type
        nameTextField.text = data.name ?? ""
        valueTextField.text = data.status ?? ""
        priceTextField.text = data.price ?? ""
        priceStackView.isHidden = !(data.isWithPrice ?? false)
        switch data.new_item_type ?? .text{
        case .quantity:
            valueTextField.keyboardType = .decimalPad
            valueTitleLabel.text = "Quantity"
            valueTextField.removeGestureRecognizer(gesture!)
        case .price:
            valueTextField.keyboardType = .decimalPad
            valueTitleLabel.text = "Price"
            valueTextField.removeGestureRecognizer(gesture!)
        case .text:
            valueTextField.keyboardType = .default
            valueTitleLabel.text = "Text"
            valueTextField.removeGestureRecognizer(gesture!)
        case .yes_no:
            valueTitleLabel.text = "Select Yes or No"
            valueTextField.keyboardType = .default
            valueTextField.addGestureRecognizer(gesture!)
        case .pass_fail:
            valueTitleLabel.text = "Select Pass or Fail"
            valueTextField.keyboardType = .default
            valueTextField.addGestureRecognizer(gesture!)
        case .date:
            valueTitleLabel.text = "Select Date"
            valueTextField.keyboardType = .default
            valueTextField.addGestureRecognizer(gesture!)
        }
    }
    
    
    @objc private func addSelectionAction(){
        if let index = index,let type = type{
            delegate?.selectionAction(type: type, Index: index)
        }
    }
    
}
