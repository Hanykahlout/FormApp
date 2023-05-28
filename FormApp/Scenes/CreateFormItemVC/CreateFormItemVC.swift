//
//  CreateFormItemVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 24/05/2023.
//

import UIKit

class CreateFormItemVC: UIViewController {

    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var priceSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var typeTextField: UITextField!
    var addAction:((_ type:NewFormItemType,_ isWithPrice:Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        // Do any additional setup after loading the view.
    }

}


extension CreateFormItemVC{
    private func binding(){
        closeButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        typeTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeAction)))
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case addButton:
            switch typeTextField.text!{
            case "Quantity":
                addAction?(.quantity, priceSwitch.isOn)
            case "Text":
                addAction?(.text, false)
            case "Price":
                addAction?(.price, false)
            case "Yes/No":
                addAction?(.yes_no, false)
            case "Pass/Fail":
                addAction?(.pass_fail, false)
            case "Date":
                addAction?(.date, false)
            default:break
            }
            dismiss(animated: true)
        case closeButton:
            dismiss(animated: true)
        default:break
        }
    }
    
    @objc private func typeAction(){
        let pickerVC = PickerVC.instantiate()
        pickerVC.arr_data = ["Quantity","Text","Price","Date","Yes/No","Pass/Fail"]
        pickerVC.name = "Quantity"
        pickerVC.searchBarHiddenStatus = true
        pickerVC.isModalInPresentation = true
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.definesPresentationContext = true
        pickerVC.delegate = {name , index in
            self.typeTextField.text = name
            self.priceStackView.isHidden = name != "Quantity"
        }
        self.present(pickerVC, animated: true, completion: nil)
    }
    
}


extension CreateFormItemVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}


enum NewFormItemType:String,Decodable{
    case quantity
    case text
    case price
    case yes_no
    case pass_fail
    case date
}
