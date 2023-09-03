//
//  JobEntryVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 24/08/2023.
//

import UIKit

class JobEntryVC: UIViewController {
    
    @IBOutlet weak var jobDetailsArrow: UIImageView!
    @IBOutlet weak var jobDetailsStackView: UIStackView!
    
    @IBOutlet weak var addtionalDetailsArrow: UIImageView!
    @IBOutlet weak var addtionalDetailsStackView: UIStackView!
    @IBOutlet weak var addtionalDetailsMainView: UIStackView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var builderTextField: UITextField!
    @IBOutlet weak var projectTextField: UITextField!
    @IBOutlet weak var divisionTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var businessManagerTextField: UITextField!
    @IBOutlet weak var projectManagerTextField: UITextField!
    @IBOutlet weak var provStateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetNameAndNumberTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var contractAmountTextField: UITextField!
    @IBOutlet weak var costCodeCollectionView: UICollectionView!
    
    
    @IBOutlet weak var jobDetailsButton: UIButton!
    @IBOutlet weak var addtionalDetailsButton: UIButton!
    @IBOutlet weak var builderButton: UIButton!
    @IBOutlet weak var projectButton: UIButton!
    @IBOutlet weak var modelButton: UIButton!
    @IBOutlet weak var divisionButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var businessManagerButton: UIButton!
    @IBOutlet weak var projectManagerButton: UIButton!
    @IBOutlet weak var provStateButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var zipCodeButton: UIButton!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var costCodeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var zipStackView: UIStackView!
        
    @IBOutlet weak var permitMaterialBudgetTextField: UITextField!
    @IBOutlet weak var SewerWaterHoursTextField: UITextField!
    @IBOutlet weak var sewerWaterBudgetTextField: UITextField!
    @IBOutlet weak var underslabHoursTextField: UITextField!
    @IBOutlet weak var underslabBudgetTextField: UITextField!
    @IBOutlet weak var roughHoursTextField: UITextField!
    @IBOutlet weak var roughBudgetTextField: UITextField!
    @IBOutlet weak var trimHoursTextField: UITextField!
    
    @IBOutlet weak var trimBudgetTextField: UITextField!
    @IBOutlet weak var costCodeErrorImageView: UIImageView!
    
    // MARK: - Private Att
    private var selectedStartDate = Date()
    private var selectedEndDate = Date()
    
    private var builderPickerVC:PickerVC?
    private var projectPickerVC:PickerVC?
    private var modelPickerVC:PickerVC?
    private var divisionPickerVC:PickerVC?
    private var companyPickerVC:PickerVC?
    private var businessManagerPickerVC:PickerVC?
    private var projectManagerPickerVC:PickerVC?
    private var provStatePickerVC:PickerVC?
    private var cityPickerVC:PickerVC?
    private var zipCodePickerVC:PickerVC?
    private var costCodePickerVC:PickerVC?
    
