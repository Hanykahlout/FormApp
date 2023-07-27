//
//  SideBySideTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 13/07/2023.
//

import UIKit

protocol SideBySideCellDelegate{
    func selectionAction(indexPath:IndexPath,arr:[String],isDate:Bool,isFirstField:Bool)
}

typealias SideBySideDelegate = SideBySideCellDelegate & UIViewController

class SideBySideTableViewCell: UITableViewCell {

    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var title1TextField: UITextField!
    @IBOutlet weak var title2TextField: UITextField!
    
    private var firstFieldgesture:UITapGestureRecognizer?
    private var secondFieldgesture:UITapGestureRecognizer?
    private var indexPath:IndexPath?
    
    var arr = [String]()
    var isDate = false
    
    weak var delegate:SideBySideDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        binding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data:DataDetails,indexPath:IndexPath){
        self.indexPath = indexPath
        let side_by_side = data.side_by_side
        let first_field = side_by_side?.first_field
        let second_field = side_by_side?.second_field
        title1Label.text = first_field?.title ?? "----"
        title2Label.text = second_field?.title ?? "----"
        title1TextField.text = first_field?.value ?? ""
        title2TextField.text = second_field?.value ?? ""
        setUpTextField(type: first_field?.type ?? "", title1TextField,isFirstField: true)
        setUpTextField(type: second_field?.type ?? "", title2TextField,isFirstField: false)
    }
    
    
    private func setUpTextField(type:String,_ textField:UITextField,isFirstField:Bool){
        switch type{
        case "Array":
            textField.keyboardType = .default
            textField.addGestureRecognizer(isFirstField ? firstFieldgesture! : secondFieldgesture!)
        case "String":
            textField.keyboardType = .default
            textField.removeGestureRecognizer(isFirstField ? firstFieldgesture! : secondFieldgesture!)
        case "Integer":
            textField.keyboardType = .numberPad
            textField.removeGestureRecognizer(isFirstField ? firstFieldgesture! : secondFieldgesture!)
        case "Decimal":
            textField.keyboardType = .decimalPad
            textField.removeGestureRecognizer(isFirstField ? firstFieldgesture! : secondFieldgesture!)
        case "Boolean":
            arr = ["Yes","No"]
            textField.keyboardType = .decimalPad
            textField.addGestureRecognizer(isFirstField ? firstFieldgesture! : secondFieldgesture!)
        case "Date":
            textField.keyboardType = .default
            isDate = true
            textField.addGestureRecognizer(isFirstField ? firstFieldgesture! : secondFieldgesture!)
        default:break
        }
    }
    
    
}

// MARK: - binding
extension SideBySideTableViewCell{
    private func binding(){
        firstFieldgesture = UITapGestureRecognizer(target: self, action: #selector(field1AddSelectionAction))
        secondFieldgesture = UITapGestureRecognizer(target: self, action: #selector(field2AddSelectionAction))
    }
    
    @objc private func field1AddSelectionAction(){
        if let indexPath = indexPath{
            delegate?.selectionAction(indexPath: indexPath,arr:arr,isDate:isDate,isFirstField: true)
        }
    }
    
    @objc private func field2AddSelectionAction(){
        if let indexPath = indexPath{
            delegate?.selectionAction(indexPath: indexPath,arr:arr,isDate:isDate,isFirstField: false)
        }
    }
    
}

