//
//  CustomFormItemTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 25/05/2023.
//


import UIKit
protocol  CustomFormItemDelegate{
    func selectionAction(index:Int,arr:[String],isDate:Bool)
    func updatePicStatus(index:Int,withPic:Bool)
    func addPicAction(indexPath:IndexPath)
}

typealias  CustomItemDelegate =  CustomFormItemDelegate & UIViewController

class CustomFormItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var valueTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var addPicView: UIView!
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var addPicSwitch: UISwitch!
    
    weak var delegate:CustomItemDelegate?
    var indexPath:IndexPath?
    private var gesture:UITapGestureRecognizer?
    private var arr:[String] = []
    private var isDate = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        binding()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data:DataDetails,indexPath:IndexPath){
        self.indexPath = indexPath
        priceLabel.text = "Price: \(data.price ?? "")"
        priceLabel.isHidden = data.show_price != "1"
        titleLabel.text = data.title ?? "----"
        valueTextField.text = data.status ?? ""
        arrowImageView.isHidden = data.system_type != "Array"
        arr = data.system_list ?? []
        addPicSwitch.isOn = data.isWithPic ?? false
        addPicView.isHidden = !(data.isWithPic ?? false)
        if data.isWithPic ?? false{
            selectedImageView.sd_setImage(with: URL(string: data.image ?? ""))
        }
        switch data.system_type{
        case "Array":
            valueTitleLabel.text = "Please select your choose"
            valueTextField.keyboardType = .default
            valueTextField.addGestureRecognizer(gesture!)
        case "String":
            valueTitleLabel.text = "Enter your text"
            valueTextField.keyboardType = .default
            valueTextField.removeGestureRecognizer(gesture!)
        case "Integer":
            valueTitleLabel.text = "Enter your Number"
            valueTextField.keyboardType = .numberPad
            valueTextField.removeGestureRecognizer(gesture!)
        case "Decimal":
            valueTitleLabel.text = "Enter your decimal number"
            valueTextField.keyboardType = .decimalPad
            valueTextField.removeGestureRecognizer(gesture!)
        case "Boolean":
            valueTitleLabel.text = "Please select Yes/No"
            arr = ["Yes","No"]
            valueTextField.keyboardType = .decimalPad
            valueTextField.addGestureRecognizer(gesture!)
        case "Date":
            valueTitleLabel.text = "Please select a Date"
            valueTextField.keyboardType = .default
            isDate = true
            valueTextField.addGestureRecognizer(gesture!)
        default:break
        }
    }
    
   
    
}

// MARK: - binding
extension CustomFormItemTableViewCell{
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
        if let index = indexPath?.row{
            delegate?.selectionAction(index: index,arr:arr,isDate:isDate)
        }
    }
    
    
}
