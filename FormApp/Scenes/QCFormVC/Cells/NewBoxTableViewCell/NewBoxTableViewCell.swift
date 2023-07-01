//
//  NewBoxTableViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 01/06/2023.
//

import UIKit

protocol NewBoxCellDelegate{
    func showPickerVC(type:String,index:Int)
}

typealias NewBoxDelegate = UITableViewCell & NewBoxCellDelegate

class NewBoxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var boxTextField: UITextField!
    @IBOutlet weak var boxArrowImageView: UIImageView!
    weak var delegate:NewBoxDelegate?
    private var type = ""
    private var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data:NewBoxData,index:Int){
        self.index = index
        boxTextField.text = data.value ?? ""
        titleLabel.text = data.title ?? "Text"
        switch data.box_type{
        case "String":
            boxTextField.keyboardType = .default
            boxArrowImageView.isHidden = true
        case "Integer":
            boxTextField.keyboardType = .numberPad
            boxArrowImageView.isHidden = true
        case "Decimal":
            boxTextField.keyboardType = .decimalPad
            boxArrowImageView.isHidden = true
        case "Date","Boolean":
            type = data.box_type ?? ""
            boxTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(boxAction)))
            boxTextField.keyboardType = .default
            boxArrowImageView.isHidden = false
        default:break
        }
    }
    
    @objc private func boxAction(){
        delegate?.showPickerVC(type: type,index: index)
    }
    
}



