//
//  UserFormItemTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 20/05/2023.
//

import UIKit
import SDWebImage
protocol UserFormItemDelegate{
    func selectionAction(type:NewFormItemType,Index:Int)
    func updatePicStatus(index:Int,withPic:Bool)
    func addPicAction(indexPath:IndexPath)
}

typealias UserItemDelegate = UserFormItemDelegate & UIViewController

class UserFormItemTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var valueTitleLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var addPicSwitch: UISwitch!
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var addPicView: UIView!
    
    weak var delegate:UserItemDelegate?
    var indexPath:IndexPath?
    var type:NewFormItemType?
    private var gesture:UITapGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        binding()
    }
    
    func setData(data:DataDetails,indexPath:IndexPath){
        self.indexPath = indexPath
        self.type = data.new_item_type
        nameTextField.text = data.name ?? ""
        valueTextField.text = data.status ?? ""
        priceTextField.text = data.price ?? ""
        priceStackView.isHidden = !(data.isWithPrice ?? false)
        addPicSwitch.isOn = data.isWithPic ?? false
        addPicView.isHidden = !(data.isWithPic ?? false)
        if data.isWithPic ?? false{
            selectedImageView.sd_setImage(with: URL(string: data.image ?? ""))
        }
        
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
  
    
}

// MARK: - binding
extension UserFormItemTableViewCell{
    private func binding(){
        gesture = UITapGestureRecognizer(target: self, action: #selector(addSelectionAction))
        addPicSwitch.addTarget(self, action: #selector(bindingAction), for: .valueChanged)
        addPicButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIView){
        switch sender{
        case addPicSwitch:
            guard let index = indexPath?.row else { return }
            addPicView.isHidden = !addPicSwitch.isOn
            delegate?.updatePicStatus(index:index,withPic: addPicSwitch.isOn)
        case addPicButton:
            guard let indexPath = indexPath else { return }
            delegate?.addPicAction(indexPath: indexPath)
        default:break
        }
    }
    
    @objc private func addSelectionAction(){
        if let index = indexPath?.row,let type = type{
            delegate?.selectionAction(type: type, Index: index)
        }
    }
    
    
}
