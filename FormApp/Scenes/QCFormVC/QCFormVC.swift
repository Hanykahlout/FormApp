//
//  QCFormVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 25/01/2023.
//

import UIKit
import SVProgressHUD

class QCFormVC: UIViewController {

    
    //MARK: - Outlet
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var addNewFormItemButton: UIButton!
    @IBOutlet weak var addNewFormItemView: UIView!
    @IBOutlet weak var formTypeNoteTableview: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var subContractorStackView: UIStackView!
    @IBOutlet weak var companyView: UIViewDesignable!
    @IBOutlet weak var jobView: UIViewDesignable!
    @IBOutlet weak var divisionView: UIViewDesignable!
    @IBOutlet weak var formTypeView: UIViewDesignable!
    
    @IBOutlet weak var companyBtn: UIButton!
    @IBOutlet weak var jobBtn: UIButton!
    @IBOutlet weak var divisionBtn: UIButton!
    @IBOutlet weak var formTypeBtn: UIButton!
    @IBOutlet weak var subContractorButton: UIButton!
    
    @IBOutlet weak var subContractorTextField: UITextField!
    @IBOutlet weak var diviosnLeaderData: UITextField!
    @IBOutlet weak var formTypeData: UITextField!
    @IBOutlet weak var jobData: UITextField!
    @IBOutlet weak var companiesData: UITextField!
    
    
    @IBOutlet weak var submitBtn: UIButton!
    
    //MARK: - Properties
    
    private let presenter = QCFormPresenter()
    private var companies:[DataDetails]=[]
    private var jobs:[DataDetails]=[]
    private var searchedJobs:[DataDetails]=[]
    private var division:[DataDetails]=[]
    private var forms:[DataDetails]=[]
    private var formsItem:[(tag:String,data:[DataDetails])]=[]
    private var tags = [String]()
    private var subContractors:[SubContractor]=[]
    
    private var companyID=0
    private var formTypeID=0
    private var jobID=0
    private var divisionID=0
    private var subContractorID=0

    
    private var formData:[String : Any] = [:]
    private var requestSubmitted:Bool = false
    private var companyPickerVC: PickerVC?
    private var jobPickerVC: PickerVC?
    private var divitionPickerVC: PickerVC?
    private var formTypePickerVC: PickerVC?
    private var subContractorPickerVC: PickerVC?
    private var selectedJobProject = ""
    private var selectedCellIndexPath:IndexPath!
    private var formPurpose:FormPurpose = .create
    
    var editData: FormInfo?
    var draftData: FormInfo?
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerVCs()
        setupTableview()
        binding()
        btnStatus()
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.show(withStatus: "please wait")
        presenter.delegate=self
        presenter.getCompaniesFromDB(search: "")
        addNewFormItemView.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        checkEditData()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        formTypeNoteTableview.layoutIfNeeded()
        tableViewHeight.constant = formTypeNoteTableview.contentSize.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private Functions
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.title = "Create Form"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func showSaveButton(){
        let rightButton = UIButton()
        rightButton.corner_radius = 10
        rightButton.clipsToBounds = true
        rightButton.backgroundColor = .orange
        rightButton.setTitle("Save", for: .normal)
        rightButton.titleLabel?.font = .init(name: "Urbanist-Regular", size: 14)
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        rightButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        navigationItem.rightBarButtonItem = .init(customView: rightButton)
        
    }
    
    private func hideSaveButton(){
        navigationItem.rightBarButtonItem = nil
    }
    
    private func updateTotalView(){
        totalView.isHidden = formsItem.isEmpty
        if !formsItem.isEmpty{
            var price = 0.0
            var qty = 0.0
            formsItem.forEach { (tag: String, data: [DataDetails]) in
                data.forEach({ item in
                    if item.system == "currency" || item.new_item_type == .price{
                        price += Double(item.price ?? "0.0") ?? 0.0
                        price += Double(item.status ?? "0.0") ?? 0.0
                    }else if item.system == "quantity" || item.new_item_type == .quantity{
                        let quantity = Double(item.status ?? "0.0") ?? 0.0
                        price += (quantity) * (Double(item.price ?? "0.0") ?? 0.0)
                        qty += quantity
                    }else{
                        price += Double(item.price ?? "0.0") ?? 0.0
                    }
                })
            }
            
            
            totalPriceLabel.text = String(price)
            totalQuantityLabel.text = String(qty)
        }
    }
    
    private func checkEditData(){
        if let editData = editData{
            hideSaveButton()
            setFormData(fromData: editData)
        }else if let draftData = draftData{
            showSaveButton()
            setFormData(fromData: draftData)
            checkUnblockedItems()
        }else{
            showSaveButton()
        }
        
    }
    
