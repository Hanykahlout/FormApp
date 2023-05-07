//
//  CreateMaterialVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 05/05/2023.
//

import UIKit

class CreateMaterialVC: UIViewController {
    
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var itemNoTextFeld: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var builderTextField: UITextField!
    @IBOutlet weak var communityTextField: UITextField!
    @IBOutlet weak var modelTypeTextField: UITextField!
    @IBOutlet weak var phaseTextfield: UITextField!
    @IBOutlet weak var specialTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    private let presenter = CreateMaterialPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        presenter.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

// MARK: - Binding
extension CreateMaterialVC{
    private func binding(){
        submitButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case submitButton:
            submitAction()
        case backButton:
            navigationController?.popViewController(animated: true)
        default:break
        }
    }
    
    private func submitAction(){
        if validation(){
            presenter.createMaterial(itemNo: itemNoTextFeld.text!, name: nameTextField.text!,
                                     builder: builderTextField.text!, community: communityTextField.text!,
                                     modelType: modelTypeTextField.text!, phase: phaseTextfield.text!,
                                     special: specialTextField.text!, quantity: quantityTextField.text!)
        }else{
            Alert.showErrorAlert(message:  "Invalid inputs, Please enter all field" )
        }
    }
    
    private func validation()->Bool{
        return !itemNoTextFeld.text!.isEmpty &&
        !nameTextField.text!.isEmpty &&
        !builderTextField.text!.isEmpty &&
        !communityTextField.text!.isEmpty &&
        !modelTypeTextField.text!.isEmpty &&
        !phaseTextfield.text!.isEmpty &&
        !specialTextField.text!.isEmpty &&
        !quantityTextField.text!.isEmpty
    }
    
}

extension CreateMaterialVC:CreateMaterialPresenterDelegate{
    func successSubmtion() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension CreateMaterialVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
