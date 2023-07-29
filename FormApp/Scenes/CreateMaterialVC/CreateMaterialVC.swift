//
//  CreateMaterialVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 05/05/2023.
//

import UIKit

class CreateMaterialVC: UIViewController {
    
    @IBOutlet weak var communitySwitch: UISwitch!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var itemNoTextFeld: UIPaddedTextField!
    @IBOutlet weak var nameTextField: UIPaddedTextField!
    @IBOutlet weak var builderTextField: UIPaddedTextField!
    @IBOutlet weak var communityTextField: UIPaddedTextField!
    @IBOutlet weak var modelTypeTextField: UIPaddedTextField!
    @IBOutlet weak var phaseTextfield: UIPaddedTextField!
    @IBOutlet weak var specialTextField: UIPaddedTextField!
    @IBOutlet weak var quantityTextField: UIPaddedTextField!
    @IBOutlet weak var supplierTextField: UIPaddedTextField!
    
    let presenter = CreateMaterialPresenter()
    private var builderPickerVC: PickerVC?
    private var communityPickerVC: PickerVC?
    private var phasePickerVC: PickerVC?
    private var specialPickerVC: PickerVC?
    private var supplierPickerVC: PickerVC?
    var phase = ""
    var builder = ""
    var community = ""
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defer{
            communitySwitch.setOn(communityTextField.text!.lowercased() == "all", animated: true)
            if !builderTextField.text!.isEmpty{
                presenter.selectedBuilderIndex = presenter.getBuilders().firstIndex(of: builderTextField.text!) ?? 0
                presenter.getSpecialFromAPI()
            }
        }
        binding()
        communitySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        presenter.delegate = self
        navigationItem.title = presenter.getMaterial() == nil ? "Create Material" : "Update Material"
        
        phaseTextfield.text = phase
        builderTextField.text = builder
        communityTextField.text = community
        
        if let data = presenter.getMaterial(){
            itemNoTextFeld.text = data.item_no ?? ""
            nameTextField.text = data.name ?? ""
            builderTextField.text = data.builder ?? ""
            communityTextField.text = data.community ?? ""
            modelTypeTextField.text = data.model_type ?? ""
            phaseTextfield.text = data.phase ?? ""
            specialTextField.text = data.special ?? ""
            quantityTextField.text = data.quantity ?? ""
            supplierTextField.text = data.supplier?.name ?? ""
            presenter.selectedSupplier = data.supplier
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private Functions
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)

        navigationItem.title = "Create Material"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
    }
    
}

