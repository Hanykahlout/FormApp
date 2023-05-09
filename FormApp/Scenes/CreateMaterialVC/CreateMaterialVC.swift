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

    
     let presenter = CreateMaterialPresenter()
    private var builderPickerVC: PickerVC?
    private var communityPickerVC: PickerVC?
    private var phasePickerVC: PickerVC?
    
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
//        builderTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(builderSelectionAction)))
//        communityTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(communitySelectionAction)))
        phaseTextfield.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phaseSelectionAction)))
    }

    
    @objc private func bindingAction(_ sender:UIView){
        switch sender{
        case submitButton:
            submitAction()
        case backButton:
            navigationController?.popViewController(animated: true)
        case builderTextField:
            builderSelectionAction()
        case communityTextField:
            communitySelectionAction()
        case phaseTextfield:
            phaseSelectionAction()
            
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
    
    @objc private func builderSelectionAction(){
//        builderPickerVC
        
        
    }
    
    @objc private func communitySelectionAction(){
//        communityPickerVC
        
    }
    
    @objc private func phaseSelectionAction(){
//        phasePickerVC
        phasePickerVC = PickerVC.instantiate()
        phasePickerVC!.arr_data = presenter.phasesSearchText == "" ? presenter.getPhases() : presenter.getSearchedPhases()
        phasePickerVC!.searchText = presenter.phasesSearchText
        phasePickerVC!.index = presenter.selectedPhasesIndex
        phasePickerVC!.searchBarHiddenStatus = false
        phasePickerVC!.searchAction = { searchText in
            self.presenter.phasesSearchText = searchText
            self.presenter.selectedPhasesIndex = 0
            self.presenter.searchPhases(search: searchText)
        }
        phasePickerVC!.isModalInPresentation = true
        phasePickerVC!.modalPresentationStyle = .overFullScreen
        phasePickerVC!.definesPresentationContext = true
        phasePickerVC!.delegate = {name , index in
            // Selection Action Here
            self.phaseTextfield.text = self.presenter.phasesSearchText == "" ? self.presenter.getPhase(at:index) : self.presenter.getSearchedPhases(at:index)
            self.presenter.selectedPhasesIndex = index
        }
        self.present(phasePickerVC!, animated: true, completion: nil)
        
    }
    
}

extension CreateMaterialVC:CreateMaterialPresenterDelegate{
    func successSubmtion() {
        navigationController?.popViewController(animated: true)
    }
    
    func updatePhasesUI() {
        if let phasePickerVC = phasePickerVC{
            phasePickerVC.arr_data = presenter.phasesSearchText == "" ? presenter.getPhases() : presenter.getSearchedPhases()
            phasePickerVC.picker.reloadAllComponents()
            if !phasePickerVC.arr_data.isEmpty{
                phasePickerVC.index = presenter.selectedPhasesIndex
            }
        }
    }
}

extension CreateMaterialVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