    private func setFormData(fromData:FormInfo){
        
        navigationItem.title = fromData.form?.title ?? ""
        
        companyID = fromData.company?.id ?? 0
        companyBtn.isEnabled = true
        companyView.backgroundColor = .black
        companiesData.text = fromData.company?.title ?? ""
        
        jobID = fromData.job?.id ?? 0
        jobBtn.isEnabled = true
        jobView.backgroundColor = .black
        jobData.text = fromData.job?.title ?? ""
        jobView.backgroundColor = .black
        
        formTypeID = fromData.form?.id ?? 0
        formTypeBtn.isEnabled = true
        formTypeView.backgroundColor = .black
        formTypeData.text = fromData.form?.title ?? ""
        
        if fromData.form?.is_fixture == 1{
            subContractorID = fromData.sub_contractor?.id ?? 0
            subContractorTextField.text = fromData.sub_contractor?.name ?? ""
            presenter.getSubContractorsDBModel(search: "")
            subContractorStackView.isHidden = false
        }else{
            subContractorStackView.isHidden = true
        }
        
        divisionID = fromData.division?.id ?? 0
        divisionBtn.isEnabled = true
        divisionView.backgroundColor = .black
        diviosnLeaderData.text = fromData.division?.title ?? ""
        
        
        
        for item in fromData.items ?? []{
            let index:Int? = formsItem.firstIndex(where: {
                $0.tag == item.item?.tag ?? ""
            })
            
            if item.id == nil{
                let name = item.name ?? ""
                let status = item.value ?? ""
                let new_item_type = item.new_item_type ?? .text
                let isFromUser = true
                let isWithPrice = item.withPrice == "1"
                let price = item.price
                let image = item.image
                
                if let i = index{
                    formsItem[i].data.append(.init(name: name , status: status ,new_item_type: new_item_type,isFromUser: isFromUser ,isWithPrice: isWithPrice ,price: price,image: image,isWithPic: image != nil,tag: "Your Form Items"))
                }else{
                    let item:(tag:String,data:[DataDetails]) = (tag:"Your Form Items",[DataDetails(name: name , status: status ,new_item_type: new_item_type,isFromUser: isFromUser ,isWithPrice: isWithPrice ,price: price,image: image,isWithPic: image != nil,tag: "Your Form Items")])
                    formsItem.append(item)
                }
                
            }else if item.item?.system_type != nil{
                let id = item.item?.id ?? 0
                let value = item.value ?? ""
                let title = item.item?.title
                let status = item.item?.value
                let price = item.item?.price
                let show_price = item.item?.show_price
                let system = item.item?.system
                let system_type = item.item?.system_type
                let system_list = item.item?.system_list
                let image = item.image
                let show_image = item.item?.show_image
                let show_notes = item.item?.show_notes
                let tag = item.item?.tag
                let pin = item.item?.pin
                let is_blocked = item.item?.is_blocked
                
                
                if let i = index{
                    formsItem[i].data.append(.init(id: id,value: value,title: title, status: status,price: price,show_price: show_price,system: system, system_type: system_type, system_list: system_list,image: image,isWithPic: image != nil,show_image: show_image,show_notes: show_notes,tag: tag,pin: pin,is_blocked: is_blocked))
                }else{
                    let item:(tag:String,data:[DataDetails]) = (tag:item.item?.tag ?? "",[DataDetails(id: id,value: value,title: title, status: status,price: price,show_price: show_price,system: system, system_type: system_type, system_list: system_list,image: image,isWithPic: image != nil,show_image: show_image,show_notes: show_notes,tag: tag,pin: pin,is_blocked: is_blocked)])
                    formsItem.append(item)
                }
                
            }else if item.item?.system == "side-by-side"{
                let firstField = item.new_boxes?.first
                let firstSide = SideData(type: firstField?.type,title: firstField?.title ,value: firstField?.value)
                
                let secondField = item.new_boxes?[1]
                let secondSide = SideData(type: secondField?.type,title: secondField?.title ,value: secondField?.value)
                
                let sideBySideData = SideBySideData(first_field: firstSide,second_field: secondSide)
                let tag = item.item?.tag
                let pin = item.item?.pin
                let is_blocked = item.item?.is_blocked
                
                if let i = index{
                    formsItem[i].data.append(.init(id:item.item?.id,sideBySide: sideBySideData,tag: tag,pin: pin,is_blocked: is_blocked))
                }else{
                    let item:(tag:String,data:[DataDetails]) = (tag:tag ?? "",[DataDetails(id:item.item?.id,sideBySide: sideBySideData,tag: tag,pin: pin,is_blocked: is_blocked)])
                    formsItem.append(item)
                }
                
            }else{
                var newBoxs = [NewBoxData]()
                for box in item.new_boxes ?? []{
                    newBoxs.append(.init(title:box.title,box_type: box.type,value: box.value))
                }
                let id = item.item_id ?? -1
                let title = item.item?.title ?? ""
                let status = item.value ?? ""
                let note = item.notes ?? ""
                let system = item.item?.system
                let reasons = item.item?.fail_reasons
                let reason_id = item.fail_reason?.id
                let reason = item.fail_reason?.title
                let image = item.image
                let price = item.item?.price
                let show_price = item.item?.show_price
                let show_image = item.item?.show_image
                let show_notes = item.item?.show_notes
                let tag = item.item?.tag
                let pin = item.item?.pin
                let is_blocked = item.item?.is_blocked
                
                if let i = index{
                    formsItem[i].data.append(.init(id: id, title: title, status: status, note: note,system: system,reasons: reasons,reason_id: reason_id,reason: reason,new_boxes: newBoxs,image: image,isWithPic: image != nil,price: price,show_price: show_price,show_image: show_image,show_notes: show_notes,tag: tag,pin:pin,is_blocked:is_blocked))
                }else{
                    let item:(tag:String,data:[DataDetails]) = (tag:item.item?.tag ?? "",[DataDetails(id: id, title: title, status: status, note: note,system: system,reasons: reasons,reason_id: reason_id,reason: reason,new_boxes: newBoxs,image: image,isWithPic: image != nil,price: price,show_price: show_price,show_image: show_image,show_notes: show_notes,tag: tag,pin: pin,is_blocked:is_blocked)])
                    formsItem.append(item)
                }
                
            }
        }
        self.companyID = Int(fromData.company_id ?? "-1")!
        self.presenter.getJobsFromDB(companyID: "\(self.companyID)", search: "")
        self.presenter.getDivisionFromDB(companyID: "\(self.companyID)", search: "")
        self.presenter.getFormsFromDB(companyID: "\(self.companyID)", search: "")
        
        let data = formsItem.flatMap{$0.data}
        formsItem = groupAndSortFormItems(data: data)
        formTypeNoteTableview.reloadData()
    }
    
