//
//  CustomFormItemTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 25/05/2023.
//


import UIKit
protocol  CustomFormItemDelegate{
    func selectionAction(index:Int,arr:[String],isDate:Bool)
}

typealias  CustomItemDelegate =  CustomFormItemDelegate & UIViewController

class CustomFormItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    weak var delegate:CustomItemDelegate?
    var index:Int?
    private var gesture:UITapGestureRecognizer?
    private var arr:[String] = []
    private var isDate = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gesture = UITapGestureRecognizer(target: self, action: #selector(addSelectionAction))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data:DataDetails,index:Int){
        self.index = index
        priceLabel.text = "Price: \(data.price ?? "")"
        priceLabel.isHidden = data.show_price != "1"
        titleLabel.text = data.title ?? "----"
        valueTextField.text = data.status ?? ""
        arrowImageView.isHidden = data.system_type != "Array"
        arr = data.system_list ?? []
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
    
    @objc private func addSelectionAction(){
        if let index = index{
            delegate?.selectionAction(index: index,arr:arr,isDate:isDate)
        }
    }
    
}