// MARK: - Binding
extension CreateMaterialVC{
    private func binding(){
        submitButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        builderTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(builderSelectionAction)))
        communityTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(communitySelectionAction)))
        phaseTextfield.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phaseSelectionAction)))
        specialTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(specialSelectionAction)))
        supplierTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(supplierSelectionAction)))
        communitySwitch.addTarget(self, action: #selector(bindingAction), for: .valueChanged)
    }
    
    @objc private func bindingAction(_ sender:UIView){
        switch sender{
        case submitButton:
            submitAction()
        
        case builderTextField:
            builderSelectionAction()
        case communityTextField:
            communitySelectionAction()
        case phaseTextfield:
            phaseSelectionAction()
        case communitySwitch:
            communityTextField.text = communitySwitch.isOn ? "All" : ""
        default:break
        }
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    private func submitAction(){
        if validation(){
            presenter.createMaterial(data:presenter.getMaterial(),itemNo: itemNoTextFeld.text!, name: nameTextField.text!,
                                     builder: builderTextField.text!, community: communityTextField.text!,
                                     modelType: modelTypeTextField.text!, phase: phaseTextfield.text!,
                                     special: specialTextField.text!, quantity: quantityTextField.text!,supplier_id: String(presenter.selectedSupplier?.id ?? -1))
        }else{
            Alert.showErrorAlert(message:  "Invalid inputs, Please enter all field" )
        }
    }
    
    private func validation()->Bool{
        return !nameTextField.text!.isEmpty &&
        !builderTextField.text!.isEmpty &&
        !communityTextField.text!.isEmpty &&
        !modelTypeTextField.text!.isEmpty &&
        !phaseTextfield.text!.isEmpty &&
        !specialTextField.text!.isEmpty &&
        !quantityTextField.text!.isEmpty &&
        !supplierTextField.text!.isEmpty
    }
    
    @objc private func builderSelectionAction(){
        
        builderPickerVC = PickerVC.instantiate()
        builderPickerVC!.arr_data = presenter.builderSearchText == "" ? presenter.getBuilders() : presenter.getSearchedBuilders()
        builderPickerVC!.searchText = presenter.builderSearchText
        builderPickerVC!.index = presenter.selectedBuilderIndex
        builderPickerVC!.searchBarHiddenStatus = false
        builderPickerVC!.searchAction = { searchText in
            self.presenter.builderSearchText = searchText
            self.presenter.selectedBuilderIndex = 0
            self.presenter.searchBuilders(search: searchText)
        }
        builderPickerVC!.isModalInPresentation = true
        builderPickerVC!.modalPresentationStyle = .overFullScreen
        builderPickerVC!.definesPresentationContext = true
        builderPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.builderTextField.text = self.presenter.builderSearchText == "" ? self.presenter.getBuilders(at:index) : self.presenter.getSearchedBuilders(at:index)
            self.presenter.selectedBuilderIndex = index
            self.presenter.getSpecialFromAPI()
            self.specialTextField.text = "" 
        }
        self.present(builderPickerVC!, animated: true, completion: nil)
    }
    
    @objc private func communitySelectionAction(){
        
        communityPickerVC = PickerVC.instantiate()
        communityPickerVC!.arr_data = presenter.communitySearchText == "" ? presenter.getCommunities() : presenter.getSearchedCommunities()
        communityPickerVC!.searchText = presenter.communitySearchText
        communityPickerVC!.index = presenter.selectedCommunityIndex
        communityPickerVC!.searchBarHiddenStatus = false
        communityPickerVC!.searchAction = { searchText in
            self.presenter.communitySearchText = searchText
            self.presenter.selectedCommunityIndex = 0
            self.presenter.searchCommunities(search: searchText)
        }
        communityPickerVC!.isModalInPresentation = true
        communityPickerVC!.modalPresentationStyle = .overFullScreen
        communityPickerVC!.definesPresentationContext = true
        communityPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.communityTextField.text = self.presenter.communitySearchText == "" ? self.presenter.getCommunities(at:index) : self.presenter.getSearchedCommunities(at:index)
            self.presenter.selectedCommunityIndex = index
            self.communitySwitch.setOn(self.communityTextField.text!.lowercased() == "all", animated: true)
        }
        self.present(communityPickerVC!, animated: true, completion: nil)
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
    
    @objc private func specialSelectionAction(){
        specialPickerVC = PickerVC.instantiate()
        specialPickerVC!.arr_data = presenter.specialSearchText == "" ? presenter.getSpecials() : presenter.getSearchedSpecials()
        specialPickerVC!.searchText = presenter.specialSearchText
        specialPickerVC!.index = presenter.selectedSpecialIndex
        specialPickerVC!.searchBarHiddenStatus = false
        specialPickerVC!.searchAction = { searchText in
            self.presenter.specialSearchText = searchText
            self.presenter.selectedSpecialIndex = 0
            self.presenter.searchSpecials(search: searchText)
        }
        specialPickerVC!.isModalInPresentation = true
        specialPickerVC!.modalPresentationStyle = .overFullScreen
        specialPickerVC!.definesPresentationContext = true
        specialPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.specialTextField.text = self.presenter.specialSearchText == "" ? self.presenter.getSpecials(at:index) : self.presenter.getSearchedSpecials(at:index)
            self.presenter.selectedSpecialIndex = index
        }
        self.present(specialPickerVC!, animated: true, completion: nil)
    }
    
    @objc private func supplierSelectionAction(){
        supplierPickerVC = PickerVC.instantiate()
        supplierPickerVC!.arr_data = presenter.supplierSearchText == "" ? presenter.getSuppliers().map{$0.name ?? ""} : presenter.getSearchedSuppliers().map{$0.name ?? ""}
        supplierPickerVC!.searchText = presenter.supplierSearchText
        supplierPickerVC!.index = presenter.selectedSupplierIndex
        supplierPickerVC!.searchBarHiddenStatus = false
        supplierPickerVC!.searchAction = { searchText in
            self.presenter.supplierSearchText = searchText
            self.presenter.selectedSupplierIndex = 0
            self.presenter.searchSuppliers(search: searchText)
        }
        supplierPickerVC!.isModalInPresentation = true
        supplierPickerVC!.modalPresentationStyle = .overFullScreen
        supplierPickerVC!.definesPresentationContext = true
        supplierPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.supplierTextField.text = self.presenter.supplierSearchText == "" ? self.presenter.getSuppliers(at:index).name ?? "" : self.presenter.getSearchedSuppliers(at:index).name ?? ""
            self.presenter.selectedSupplierIndex = index
            self.presenter.selectedSupplier = self.presenter.supplierSearchText == "" ? self.presenter.getSuppliers(at:index) : self.presenter.getSearchedSuppliers(at:index)
        }
        self.present(supplierPickerVC!, animated: true, completion: nil)
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
    
    func updateSpecialsUI() {
        if let specialPickerVC = specialPickerVC{
            specialPickerVC.arr_data = presenter.specialSearchText == "" ? presenter.getSpecials() : presenter.getSearchedSpecials()
            specialPickerVC.picker.reloadAllComponents()
            if !specialPickerVC.arr_data.isEmpty{
                specialPickerVC.index = presenter.selectedSpecialIndex
            }
        }
    }
    
    func updateBuildersUI() {
        if let builderPickerVC = builderPickerVC{
            builderPickerVC.arr_data = presenter.builderSearchText == "" ? presenter.getBuilders() : presenter.getSearchedBuilders()
            builderPickerVC.picker.reloadAllComponents()
            if !builderPickerVC.arr_data.isEmpty{
                builderPickerVC.index = presenter.selectedBuilderIndex
            }
        }
    }
    
    func updateCommunitiesUI() {
        if let communityPickerVC = communityPickerVC{
            communityPickerVC.arr_data = presenter.communitySearchText == "" ? presenter.getCommunities() : presenter.getSearchedCommunities()
            communityPickerVC.picker.reloadAllComponents()
            if !communityPickerVC.arr_data.isEmpty{
                communityPickerVC.index = presenter.selectedCommunityIndex
            }
        }
    }
    
    func updateSuppliersUI() {
        if let supplierPickerVC = supplierPickerVC{
            supplierPickerVC.arr_data = presenter.supplierSearchText == "" ? presenter.getSuppliers().map{$0.name ?? ""} : presenter.getSearchedSuppliers().map{$0.name ?? ""}
            supplierPickerVC.picker.reloadAllComponents()
            if !supplierPickerVC.arr_data.isEmpty{
                supplierPickerVC.index = presenter.selectedSupplierIndex
            }
        }
    }
}

extension CreateMaterialVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