    private func btnStatus(){
        formTypeBtn.isEnabled=false
        companyBtn.isEnabled=false
        jobBtn.isEnabled=false
        divisionBtn.isEnabled=false
        
        companyView.backgroundColor = .systemGray5
        jobView.backgroundColor = .systemGray5
        divisionView.backgroundColor = .systemGray5
        formTypeView.backgroundColor = .systemGray5
        
        
        
        diviosnLeaderData.isEnabled=false
        jobData.isEnabled=false
        companiesData.isEnabled=false
        formTypeData.isEnabled=false
        
        
    }
    
    private func setUpPickerVCs(){
        setUpCompanyPicker()
        setUpJobPicker()
        setUpDivisionLeaderPicker()
        setUpFormTypePicker()
        setUpSubContractorPicker()
    }
    
    private func setUpCompanyPicker() {
        companyPickerVC = PickerVC.instantiate()
        
        companyPickerVC!.searchBarHiddenStatus = false
        companyPickerVC!.searchAction = { searchText in
            self.presenter.getCompaniesFromDB(search: searchText)
        }
        
        companyPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.companiesData.text = self.companies[index].title ?? ""
            self.companyID = self.companies[index].id ?? 0
            self.jobs = []
            self.division = []
            self.forms = []
            self.jobData.text=""
            self.diviosnLeaderData.text = ""
            self.formTypeData.text = ""
            self.presenter.getJobsFromDB(companyID: "\(self.companyID)", search: "")
            self.presenter.getDivisionFromDB(companyID: "\(self.companyID)", search: "")
            self.presenter.getFormsFromDB(companyID: "\(self.companyID)", search: "")
            self.presenter.getFormItemFromDB(project: self.selectedJobProject,
                                             formTypeID:"\(self.formTypeID)" )
            
        }
        
        companyPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpJobPicker() {
        jobPickerVC = PickerVC.instantiate()
    
        jobPickerVC!.searchBarHiddenStatus = false
        jobPickerVC!.searchAction = { searchText in
            self.presenter.getJobsFromDB(companyID: String(self.companyID), search: searchText)
        }

        jobPickerVC!.delegate = {name , index in
            
            self.jobData.text = self.jobs[index].title ?? ""
            self.jobID = self.jobs[index].id ?? 0
            self.selectedJobProject = self.jobs[index].project ?? ""
            
            self.presenter.getFormItemFromDB(project: self.selectedJobProject,
                                             formTypeID:"\(self.formTypeID)" )
            
        }
        
        jobPickerVC?.newPageAction = { currentPage , search in
            self.presenter.getJobsFromDB(companyID: "\(self.companyID)", search: search)
        }
        
        jobPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpDivisionLeaderPicker() {
        divitionPickerVC = PickerVC.instantiate()
        
        divitionPickerVC!.searchBarHiddenStatus = false
        divitionPickerVC!.searchAction = { searchText in
            self.presenter.getDivisionFromDB(companyID: String(self.companyID), search: searchText)
        }
        
        divitionPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.diviosnLeaderData.text = self.division[index].title ?? ""
            self.divisionID = self.division[index].id ?? 0
            
        }
        
        divitionPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpFormTypePicker() {
        formTypePickerVC = PickerVC.instantiate()
        
        formTypePickerVC!.searchBarHiddenStatus = false
        formTypePickerVC!.searchAction = { searchText in
            self.presenter.getFormsFromDB(companyID: String(self.companyID), search: searchText)
        }
        
        formTypePickerVC!.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.formTypeData.text = self.forms[index].title ?? ""
            self.formTypeID = self.forms[index].id ?? 0
            if self.forms[index].is_fixture == 1{
                self.presenter.getSubContractorsDBModel(search: "")
                self.subContractorStackView.isHidden = false
            }else{
                self.subContractorStackView.isHidden = true
            }
            self.presenter.getFormItemFromDB(project: self.selectedJobProject,
                                             formTypeID:"\(self.formTypeID)" )
            
        }
        
        formTypePickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpSubContractorPicker() {
        subContractorPickerVC = PickerVC.instantiate()
        
        subContractorPickerVC!.searchBarHiddenStatus = false
        subContractorPickerVC!.searchAction = { searchText in
            self.presenter.getSubContractorsDBModel(search: searchText)
        }
        
        subContractorPickerVC!.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.subContractorTextField.text = self.subContractors[index].name ?? ""
            self.subContractorID = self.subContractors[index].id ?? 0
        }
        
        subContractorPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    @objc private func saveAction(){
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.show(withStatus: "please wait")
        formPurpose = draftData == nil ? .draft : .updateDraft
        self.presenter.submitFormData(formPurpose: formPurpose,formsDetails: self.formDetailsParameter())
    }
    
    
    private func submitAction(){
        do{
            _ = try diviosnLeaderData.validatedText(validationType: .requiredField(field: " Select Division leader please"))
            _ = try formTypeData.validatedText(validationType: .requiredField(field: "Select form type please"))
            _ = try jobData.validatedText(validationType: .requiredField(field: "Select job please"))
            _ = try companiesData.validatedText(validationType: .requiredField(field: "Select company please"))
            
            Alert.showAlert(viewController: self, title: "Do you  want to send the form", message: "") { Value in
                
                if Value == true{
                    if self.isAllFormItemsSelected(){
                        SVProgressHUD.setBackgroundColor(.white)
                        SVProgressHUD.show(withStatus: "please wait")
                        self.formPurpose = self.editData != nil ? .edit : .create
                        
                        self.presenter.submitFormData(formPurpose: self.formPurpose,formsDetails: self.formDetailsParameter())
                    }else{
                        Alert.showErrorAlert(message:  "Add your form Item Data,You have at least to choose status for every item" )
                    }
                }
            }
            
        }catch{
            Alert.showErrorAlert(message: (error as! ValidationError).message)
        }
    }
    
    
    private func formDetailsParameter() -> [String:Any]{
        formData.removeAll()
        formData["company_id"] = "\(companyID)"
        formData["job_id"] = "\(jobID)"
        formData["division_id"] = "\(divisionID)"
        formData["form_type_id"] = "\(formTypeID)"
        if !subContractorStackView.isHidden{
            formData["subContractor_id"] = "\(subContractorID)"
        }
        
        if editData != nil{
            formData["submitted_form_id"] = "\(editData!.id ?? -1)"
        }
        
        if draftData != nil{
            formData["saved_form_id"] = "\(draftData!.id ?? -1)"
        }
        var _index = 0
        for item in formsItem {
            for index in 0 ..< item.data.count{
                if item.data[index].isFromUser ?? false{
                    formData["new_items[\(_index)][name]"] = item.data[index].name ?? ""
                    formData["new_items[\(_index)][value]"] = item.data[index].status ?? ""
                    formData["new_items[\(_index)][new_item_type]"] = (item.data[index].new_item_type ?? .text).rawValue
                    formData["new_items[\(_index)][withPrice]"] = (item.data[index].isWithPrice ?? false) ? "1" : "0"
                    formData["new_items[\(_index)][price]"] = item.data[index].price ?? ""
                    if item.data[index].isWithPic ?? false{
                        formData["new_items[\(_index)][image]"] = item.data[index].image ?? ""
                    }
                }else if item.data[index].system == "side-by-side" {
                    let sideBySide = item.data[index].side_by_side
                    formData["form_items[\(_index)][item_id]"] = String(item.data[index].id ?? 0)
                    formData["form_items[\(_index)][new_boxes][0][title]"] = sideBySide?.first_field?.title ?? ""
                    formData["form_items[\(_index)][new_boxes][0][type]"] = sideBySide?.first_field?.type ?? ""
                    formData["form_items[\(_index)][new_boxes][0][value]"] = sideBySide?.first_field?.value ?? ""
                    
                    formData["form_items[\(_index)][new_boxes][1][title]"] = sideBySide?.second_field?.title ?? ""
                    formData["form_items[\(_index)][new_boxes][1][type]"] = sideBySide?.second_field?.type ?? ""
                    formData["form_items[\(_index)][new_boxes][1][value]"] = sideBySide?.second_field?.value ?? ""
                    
                }else{
                    formData["form_items[\(_index)][item_id]"] = String(item.data[index].id ?? 0)
                    let status = item.data[index].status ?? ""
                    formData["form_items[\(_index)][value]"] = status.lowercased()
                    formData["form_items[\(_index)][notes]"] = item.data[index].note ?? ""
                    formData["form_items[\(_index)][fail_reason_id]"] = String(item.data[index].reason_id ?? -1)
                    if item.data[index].isWithPic ?? false{
                        formData["form_items[\(_index)][image]"] = item.data[index].image ?? ""
                    }
                    for i in 0..<(item.data[index].new_boxes ?? []).count{
                        let box = item.data[index].new_boxes![i]
                        formData["form_items[\(_index)][new_boxes][\(i)][title]"] = box.title ?? ""
                        formData["form_items[\(_index)][new_boxes][\(i)][type]"] = box.box_type ?? ""
                        formData["form_items[\(_index)][new_boxes][\(i)][value]"] = box.value ?? ""
                    }
                }
                _index += 1
            }
        }
        
        
        return formData
    }
    
    private func isAllFormItemsSelected() -> Bool{
        for tags in formsItem{
            for item in tags.data{
                let chechResult = item.status == nil
                if chechResult && !(item.isFromUser ?? false) && item.system_type == nil && item.system != "side-by-side"{
                    return false
                }
            }
        }
        
        return true
    }
    
    
    private func checkIfThereFieldItems()-> Bool{
        for item in formsItem {
            if item.data.contains(where: {$0.status == "fail"}){
                return true
            }
        }
        return false
    }
    
    
    private func checkUnBlockedItemsFilled() -> Bool {
        
        var numberOfAddedFields = 0
        for formItem in formsItem{
            
            for data in formItem.data{
                if data.is_blocked != 1 {
                    if data.isFromUser ?? false{
                        numberOfAddedFields += 1
                        continue
                    }else if data.system == "side-by-side"{
                        if !(data.side_by_side?.first_field?.value?.isEmpty ?? true) &&
                            !(data.side_by_side?.second_field?.value?.isEmpty ?? true) {
                            numberOfAddedFields += 1
                        }
                    }else{
                        if !(data.status?.isEmpty ?? true){
                            numberOfAddedFields += 1
                        }
                    }
                }else{
                    numberOfAddedFields += 1
                }
            }
            
        }
        return numberOfAddedFields == formsItem.flatMap{$0.data}.count
    }
    
}

//MARK: - Binding
extension QCFormVC{
    