    private let presenter = JobEntryPresenter()
    private var selectedCostCodes = [String]()
    private var level = -1
    private var username:String?
    private var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        setUpTextFieldsDelegate()
        setUpCollectionView()
        binding()
        setUpNavigation()
        setUpDates()
        setUpPickerVCs()
        presenter.getApiList(searchType: .none)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.removeBackgroungNavBar()
        navigationItem.title = "Job Entry"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.backgroundColor = .white
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
    }
    
    private func setUpTextFieldsDelegate(){
        
        jobTextField.delegate = self
        descriptionTextField.delegate = self
        streetNameAndNumberTextField.delegate = self
        contractAmountTextField.delegate = self
        permitMaterialBudgetTextField.delegate = self
        SewerWaterHoursTextField.delegate = self
        sewerWaterBudgetTextField.delegate = self
        underslabHoursTextField.delegate = self
        underslabBudgetTextField.delegate = self
        roughHoursTextField.delegate = self
        roughBudgetTextField.delegate = self
        trimHoursTextField.delegate = self
        trimBudgetTextField.delegate = self
        
    }
    
    
    private func setUpPickerVCs(){
        
        setUpBuilderPicker()
        setUpProjectPicker()
        setUpModelPicker()
        setUpDivisionPicker()
        setUpCompanyPicker()
        setUpBusinessManagerPicker()
        setUpProjectManagerPicker()
        setUpProvStatePicker()
        setUpCityPicker()
        setUpZipCodePicker()
        setUpCostCodePicker()
        
    }
    
    
    private func setUpBuilderPicker(){
        builderPickerVC = PickerVC.instantiate()
        
        builderPickerVC!.searchBarHiddenStatus = false
        builderPickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_builder)
        }
        
        builderPickerVC!.delegate = {name , index in
            self.builderTextField.text = name
            self.presenter.selectedBuilder = self.presenter.data?.builders?[index].first ?? ""
            self.presenter.getBuilders()
        }
        
        builderPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    private func setUpProjectPicker(){
        projectPickerVC = PickerVC.instantiate()
        
        projectPickerVC!.searchBarHiddenStatus = false
        projectPickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_project)
        }
        
        projectPickerVC!.delegate = {name , index in
            self.projectTextField.text = name
        }
        
        projectPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    private func setUpModelPicker(){
        modelPickerVC = PickerVC.instantiate()
        
        modelPickerVC!.searchBarHiddenStatus = false
        modelPickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_model)
        }
        
        modelPickerVC!.delegate = {name , index in
            self.modelTextField.text = name
            self.presenter.selectedModel = name
            self.presenter.getBuilders()
            
        }
        
        modelPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpDivisionPicker(){
        divisionPickerVC = PickerVC.instantiate()
        
        divisionPickerVC!.searchBarHiddenStatus = false
        divisionPickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_division)
        }
        
        divisionPickerVC!.delegate = {name , index in
            self.divisionTextField.text = name
        }
        
        divisionPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    private func setUpCompanyPicker(){
        companyPickerVC = PickerVC.instantiate()
        
        companyPickerVC!.searchBarHiddenStatus = false
        companyPickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_company)
        }
        
        companyPickerVC!.delegate = {name , index in
            self.companyTextField.text = name
        }
        
        companyPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpBusinessManagerPicker(){
        businessManagerPickerVC = PickerVC.instantiate()
        
        businessManagerPickerVC!.searchBarHiddenStatus = false
        businessManagerPickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_business_manager)
        }
        
        businessManagerPickerVC!.delegate = {name , index in
            self.businessManagerTextField.text = name
            self.presenter.selectedBusinessManager = self.presenter.data?.businessManagers?[index].first ?? ""
        }
        
        businessManagerPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpProjectManagerPicker(){
        projectManagerPickerVC = PickerVC.instantiate()
        
        projectManagerPickerVC!.searchBarHiddenStatus = false
        projectManagerPickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_project_manager)
        }
        
        projectManagerPickerVC!.delegate = {name , index in
            self.projectManagerTextField.text = name
            self.presenter.selectedProjectManager = self.presenter.data?.projectManagers?[index].first ?? ""
        }
        
        projectManagerPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    private func setUpProvStatePicker(){
        provStatePickerVC = PickerVC.instantiate()
        
        provStatePickerVC!.searchBarHiddenStatus = false
        provStatePickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_state)
        }
        
        provStatePickerVC!.delegate = {name , index in
            self.provStateTextField.text = name
            self.cityStackView.isHidden = false
            self.presenter.getCities(search:"",state: self.presenter.data?.states?[index].state ?? "")
            self.presenter.selectedState = self.presenter.data?.states?[index].state ?? ""
        }
        
        provStatePickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    private func setUpCityPicker(){
        cityPickerVC = PickerVC.instantiate()
        
        cityPickerVC!.searchBarHiddenStatus = false
        cityPickerVC!.searchAction = { searchText in
            self.presenter.getCities(search:searchText,state: self.presenter.selectedState)
        }
        
        cityPickerVC!.delegate = {name , index in
            self.zipStackView.isHidden = false
            self.cityTextField.text = name
            self.presenter.getZip(search:"",city: name)
        }
        
        cityPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    private func setUpZipCodePicker(){
        zipCodePickerVC = PickerVC.instantiate()
        
        zipCodePickerVC!.searchBarHiddenStatus = false
        zipCodePickerVC!.searchAction = { searchText in
            self.presenter.getZip(search:"",city: self.cityTextField.text!)
        }
        
        zipCodePickerVC!.delegate = {name , index in
            self.zipCodeTextField.text = name
        }
        
        zipCodePickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpCostCodePicker(){
        costCodePickerVC = PickerVC.instantiate()
        costCodePickerVC!.searchBarHiddenStatus = false
        costCodePickerVC!.searchAction = { searchText in
            self.presenter.getApiList(search: searchText,searchType: .search_cost_code)
        }
        
        costCodePickerVC!.delegate = {name , index in
            self.selectedCostCodes.append(name)
            let lastIndexPath = IndexPath(row: self.selectedCostCodes.count - 1, section: 0)
            self.costCodeCollectionView.insertItems(at: [lastIndexPath])
            self.costCodeCollectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
        }
        
        costCodePickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func dateFormte(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = .init(identifier: "en")
        return dateFormatter.string(from: date)
    }
    
    
    private func setUpDates(){
        
        startDateTextField.text = dateFormte(date: selectedStartDate)
        
        let calendar = Calendar.current
        
        if let oneYearFromNow = calendar.date(byAdding: .year, value: 1, to: selectedStartDate) {
            selectedEndDate = oneYearFromNow
            endDateTextField.text = dateFormte(date: oneYearFromNow)
        } else {
            endDateTextField.text = dateFormte(date: selectedStartDate)
        }
        
    }
    
    
    private func openDate(isStart:Bool){
        let datePickerVC = DatePickerVC.instantiate()
        datePickerVC.dateFormat = "yyyy-MM-dd"
        datePickerVC.selectedDate = isStart ? selectedStartDate : selectedEndDate
        datePickerVC.dateSelected = { stringDate , date in
            if isStart{
                self.selectedStartDate = date
                self.startDateTextField.text = stringDate
            }else{
                self.selectedEndDate = date
                self.endDateTextField.text = stringDate
            }
        }
        datePickerVC.modalTransitionStyle = .crossDissolve
        datePickerVC.modalPresentationStyle = .overCurrentContext
        present(datePickerVC, animated: true)
    }
    
    private func submitAction(){
        if validtion(){
            if level != -1{
                var title = ""
                switch level{
                case 1:
                    title = "Do you want to send the Address Codes API ?"
                case 2:
                    title = "Do you want to send the Job Master API ?"
                case 3:
                    title = "Do you want to send the Cost Codes API ?"
                default:
                    title = "Do you want to send the Contract Items API ?"
                }
                
                let alertC = UIAlertController(title: title, message: "", preferredStyle: .alert)
                alertC.addAction(.init(title: "Yes", style: .default, handler: { action in
                    self.presenter.storeJob(data: self.getUIData())
                }))
                
                alertC.addAction(.init(title: "No, move to the next api", style: .default, handler: { action in
                    if self.level != 4{
                        self.level += 1
                        self.submitAction()
                    }else{
                        self.level = 1
                        alertC.dismiss(animated: true)
                    }
                }))
                
                alertC.addAction(.init(title: "Cancel", style: .cancel))
                
                present(alertC, animated: true)
            }else{
                    self.presenter.storeJob(data: self.getUIData())
            }
        }else{
            Alert.showErrorAlert(message: "Please fill in all fields before submitting.")
        }
        
    }
    
    
    private func getUIData() -> [String:Any]{
        var data:[String:Any] = [
            "job": jobTextField.text!,
            "description": descriptionTextField.text!,
            "project": projectTextField.text!,
            "builder": presenter.selectedBuilder,
            "model": modelTextField.text!,
            "division": divisionTextField.text!,
            "company": companyTextField.text!,
            "business_manager": presenter.selectedBusinessManager,
            "project_manager": presenter.selectedProjectManager,
            "prov_state": presenter.selectedState,
            "city": cityTextField.text!,
            "street_name": streetNameAndNumberTextField.text!,
            "zip": zipCodeTextField.text!,
            "start_date": startDateTextField.text!,
            "end_date": endDateTextField.text!,
            "contract_amount": contractAmountTextField.text!,
            "level": level,
            "permit_material": permitMaterialBudgetTextField.text!,
            "sewer_labor": SewerWaterHoursTextField.text!,
            "sewer_material": sewerWaterBudgetTextField.text!,
            "underslab_labor": underslabHoursTextField.text!,
            "underslab_material": underslabBudgetTextField.text!,
            "rough_labor": roughHoursTextField.text!,
            "rough_material": roughBudgetTextField.text!,
            "trim_labor": trimHoursTextField.text!,
            "trim_material": trimBudgetTextField.text!
        ]
        
        
        
        
        if let username = username,let password = password{
            data["api_username"] = username
            data["api_password"] = password
        }
        
        for i in 0..<selectedCostCodes.count{
            data["cost_code[\(i)]"] = selectedCostCodes[i]
        }
        return data
    }
    
    private func validtion() -> Bool{
        removeAllTextFieldsErrors()
        let job = jobTextField.text!
        let description = descriptionTextField.text!
        let builder = builderTextField.text!
        let project = projectTextField.text!
        let model = modelTextField.text!
        let division = divisionTextField.text!
        let company = companyTextField.text!
        let businessManager = businessManagerTextField.text!
        let projectManager = projectManagerTextField.text!
        let provState = provStateTextField.text!
        let city = cityTextField.text!
        let zip = zipCodeTextField.text!
        let street = streetNameAndNumberTextField.text!
        let startDate = startDateTextField.text!
        let endDate = endDateTextField.text!
        let costCodeCount = selectedCostCodes.count
        let contractAmount = contractAmountTextField.text!
        
        
        
        var isError = false
        
        if job.isEmpty {
            showError(on: jobTextField)
            isError = true
        }
        if description.isEmpty {
            showError(on: descriptionTextField)
            isError = true
        }
        if builder.isEmpty {
            showError(on: builderTextField)
            isError = true
        }
        if project.isEmpty {
            showError(on: projectTextField)
            isError = true
        }
        if model.isEmpty {
            showError(on: modelTextField)
            isError = true
        }
        if division.isEmpty {
            showError(on: divisionTextField)
            isError = true
        }
        if company.isEmpty {
            showError(on: companyTextField)
            isError = true
        }
        if businessManager.isEmpty {
            showError(on: businessManagerTextField)
            isError = true
        }
        if projectManager.isEmpty {
            showError(on: projectManagerTextField)
            isError = true
        }
        if provState.isEmpty {
            showError(on: provStateTextField)
            isError = true
        }
        if city.isEmpty {
            showError(on: cityTextField)
            isError = true
        }
        if zip.isEmpty {
            showError(on: zipCodeTextField)
            isError = true
        }
        if street.isEmpty {
            showError(on: streetNameAndNumberTextField)
            isError = true
        }
        if startDate.isEmpty {
            showError(on: startDateTextField)
            isError = true
        }
        if endDate.isEmpty {
            showError(on: endDateTextField)
            isError = true
        }
        if costCodeCount == 0 {
            costCodeErrorImageView.isHidden = false
            isError = true
        }
        if contractAmount.isEmpty {
            showError(on: contractAmountTextField)
            isError = true
        }
        
        
            let permitBudget = permitMaterialBudgetTextField.text!
            let sewerHours = SewerWaterHoursTextField.text!
            let sewerBudget = sewerWaterBudgetTextField.text!
            let underslabHours = underslabHoursTextField.text!
            let underslabBudget = underslabBudgetTextField.text!
            let roughHours = roughHoursTextField.text!
            let roughBudget = roughBudgetTextField.text!
            let trimHours = trimHoursTextField.text!
            let trimBudget = trimBudgetTextField.text!
            
            if permitBudget.isEmpty {
                showError(on: permitMaterialBudgetTextField)
                isError = true
            }
            if sewerHours.isEmpty {
                showError(on: SewerWaterHoursTextField)
                isError = true
            }
            if sewerBudget.isEmpty {
                showError(on: sewerWaterBudgetTextField)
                isError = true
            }
            if underslabHours.isEmpty {
                showError(on: underslabHoursTextField)
                isError = true
            }
            if underslabBudget.isEmpty {
                showError(on: underslabBudgetTextField)
                isError = true
            }
            if roughHours.isEmpty {
                showError(on: roughHoursTextField)
                isError = true
            }
            if roughBudget.isEmpty {
                showError(on: roughBudgetTextField)
                isError = true
            }
            if trimHours.isEmpty {
                showError(on: trimHoursTextField)
                isError = true
            }
            if trimBudget.isEmpty {
                showError(on: trimBudgetTextField)
                isError = true
            }
        
        return !isError
        
    }
    
    
    
    private func removeAllTextFieldsErrors(){
        
        costCodeErrorImageView.isHidden = true
        jobTextField.rightViewMode = .never
        descriptionTextField.rightViewMode = .never
        builderTextField.rightViewMode = .never
        projectTextField.rightViewMode = .never
        modelTextField.rightViewMode = .never
        divisionTextField.rightViewMode = .never
        companyTextField.rightViewMode = .never
        businessManagerTextField.rightViewMode = .never
        projectManagerTextField.rightViewMode = .never
        provStateTextField.rightViewMode = .never
        cityTextField.rightViewMode = .never
        zipCodeTextField.rightViewMode = .never
        streetNameAndNumberTextField.rightViewMode = .never
        startDateTextField.rightViewMode = .never
        endDateTextField.rightViewMode = .never
        contractAmountTextField.rightViewMode = .never
        permitMaterialBudgetTextField.rightViewMode = .never
        SewerWaterHoursTextField.rightViewMode = .never
        sewerWaterBudgetTextField.rightViewMode = .never
        underslabHoursTextField.rightViewMode = .never
        underslabBudgetTextField.rightViewMode = .never
        roughHoursTextField.rightViewMode = .never
        roughBudgetTextField.rightViewMode = .never
        trimHoursTextField.rightViewMode = .never
        trimBudgetTextField.rightViewMode = .never
    }
    
}

// MARK: - Binding

extension JobEntryVC{
    
    private func binding(){
        
        jobDetailsButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        addtionalDetailsButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        builderButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        projectButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        modelButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        divisionButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        companyButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        businessManagerButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        projectManagerButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        provStateButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        cityButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        zipCodeButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        startDateButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        endDateButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        costCodeButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        
        switch sender{
        case jobDetailsButton:
            
            jobDetailsStackView.isHidden = !jobDetailsStackView.isHidden
            jobDetailsArrow.transform = .init(rotationAngle: jobDetailsStackView.isHidden ? 0 : .pi)
            
        case addtionalDetailsButton:
            
            addtionalDetailsStackView.isHidden = !addtionalDetailsStackView.isHidden
            addtionalDetailsArrow.transform = .init(rotationAngle: addtionalDetailsStackView.isHidden ? 0 : .pi)
            
        case builderButton:
            
            self.present(builderPickerVC!, animated: true, completion: nil)
            builderTextField.rightViewMode = .never
        case projectButton:
            
            self.present(projectPickerVC!, animated: true, completion: nil)
            projectTextField.rightViewMode = .never
        case modelButton:
            
            self.present(modelPickerVC!, animated: true, completion: nil)
            modelTextField.rightViewMode = .never
        case divisionButton:
            
            self.present(divisionPickerVC!, animated: true, completion: nil)
            divisionTextField.rightViewMode = .never
        case companyButton:
            
            self.present(companyPickerVC!, animated: true, completion: nil)
            companyTextField.rightViewMode = .never
        case businessManagerButton:
            
            self.present(businessManagerPickerVC!, animated: true, completion: nil)
            businessManagerTextField.rightViewMode = .never
        case projectManagerButton:
            
            self.present(projectManagerPickerVC!, animated: true, completion: nil)
            projectManagerTextField.rightViewMode = .never
        case provStateButton:
            
            self.present(provStatePickerVC!, animated: true, completion: nil)
            provStateTextField.rightViewMode = .never
        case cityButton:
            
            self.present(cityPickerVC!, animated: true, completion: nil)
            cityTextField.rightViewMode = .never
        case zipCodeButton:
            
            self.present(zipCodePickerVC!, animated: true, completion: nil)
            zipCodeTextField.rightViewMode = .never
        case startDateButton:
            
            openDate(isStart: true)
            startDateTextField.rightViewMode = .never
        case endDateButton:
            
            openDate(isStart: false)
            endDateTextField.rightViewMode = .never
        case costCodeButton:
            
            self.present(costCodePickerVC!, animated: true, completion: nil)
            costCodeErrorImageView.isHidden = true
        case submitButton:
            
            submitAction()
            
        default:
            break
        }
        
    }
    
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: - Text Field Delegate

extension JobEntryVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.rightViewMode = .never
    }
}

// MARK: - Presenter

extension JobEntryVC:JobEntryPresenterDelegate{
    
    func updateFieldData(searchType:JobEntrySearchType) {
        guard let data = presenter.data else { return }
        switch searchType {
        case .none:
            updateBuilderPickerVC(data:data)
            updateProjectPickerVC(data:data)
            updateModelPickerVC(data:data)
            updateDivisionPickerVC(data:data)
            updateCompanyPickerVC(data:data)
            updateBusinessManagerPickerVC(data:data)
            updateProjectManagerPickerVC(data:data)
            updateProvStatePickerVC(data:data)
            updateCostCodePickerVC(data:data)
        case .search_builder:
            updateBuilderPickerVC(data:data)
        case .search_division:
            updateDivisionPickerVC(data:data)
        case .search_company:
            updateCompanyPickerVC(data:data)
        case .search_project_manager:
            updateProjectManagerPickerVC(data:data)
        case .search_business_manager:
            updateBusinessManagerPickerVC(data:data)
        case .search_model:
            updateModelPickerVC(data:data)
        case .search_project:
            updateProjectPickerVC(data:data)
        case .search_state:
            updateProvStatePickerVC(data:data)
        case .search_cost_code:
            updateCostCodePickerVC(data:data)
        }
        
        
    }
    
    private func updateBuilderPickerVC(data:ApiListsData){
        builderPickerVC?.arr_data = data.builders?.compactMap { $0.count >= 2 ? $0[1] : nil } ?? []
        builderPickerVC?.picker?.reloadAllComponents()
    }
    
    private func updateProjectPickerVC(data:ApiListsData){
        projectPickerVC?.arr_data = data.projects ?? []
        projectPickerVC?.picker?.reloadAllComponents()
    }
    
    private func updateModelPickerVC(data:ApiListsData){
        modelPickerVC?.arr_data = data.models ?? []
        modelPickerVC?.picker?.reloadAllComponents()
    }
    
    private func updateDivisionPickerVC(data:ApiListsData){
        divisionPickerVC?.arr_data = data.division ?? []
        divisionPickerVC?.picker?.reloadAllComponents()
    }
    
    private func updateCompanyPickerVC(data:ApiListsData){
        companyPickerVC?.arr_data = data.company ?? []
        companyPickerVC?.picker?.reloadAllComponents()
    }
    
    private func updateBusinessManagerPickerVC(data:ApiListsData){
        businessManagerPickerVC?.arr_data = data.businessManagers?.compactMap { $0.count >= 2 ? $0[1] : nil } ?? []
        businessManagerPickerVC?.picker?.reloadAllComponents()
    }
    
    private func updateProjectManagerPickerVC(data:ApiListsData){
        projectManagerPickerVC?.arr_data = data.projectManagers?.compactMap { $0.count >= 2 ? $0[1] : nil } ?? []
        projectManagerPickerVC?.picker?.reloadAllComponents()
    }
    
    private func updateProvStatePickerVC(data:ApiListsData){
        provStatePickerVC?.arr_data = data.states?.compactMap{$0.stateName} ?? []
        provStatePickerVC?.picker?.reloadAllComponents()
    }
    
    private func updateCostCodePickerVC(data:ApiListsData){
        costCodePickerVC?.arr_data = data.costCode ?? []
        costCodePickerVC?.picker?.reloadAllComponents()
    }
    
    
    func updateCityField() {
        cityPickerVC?.arr_data = presenter.cities?.cities ?? []
        cityPickerVC?.picker?.reloadAllComponents()
    }
    
    func updateZipField() {
        zipCodePickerVC?.arr_data = (presenter.zip?.zip ?? []).map({String($0)})
        zipCodePickerVC?.picker?.reloadAllComponents()
    }
    
    func successStoreJob() {
        if self.level == -1{
            self.level = 1
        }else{
            self.level += 1
        }
        if level <= 4{
            self.submitAction()
        }else{
            navigationController?.popViewController(animated: true)
        }
        username = nil
        password = nil
    }
    
    func handelBuilderData(data: Budgets?) {
        addtionalDetailsMainView.isHidden = false
        permitMaterialBudgetTextField.text = data?.permitMaterial ?? ""
        SewerWaterHoursTextField.text = data?.sewerLabor ?? ""
        sewerWaterBudgetTextField.text = data?.sewerMaterial ?? ""
        underslabHoursTextField.text = data?.underslabLabor ?? ""
        underslabBudgetTextField.text = data?.underslabMaterial ?? ""
        roughHoursTextField.text = data?.roughLabor ?? ""
        roughBudgetTextField.text = data?.roughMaterial ?? ""
        trimHoursTextField.text = data?.trimLabor ?? ""
        trimBudgetTextField.text = data?.trimMaterial ?? ""

        if !permitMaterialBudgetTextField.text!.isEmpty{
            permitMaterialBudgetTextField.isEnabled = false
        }
        
        if !SewerWaterHoursTextField.text!.isEmpty{
            SewerWaterHoursTextField.isEnabled = false
        }
        
        if !sewerWaterBudgetTextField.text!.isEmpty{
            sewerWaterBudgetTextField.isEnabled = false
        }
        
        if !underslabHoursTextField.text!.isEmpty{
            underslabHoursTextField.isEnabled = false
        }
        
        if !underslabBudgetTextField.text!.isEmpty{
            underslabBudgetTextField.isEnabled = false
        }
        
        if !roughHoursTextField.text!.isEmpty{
            roughHoursTextField.isEnabled = false
        }
        
        if !roughBudgetTextField.text!.isEmpty{
            roughBudgetTextField.isEnabled = false
        }
        
        if !trimHoursTextField.text!.isEmpty{
            trimHoursTextField.isEnabled = false
        }
        
        if !trimBudgetTextField.text!.isEmpty{
            trimBudgetTextField.isEnabled = false
        }
            
    }
    
    func showSignInVC() {
        let vc = JobEntrySiginInVC.instantiate()
        vc.setSignInData = { username , password in
            self.username = username
            self.password = password
            self.presenter.storeJob(data: self.getUIData())
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    
}

// MARK: - Set Up Collection View

extension JobEntryVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    private func setUpCollectionView(){
        costCodeCollectionView.delegate = self
        costCodeCollectionView.dataSource = self
        costCodeCollectionView.register(.init(nibName: "MulitselectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MulitselectionCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCostCodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MulitselectionCollectionViewCell", for: indexPath) as! MulitselectionCollectionViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.titleLabel.text = selectedCostCodes[indexPath.row]
        
        return cell
    }
    
}


// MARK: - Collection View Cell Delegate
extension JobEntryVC:MulitselectionCellDelegate{
    func deleteSelection(indexPath: IndexPath) {
        self.selectedCostCodes.remove(at: indexPath.row)
        self.costCodeCollectionView.reloadData()
    }
    
}

// MARK: - Set Storyboad

extension JobEntryVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}


//
//if permitMaterialBudgetTextField.isEnabled{
//    data["permit_material"] = permitMaterialBudgetTextField.text!
//}
//if SewerWaterHoursTextField.isEnabled{
//    data["sewer_labor"] = SewerWaterHoursTextField.text!
//}
//if sewerWaterBudgetTextField.isEnabled{
//    data["sewer_material"] = sewerWaterBudgetTextField.text!
//}
//if underslabHoursTextField.isEnabled{
//    data["underslab_labor"] = underslabHoursTextField.text!
//}
//if underslabBudgetTextField.isEnabled{
//    data["underslab_material"] = underslabBudgetTextField.text!
//}
//if roughHoursTextField.isEnabled{
//    data["rough_labor"] = roughHoursTextField.text!
//}
//if roughBudgetTextField.isEnabled{
//    data["rough_material"] = roughBudgetTextField.text!
//}
//if trimHoursTextField.isEnabled{
//    data["trim_labor"] = trimHoursTextField.text!
//}
//if trimBudgetTextField.isEnabled{
//    data["trim_material"] = trimBudgetTextField.text!
//}