    private func binding(){
        submitBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        
        addNewFormItemButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        companyBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        jobBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        divisionBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        formTypeBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        subContractorButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func AddFormItemNote( _ sender:UITextField){
        let tag = sender.tag
        let row = tag & 0xFFFF
        let section = tag >> 16
        formsItem[section].data[row].note = sender.text ?? ""
    }
    
    @objc func AddFormItemStatus( _ sender:UITextField){
        let tag = sender.tag
        let row = tag & 0xFFFF
        let section = tag >> 16
        
        formsItem[section].data[row].status = sender.text ?? ""
        if formsItem[section].data[row].new_item_type == .quantity ||
            formsItem[section].data[row].system == "quantity" ||
            formsItem[section].data[row].new_item_type == .price ||
            formsItem[section].data[row].system == "currency" {
            updateTotalView()
        }
    }
    
    @objc func title1TextFieldAction( _ sender:UITextField){
        let tag = sender.tag
        let row = tag & 0xFFFF
        let section = tag >> 16
        formsItem[section].data[row].side_by_side?.first_field?.value = sender.text ?? ""
    }
    
    
    @objc func title2TextFieldAction( _ sender:UITextField){
        
        let tag = sender.tag
        let row = tag & 0xFFFF
        let section = tag >> 16
        formsItem[section].data[row].side_by_side?.second_field?.value = sender.text ?? ""
    }
    
    
    @objc func AddFormItemName( _ sender:UITextField){
        let tag = sender.tag
        let row = tag & 0xFFFF
        let section = tag >> 16
        formsItem[section].data[row].name = sender.text ?? ""
    }
    
    @objc func AddFormItemPrice( _ sender:UITextField){
        let tag = sender.tag
        let row = tag & 0xFFFF
        let section = tag >> 16
        formsItem[section].data[row].price = sender.text ?? ""
        updateTotalView()
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case submitBtn:
            submitAction()
        case addNewFormItemButton:
            let vc = CreateFormItemVC.instantiate()
            vc.modalPresentationStyle = .overCurrentContext
            vc.addAction = { type , isWithPrice in
                let item:DataDetails = .init(name: "", status: "", new_item_type: type,isFromUser: true, isWithPrice: isWithPrice,price: "0",image: "",isWithPic: false,tag: "Your Form Items")
                
                var index:Int?
                for i in 0..<self.formsItem.count{
                    if self.formsItem[i].tag == item.tag{
                        index = i
                        break
                    }
                }
                if let i = index{
                    self.formsItem[i].data.append(item)
                }else{
                    let item:(tag:String,data:[DataDetails]) = (tag:item.tag ?? "",[item])
                    self.formsItem.append(item)
                    
                }
                self.formTypeNoteTableview.reloadData()
                self.viewWillLayoutSubviews()
                
            }
            present(vc, animated: true)
        case companyBtn:
            self.present(companyPickerVC!, animated: true, completion: nil)
        case jobBtn:
            self.present(jobPickerVC!, animated: true, completion: nil)
        case divisionBtn:
            self.present(divitionPickerVC!, animated: true, completion: nil)
        case formTypeBtn:
            self.present(formTypePickerVC!, animated: true, completion: nil)
        case subContractorButton:
            self.present(subContractorPickerVC!, animated: true, completion: nil)
        default: break
        }
    }
    
}

// MARK: - Set Stroyboard
extension QCFormVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}

// MARK: - Set Up Table View Delegate And DataSource
extension QCFormVC:UITableViewDelegate, UITableViewDataSource{
    func setupTableview(){
        formTypeNoteTableview.register(FormTypeNoteCell.self)
        formTypeNoteTableview.register(.init(nibName: "UserFormItemTableViewCell", bundle: nil), forCellReuseIdentifier: "UserFormItemTableViewCell")
        formTypeNoteTableview.register(.init(nibName: "CustomFormItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomFormItemTableViewCell")
        formTypeNoteTableview.register(.init(nibName: "SideBySideTableViewCell", bundle: nil), forCellReuseIdentifier: "SideBySideTableViewCell")
        formTypeNoteTableview.delegate=self
        formTypeNoteTableview.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return formsItem.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  formsItem[section].tag
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        let label = UILabel()
        label.text = formsItem[section].tag
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.shadowColor = .white
        label.shadowOffset = .init(width: 0, height: 1)
        label.shadow_Radius = 12
        label.shadow_Opacity = 1
        
        
        let separatorView = UIView()
        separatorView.backgroundColor = .gray
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(separatorView)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTotalView()
        return formsItem[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if formsItem[indexPath.section].data[indexPath.row].isFromUser ?? false{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserFormItemTableViewCell", for: indexPath) as! UserFormItemTableViewCell
            cell.delegate = self
            cell.setData(data: formsItem[indexPath.section].data[indexPath.row],indexPath: indexPath)
            
            let type = formsItem[indexPath.section].data[indexPath.row].new_item_type
            if  type != .pass_fail && type != .yes_no && type != .date{
                cell.valueTextField.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
                cell.valueTextField.tag = indexPath.section << 16 | indexPath.row
            }
            
            cell.priceTextField.addTarget(self, action: #selector(AddFormItemPrice), for: .editingDidEnd)
            cell.priceTextField.tag = indexPath.section << 16 | indexPath.row
            
            cell.nameTextField.addTarget(self, action: #selector(AddFormItemName), for: .editingDidEnd)
            cell.nameTextField.tag = indexPath.section << 16 | indexPath.row
            
            return cell
        }else if formsItem[indexPath.section].data[indexPath.row].system_type != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomFormItemTableViewCell", for: indexPath) as! CustomFormItemTableViewCell
            cell.delegate = self
            cell.setData(data: formsItem[indexPath.section].data[indexPath.row],indexPath: indexPath)
            cell.valueTextField.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
            cell.valueTextField.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
            cell.valueTextField.tag = indexPath.section << 16 | indexPath.row
            
            return cell
        }else if formsItem[indexPath.section].data[indexPath.row].system == "side-by-side"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBySideTableViewCell", for: indexPath) as! SideBySideTableViewCell
            cell.delegate = self
            cell.setData(data: formsItem[indexPath.section].data[indexPath.row],indexPath: indexPath)
            cell.title1TextField.addTarget(self, action: #selector(title1TextFieldAction), for: .editingDidEnd)
            cell.title1TextField.tag = indexPath.section << 16 | indexPath.row
            
            cell.title2TextField.addTarget(self, action: #selector(title2TextFieldAction), for: .editingDidEnd)
            cell.title2TextField.tag = indexPath.section << 16 | indexPath.row
            
            return cell
        }
        
        let cell:FormTypeNoteCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(obj: formsItem[indexPath.section].data[indexPath.row],indexPath: indexPath)
        cell.delegate = self
        cell.formTitleNote.addTarget(self, action: #selector(AddFormItemNote), for: .editingDidEnd)
        cell.formTitleNote.tag = indexPath.section << 16 | indexPath.row
        
        cell.formTypeStatus.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
        cell.formTypeStatus.tag = indexPath.section << 16 | indexPath.row
        
        cell.statusWithoutSelectionTextField.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
        cell.statusWithoutSelectionTextField.tag = indexPath.section << 16 | indexPath.row
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1.0
        }
    }
    
}


// MARK: - Table View Cell (FormTypeNoteCell) Delegate
extension QCFormVC:FormTypeNoteCellDelegate{
    func addPicAction(indexPath: IndexPath) {
        self.selectedCellIndexPath = indexPath
        setImageBy(source: .photoLibrary)
    }
    
    func statusPickerAction(data:[String],indexPath: IndexPath) {
        let vc = PickerVC.instantiate()
        vc.arr_data = data
        vc.searchBarHiddenStatus = true
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            self.formsItem[indexPath.section].data[indexPath.row].status = name
            self.formTypeNoteTableview.reloadRows(at: [indexPath], with: .automatic)
            let cell = self.formTypeNoteTableview.cellForRow(at: indexPath) as! FormTypeNoteCell
            cell.reasonTextField.isHidden = name != "fail"
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func reasonPickerAction(formItemId:Int,indexPath: IndexPath) {
        let predicate = NSPredicate(format: "form_item_id == '\(formItemId)'")
        let realmReasons = RealmManager.sharedInstance.fetchObjects(FormItemReason.self,predicate: predicate) ?? []
        let vc = PickerVC.instantiate()
        vc.arr_data = realmReasons.map{$0.title ?? "----"}
        vc.searchBarHiddenStatus = true
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            self.formsItem[indexPath.section].data[indexPath.row].reason = name
            self.formsItem[indexPath.section].data[indexPath.row].reason_id = realmReasons[index].id
            self.formTypeNoteTableview.reloadRows(at: [indexPath], with: .automatic)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func datePickerAction(indexPath:IndexPath) {
        let vc = DatePickerVC.instantiate()
        vc.dateSelected = { selectedDate , date in
            self.formsItem[indexPath.section].data[indexPath.row].status = selectedDate
            self.formTypeNoteTableview.reloadRows(at: [indexPath], with: .automatic)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func showPickerVC(type: String,parentIndexPath:IndexPath,childIndex:Int) {
        if type == "Date" {
            let vc = DatePickerVC.instantiate()
            vc.modalPresentationStyle = .overFullScreen
            vc.dateSelected = { selectedDate , date in
                self.formsItem[parentIndexPath.section].data[parentIndexPath.row].new_boxes?[childIndex].value = selectedDate
                let parentCell = self.formTypeNoteTableview.cellForRow(at: parentIndexPath) as! FormTypeNoteCell
                let childCell = parentCell.tableView.cellForRow(at: IndexPath.init(row: childIndex, section: 0)) as! NewBoxTableViewCell
                childCell.boxTextField.text = selectedDate
            }
            self.present(vc, animated: true, completion: nil)
        }else{
            let selectionPickerVC = PickerVC.instantiate()
            selectionPickerVC.arr_data = ["Yes","No"]
            selectionPickerVC.searchBarHiddenStatus = true
            selectionPickerVC.isModalInPresentation = true
            selectionPickerVC.modalPresentationStyle = .overFullScreen
            selectionPickerVC.definesPresentationContext = true
            selectionPickerVC.delegate = { name , selectedIndex in
                // Selection Action Here
                self.formsItem[parentIndexPath.section].data[parentIndexPath.row].new_boxes?[childIndex].value = name
                let parentCell = self.formTypeNoteTableview.cellForRow(at: parentIndexPath) as! FormTypeNoteCell
                let childCell = parentCell.tableView.cellForRow(at: IndexPath.init(row: childIndex, section: 0)) as! NewBoxTableViewCell
                childCell.boxTextField.text = name
            }
            self.present(selectionPickerVC, animated: true, completion: nil)
        }
    }
    
    func updateNewBoxData(text: String, parentIndexPath:IndexPath, childIndex: Int) {
        self.formsItem[parentIndexPath.section].data[parentIndexPath.row].new_boxes?[childIndex].value = text
    }
    
    func updatePicStatus(indexPath:IndexPath,withPic: Bool) {
        self.formsItem[indexPath.section].data[indexPath.row].isWithPic = withPic
        if !withPic{
            self.formsItem[indexPath.section].data[indexPath.row].image = nil
        }
        self.formTypeNoteTableview.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

// MARK: - Table View Cell (UserFormItemDelegate) Delegate
extension QCFormVC:UserFormItemDelegate{
    
    func selectionAction(type: NewFormItemType, indexPath: IndexPath) {
        if type != .date{
            let selectionPickerVC = PickerVC.instantiate()
            selectionPickerVC.arr_data = type == .pass_fail ? ["Pass","Fail"] : ["Yes","No"]
            selectionPickerVC.searchBarHiddenStatus = true
            selectionPickerVC.isModalInPresentation = true
            selectionPickerVC.modalPresentationStyle = .overFullScreen
            selectionPickerVC.definesPresentationContext = true
            selectionPickerVC.delegate = { name , selectedIndex in
                // Selection Action Here
                self.formsItem[indexPath.section].data[indexPath.row].status = name
                let cell = self.formTypeNoteTableview.cellForRow(at: indexPath) as! UserFormItemTableViewCell
                cell.valueTextField.text = name
            }
            self.present(selectionPickerVC, animated: true, completion: nil)
        }else{
            let vc = DatePickerVC.instantiate()
            vc.modalPresentationStyle = .overFullScreen
            vc.dateSelected = { selectedDate , date in
                self.formsItem[indexPath.section].data[indexPath.row].status = selectedDate
                let cell = self.formTypeNoteTableview.cellForRow(at: indexPath) as! UserFormItemTableViewCell
                cell.valueTextField.text = selectedDate
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}


// MARK: - Table View Cell (CustomFormItemDelegate) Delegate
extension QCFormVC:CustomFormItemDelegate{
    
    func selectionAction(indexPath: IndexPath,arr:[String],isDate:Bool) {
        if isDate {
            let vc = DatePickerVC.instantiate()
            vc.modalPresentationStyle = .overFullScreen
            vc.dateSelected = { selectedDate , date in
                self.formsItem[indexPath.section].data[indexPath.row].status = selectedDate
                let cell = self.formTypeNoteTableview.cellForRow(at: indexPath) as! CustomFormItemTableViewCell
                cell.valueTextField.text = selectedDate
            }
            self.present(vc, animated: true, completion: nil)
        }else{
            let selectionPickerVC = PickerVC.instantiate()
            selectionPickerVC.arr_data = arr
            selectionPickerVC.searchBarHiddenStatus = true
            selectionPickerVC.isModalInPresentation = true
            selectionPickerVC.modalPresentationStyle = .overFullScreen
            selectionPickerVC.definesPresentationContext = true
            selectionPickerVC.delegate = { name , selectedIndex in
                // Selection Action Here
                self.formsItem[indexPath.section].data[indexPath.row].status = name
                let cell = self.formTypeNoteTableview.cellForRow(at: indexPath) as! CustomFormItemTableViewCell
                cell.valueTextField.text = name
            }
            self.present(selectionPickerVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: - Table View Cell (SideBySideCell) Delegate
extension QCFormVC:SideBySideCellDelegate{
    
    func selectionAction(indexPath: IndexPath, arr: [String], isDate: Bool, isFirstField: Bool) {
        if isDate {
            let vc = DatePickerVC.instantiate()
            vc.modalPresentationStyle = .overFullScreen
            vc.dateSelected = { selectedDate , date in
                self.formsItem[indexPath.section].data[indexPath.row].status = selectedDate
                let cell = self.formTypeNoteTableview.cellForRow(at: indexPath) as! SideBySideTableViewCell
                if isFirstField{
                    cell.title1TextField.text = selectedDate
                }else{
                    cell.title2TextField.text = selectedDate
                }
            }
            self.present(vc, animated: true, completion: nil)
        }else{
            let selectionPickerVC = PickerVC.instantiate()
            selectionPickerVC.arr_data = arr
            selectionPickerVC.searchBarHiddenStatus = true
            selectionPickerVC.isModalInPresentation = true
            selectionPickerVC.modalPresentationStyle = .overFullScreen
            selectionPickerVC.definesPresentationContext = true
            selectionPickerVC.delegate = { name , selectedIndex in
                // Selection Action Here
                self.formsItem[indexPath.section].data[indexPath.row].status = name
                let cell = self.formTypeNoteTableview.cellForRow(at: indexPath) as! SideBySideTableViewCell
                if isFirstField{
                    cell.title1TextField.text = name
                }else{
                    cell.title2TextField.text = name
                }
            }
            self.present(selectionPickerVC, animated: true, completion: nil)
        }
    }
    
    func blockedAction() {
        Alert.showErrorAlert(message: "You have to fill in the non-blocking items first, then save the form in order to be able to fill in that item")
    }
    
}

// MARK: - Presenter Delegate
extension QCFormVC:QCFormPresenterDelegate{
    
    func checkUnblockedItems() {
        if checkUnBlockedItemsFilled(){
            for i in 0..<formsItem.count{
                for j in 0..<formsItem[i].data.count{
                    formsItem[i].data[j].is_blocked = 0
                }
            }
        }
        formTypeNoteTableview.reloadData()
    }
    
    func clearFields(){
        if checkIfThereFieldItems(){
            Alert.showSuccessAlert(title: "Alert", message: "Form has failed items. Please fix the failed items by going to incomplete failed forms")
        }
        formsItem=[]
        formTypeNoteTableview.reloadData()
        companiesData.text=""
        jobData.text=""
        diviosnLeaderData.text=""
        formTypeData.text=""
        jobBtn.isEnabled=false
        jobView.backgroundColor = .systemGray5
    }
    

    func getCompanyData(data: CompaniesData) {
        companies=data.companies
        companyBtn.isEnabled=true
        self.companyView.backgroundColor = .black
        SVProgressHUD.dismiss()
        if let companyPickerVC = self.companyPickerVC{
            companyPickerVC.arr_data = companies.map{$0.title ?? ""}
            companyPickerVC.index = 0
            companyPickerVC.picker?.reloadAllComponents()
        }
    }
    

    func getJobData(data: JobData) {
        jobs=data.jobs
        jobBtn.isEnabled=true
        self.jobView.backgroundColor = .black
        if let jobPickerVC = self.jobPickerVC{
            jobPickerVC.totalPages = data.total_pages ?? 1
            if jobPickerVC.currentPage == 1{
                jobPickerVC.arr_data = jobs.map{$0.title ?? ""}
            }else{
                jobPickerVC.arr_data.append(contentsOf: jobs.map{$0.title ?? ""})
            }
                
            jobPickerVC.index = 0
            jobPickerVC.picker?.reloadAllComponents()
            
        }
    }
    
    
    func getFormsData(data: FormsData) {
        forms.removeAll()
        data.forms.forEach({
            if $0.form_status == "active"{
                if $0.users?.isEmpty ?? true{
                    forms.append($0)
                }else{
                    if $0.users!.contains(String(AppData.id)){
                        forms.append($0)
                    }
                }
            }
        })
        
        formTypeBtn.isEnabled=true
        self.formTypeView.backgroundColor = .black
        SVProgressHUD.dismiss()
        
        if let formTypePickerVC = self.formTypePickerVC{
            formTypePickerVC.arr_data = forms.map{$0.title ?? ""}
            formTypePickerVC.picker?.reloadAllComponents()
        }
    }
    
    
    func getDivition(data: DiviosnData) {
        division=data.divisions
        divisionBtn.isEnabled=true
        self.divisionView.backgroundColor = .black
        SVProgressHUD.dismiss()
        
        if let divitionPickerVC = self.divitionPickerVC{
            divitionPickerVC.arr_data = division.map{$0.title ?? ""}
            divitionPickerVC.index = 0
            divitionPickerVC.picker?.reloadAllComponents()
        }
    }
    
    
    
    func getSubContractors(data: SubContractorsResponse) {
        subContractors=data.subContractors ?? []
        SVProgressHUD.dismiss()
        
        if let subContractorPickerVC = self.subContractorPickerVC{
            subContractorPickerVC.arr_data = subContractors.map{$0.name ?? ""}
            subContractorPickerVC.index = 0
            subContractorPickerVC.picker?.reloadAllComponents()
        }
    }
    
    func getFormItemsData(data: FormItemData) {
        formsItem = groupAndSortFormItems(data: data.formItems)
        formTypeNoteTableview.reloadData()
        
    }
    
    
    func groupAndSortFormItems(data: [DataDetails]) -> [(tag: String, data: [DataDetails])] {
        // Step 1: Group the data by tag (assign empty string for nil tags)
        var groupedData: [String: [DataDetails]] = [:]
        for item in data {
            let tag = item.tag ?? ""
            if var group = groupedData[tag] {
                group.append(item)
                groupedData[tag] = group
            } else {
                groupedData[tag] = [item]
            }
        }
        
        // Step 2: Sort the data alphabetically by tag
        var sortedGroupedData = groupedData.sorted(by: { $0.key < $1.key })
        
        // Step 3: Custom sorting function for tag groups
        func compareTagGroups(group1: (key: String, value: [DataDetails]), group2: (key: String, value: [DataDetails])) -> Bool {
            let hasPinnedItems1 = group1.value.contains { $0.pin != nil }
            let hasPinnedItems2 = group2.value.contains { $0.pin != nil }
            
            if hasPinnedItems1 && !hasPinnedItems2 {
                return true
            } else if !hasPinnedItems1 && hasPinnedItems2 {
                return false
            } else if hasPinnedItems1 && hasPinnedItems2 {
                let pinnedDates1 = group1.value.compactMap { $0.pin?.dateFromString() }.sorted()
                let pinnedDates2 = group2.value.compactMap { $0.pin?.dateFromString() }.sorted()
                return pinnedDates1.first ?? Date() < pinnedDates2.first ?? Date()
            }
            
            return false
        }
        
        // Step 4: Sort the data alphabetically by tag and move pinned items to the top
        sortedGroupedData.sort(by: compareTagGroups)
        
        // Step 3: Sort the data within each tag group by pin date in descending order
        for (tag, _) in sortedGroupedData {
            if let index = sortedGroupedData.firstIndex(where: { $0.key == tag }) {
                let groupData = groupedData[tag] ?? []
                let pinnedItems = groupData.filter { $0.pin != nil }
                let unpinnedItems = groupData.filter { $0.pin == nil }
                
                let sortedPinnedItems = pinnedItems.sorted(by: {
                    ($0.pin?.dateFromString() ?? Date()) > ($1.pin?.dateFromString() ?? Date())
                })
                
                sortedGroupedData[index].value = sortedPinnedItems + unpinnedItems
            }
        }
        
        // Step 5: Convert to the final format and return
        let result = sortedGroupedData.map { (tag: $0.key, data: $0.value) }
        return result
    }
    
    

    
    
}


// MARK: - Handle Image Picker Controller
extension QCFormVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func setImageBy(source:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let cell = formTypeNoteTableview.cellForRow(at: selectedCellIndexPath) as? FormTypeNoteCell{
            
            if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                cell.selectedImageView.image = editingImage
            }else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                cell.selectedImageView.image = orginalImage
            }
        }else if let cell = formTypeNoteTableview.cellForRow(at: selectedCellIndexPath) as? UserFormItemTableViewCell{
            if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                cell.selectedImageView.image = editingImage
            }else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                cell.selectedImageView.image = orginalImage
            }
        }else if let cell = formTypeNoteTableview.cellForRow(at: selectedCellIndexPath) as? CustomFormItemTableViewCell{
            if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                cell.selectedImageView.image = editingImage
            }else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                cell.selectedImageView.image = orginalImage
            }
        }
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        formsItem[selectedCellIndexPath.section].data[selectedCellIndexPath.row].image = imageURL?.absoluteString ?? ""
        dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
}

enum FormPurpose{
    case edit,create,draft,updateDraft
}

extension String {
    func dateFromString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
}



