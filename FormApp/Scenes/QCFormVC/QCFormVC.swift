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
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var headerTitleLabel: UILabel!
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
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    //MARK: - Properties
    
    private let presenter = QCFormPresenter()
    private var companies:[DataDetails]=[]
    private var jobs:[DataDetails]=[]
    private var searchedJobs:[DataDetails]=[]
    private var division:[DataDetails]=[]
    private var forms:[DataDetails]=[]
    private var formsItem:[DataDetails]=[]
    private var subContractors:[SubContractor]=[]
    
    private var companyID=0
    private var formTypeID=0
    private var jobID=0
    private var divisionID=0
    private var subContractorID=0
    
    private var selectedCompanyIndex=0
    private var selectedFormTypeIndex=0
    private var selectedJobIndex=0
    private var selectedDivisionIndex=0
    private var selectedSubContractorIndex=0
    
    private var formData:[String : Any] = [:]
    private var requestSubmitted:Bool = false
    private var companySearchText = ""
    private var jobSearchText = ""
    private var divitionSearchText = ""
    private var formTypeSearchText = ""
    private var subContractorSearchText = ""
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
        
        setupTableview()
        binding()
        btnStatus()
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.show(withStatus: "please wait")
        presenter.delegate=self
        presenter.getCompaniesFromDB(search: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkEditData()
    }
    
    // MARK: - Private Functions
    
    private func checkEditData(){
        if let editData = editData{
            saveButton.isHidden = true
            setFormData(fromData: editData)
        }else if let draftData = draftData{
            saveButton.isHidden = false
            setFormData(fromData: draftData)
        }
    }
    
    private func setFormData(fromData:FormInfo){
        
        headerTitleLabel.text = fromData.form?.title ?? ""
        addNewFormItemView.isHidden = false
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
            if item.id == nil{
                let name = item.name ?? ""
                let status = item.value ?? ""
                let new_item_type = item.new_item_type ?? .text
                let isFromUser = true
                let isWithPrice = item.withPrice == "1"
                let price = item.price
                let image = item.image
                formsItem.append(.init(name: name , status: status ,new_item_type: new_item_type,isFromUser: isFromUser ,isWithPrice: isWithPrice ,price: price,image: image,isWithPic: image != nil))
                
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
                
                formsItem.append(.init(id: id,value: value,title: title, status: status,price: price,show_price: show_price,system: system, system_type: system_type, system_list: system_list,image: image,isWithPic: image != nil))
                
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
                formsItem.append(.init(id: id, title: title, status: status, note: note,system: system,reasons: reasons,reason_id: reason_id,reason: reason,new_boxes: newBoxs,image: image,isWithPic: image != nil,price: price,show_price: show_price))
            }
        }
        self.companyID = Int(fromData.company_id ?? "-1")!
        self.presenter.getJobsFromDB(companyID: "\(self.companyID)", search: "")
        self.presenter.getDivisionFromDB(companyID: "\(self.companyID)", search: "")
        self.presenter.getFormsFromDB(companyID: "\(self.companyID)", search: "")
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
    
    private func companyAction() {
        companyPickerVC = PickerVC.instantiate()
        companyPickerVC!.index = selectedCompanyIndex
        companyPickerVC!.arr_data = companies.map{$0.title ?? ""}
        companyPickerVC!.searchText = companySearchText
        companyPickerVC!.searchBarHiddenStatus = false
        companyPickerVC!.searchAction = { searchText in
            self.companySearchText = searchText
            self.presenter.getCompaniesFromDB(search: searchText)
        }
        companyPickerVC!.isModalInPresentation = true
        companyPickerVC!.modalPresentationStyle = .overFullScreen
        companyPickerVC!.definesPresentationContext = true
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
            self.selectedCompanyIndex = index
            self.addNewFormItemView.isHidden = !self.checkAllFieldsSelected()
        }
        self.present(companyPickerVC!, animated: true, completion: nil)
    }
    
    
    private func jobAction() {
        jobPickerVC = PickerVC.instantiate()
        jobPickerVC!.index = selectedJobIndex
        jobPickerVC!.searchText = jobSearchText
        jobPickerVC!.arr_data = jobs.map{$0.title ?? ""}
        jobPickerVC!.searchAction = { searchText in
            self.jobSearchText = searchText
            self.presenter.getJobsFromDB(companyID: String(self.companyID), search: searchText)
        }
        jobPickerVC!.searchBarHiddenStatus = false
        jobPickerVC!.isModalInPresentation = true
        jobPickerVC!.modalPresentationStyle = .overFullScreen
        jobPickerVC!.definesPresentationContext = true
        jobPickerVC!.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.jobData.text = self.jobs[index].title ?? ""
            self.jobID = self.jobs[index].id ?? 0
            self.selectedJobProject = self.jobs[index].project ?? ""
            
            self.presenter.getFormItemFromDB(project: self.selectedJobProject,
                                             formTypeID:"\(self.formTypeID)" )
            self.selectedJobIndex = index
            self.addNewFormItemView.isHidden = !self.checkAllFieldsSelected()
        }
        self.present(jobPickerVC!, animated: true, completion: nil)
    }
    
    
    private func divisionLeaderAction() {
        divitionPickerVC = PickerVC.instantiate()
        divitionPickerVC!.index = selectedDivisionIndex
        divitionPickerVC!.arr_data = division.map{$0.title ?? ""}
        divitionPickerVC!.searchText = divitionSearchText
        divitionPickerVC!.searchBarHiddenStatus = false
        divitionPickerVC!.searchAction = { searchText in
            self.divitionSearchText = searchText
            self.presenter.getDivisionFromDB(companyID: String(self.companyID), search: searchText)
        }
        divitionPickerVC!.isModalInPresentation = true
        divitionPickerVC!.modalPresentationStyle = .overFullScreen
        divitionPickerVC!.definesPresentationContext = true
        divitionPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.diviosnLeaderData.text = self.division[index].title ?? ""
            self.divisionID = self.division[index].id ?? 0
            self.selectedDivisionIndex = index
            self.addNewFormItemView.isHidden = !self.checkAllFieldsSelected()
        }
        self.present(divitionPickerVC!, animated: true, completion: nil)
    }
    
    
    private func FormTypeAction() {
        formTypePickerVC = PickerVC.instantiate()
        formTypePickerVC!.index = selectedFormTypeIndex
        formTypePickerVC!.arr_data = forms.map{$0.title ?? ""}
        formTypePickerVC!.searchText = formTypeSearchText
        formTypePickerVC!.searchBarHiddenStatus = false
        formTypePickerVC!.searchAction = { searchText in
            self.formTypeSearchText = searchText
            self.presenter.getFormsFromDB(companyID: String(self.companyID), search: searchText)
        }
        formTypePickerVC!.isModalInPresentation = true
        formTypePickerVC!.modalPresentationStyle = .overFullScreen
        formTypePickerVC!.definesPresentationContext = true
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
            self.selectedFormTypeIndex = index
            self.addNewFormItemView.isHidden = !self.checkAllFieldsSelected()
        }
        self.present(formTypePickerVC!, animated: true, completion: nil)
    }
    
    
    private func subContractorAction() {
        subContractorPickerVC = PickerVC.instantiate()
        subContractorPickerVC!.index = selectedSubContractorIndex
        subContractorPickerVC!.arr_data = subContractors.map{$0.name ?? ""}
        subContractorPickerVC!.searchText = subContractorSearchText
        subContractorPickerVC!.searchBarHiddenStatus = false
        subContractorPickerVC!.searchAction = { searchText in
            self.subContractorSearchText = searchText
            self.presenter.getSubContractorsDBModel(search: searchText)
        }
        subContractorPickerVC!.isModalInPresentation = true
        subContractorPickerVC!.modalPresentationStyle = .overFullScreen
        subContractorPickerVC!.definesPresentationContext = true
        subContractorPickerVC!.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.subContractorTextField.text = self.subContractors[index].name ?? ""
            self.subContractorID = self.subContractors[index].id ?? 0
            self.selectedSubContractorIndex = index
        }
        self.present(subContractorPickerVC!, animated: true, completion: nil)
    }
    
    private func saveAction(){
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
        
        for index in 0 ..< formsItem.count{
            if formsItem[index].isFromUser ?? false{
                formData["new_items[\(index)][name]"] = formsItem[index].name ?? ""
                formData["new_items[\(index)][value]"] = formsItem[index].status ?? ""
                formData["new_items[\(index)][new_item_type]"] = (formsItem[index].new_item_type ?? .text).rawValue
                formData["new_items[\(index)][withPrice]"] = (formsItem[index].isWithPrice ?? false) ? "1" : "0"
                formData["new_items[\(index)][price]"] = formsItem[index].price ?? ""
                if formsItem[index].isWithPic ?? false{
                    formData["new_items[\(index)][image]"] = formsItem[index].image ?? ""
                }
            }else{
                formData["form_items[\(index)][item_id]"] = String(formsItem[index].id ?? 0)
                let status = formsItem[index].status ?? ""
                formData["form_items[\(index)][value]"] = status == "N/A" ? "" : status.lowercased()
                formData["form_items[\(index)][notes]"] = formsItem[index].note ?? ""
                formData["form_items[\(index)][fail_reason_id]"] = String(formsItem[index].reason_id ?? -1)
                if formsItem[index].isWithPic ?? false{
                    formData["form_items[\(index)][image]"] = formsItem[index].image ?? ""
                }
                for i in 0..<(formsItem[index].new_boxes ?? []).count{
                    let box = formsItem[index].new_boxes![i]
                    formData["form_items[\(index)][new_boxes][\(i)][title]"] = box.title ?? ""
                    formData["form_items[\(index)][new_boxes][\(i)][type]"] = box.box_type ?? ""
                    formData["form_items[\(index)][new_boxes][\(i)][value]"] = box.value ?? ""
                }
            }
        }
        
        return formData
    }
    
    private func isAllFormItemsSelected() -> Bool{
        for item in formsItem{
            let chechResult = item.status == nil
            if chechResult && !(item.isFromUser ?? false) && item.system_type == nil{
                return false
            }
        }
        return true
    }
    
    private func checkIfThereFieldItems()-> Bool{
        return formsItem.contains(where: {$0.status == "fail"})
    }
    
    private func checkAllFieldsSelected() ->Bool{
        return !companiesData.text!.isEmpty &&
        !jobData.text!.isEmpty &&
        !diviosnLeaderData.text!.isEmpty &&
        !formTypeData.text!.isEmpty
    }
    
}

//MARK: - Binding
extension QCFormVC{
    
    private func binding(){
        submitBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        addNewFormItemButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        companyBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        jobBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        divisionBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        formTypeBtn.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        subContractorButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        
    }
    
    @objc func AddFormItemNote( _ sender:UITextField){
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        formsItem[indexPath.row].note = sender.text ?? ""
    }
    
    @objc func AddFormItemStatus( _ sender:UITextField){
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        formsItem[indexPath.row].status = sender.text ?? ""
        if formsItem[indexPath.row].new_item_type == .quantity ||
            formsItem[indexPath.row].system == "quantity" ||
            formsItem[indexPath.row].new_item_type == .price ||
            formsItem[indexPath.row].system == "currency" {
            updateTotalView()
        }
    }
    
    @objc func AddFormItemName( _ sender:UITextField){
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        formsItem[indexPath.row].name = sender.text ?? ""
    }
    
    @objc func AddFormItemPrice( _ sender:UITextField){
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        formsItem[indexPath.row].price = sender.text ?? ""
        updateTotalView()
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case saveButton:
            saveAction()
        case submitBtn:
            submitAction()
        case backBtn :
            navigationController?.popViewController(animated: true)
        case addNewFormItemButton:
            let vc = CreateFormItemVC.instantiate()
            vc.modalPresentationStyle = .overCurrentContext
            vc.addAction = { type , isWithPrice in
                self.formsItem.append(.init(name: "", status: "", new_item_type: type,isFromUser: true, isWithPrice: isWithPrice,price: "0",image: "",isWithPic: false))
                self.formTypeNoteTableview.insertRows(at: [IndexPath.init(row: self.formsItem.count - 1, section: 0)], with: .automatic)
            }
            present(vc, animated: true)
        case companyBtn:
            companyAction()
        case jobBtn:
            jobAction()
        case divisionBtn:
            divisionLeaderAction()
        case formTypeBtn:
            FormTypeAction()
        case subContractorButton:
            subContractorAction()
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
        formTypeNoteTableview.delegate=self
        formTypeNoteTableview.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTotalView()
        var totalHeight:CGFloat = 47
        for i in 0..<formsItem.count{
            totalHeight += getFormTypeCellHeight(index: i)
        }
        tableViewHeight.constant = totalHeight
        return formsItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if formsItem[indexPath.row].isFromUser ?? false{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserFormItemTableViewCell", for: indexPath) as! UserFormItemTableViewCell
            cell.delegate = self
            cell.setData(data: formsItem[indexPath.row],indexPath: indexPath)
            
            let type = formsItem[indexPath.row].new_item_type
            if  type != .pass_fail && type != .yes_no && type != .date{
                cell.valueTextField.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
                cell.valueTextField.tag=indexPath.row
            }
            
            cell.priceTextField.addTarget(self, action: #selector(AddFormItemPrice), for: .editingDidEnd)
            cell.priceTextField.tag=indexPath.row
            
            cell.nameTextField.addTarget(self, action: #selector(AddFormItemName), for: .editingDidEnd)
            cell.nameTextField.tag=indexPath.row
            
            return cell
        }else if formsItem[indexPath.row].system_type != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomFormItemTableViewCell", for: indexPath) as! CustomFormItemTableViewCell
            cell.setData(data: formsItem[indexPath.row],indexPath: indexPath)
            cell.valueTextField.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
            cell.valueTextField.tag=indexPath.row
            cell.delegate = self
            return cell
        }
        
        let cell:FormTypeNoteCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(obj: formsItem[indexPath.row])
        cell.delegate = self
        cell.indexPath = indexPath
        cell.formTitleNote.addTarget(self, action: #selector(AddFormItemNote), for: .editingDidEnd)
        cell.formTitleNote.tag=indexPath.row
        
        cell.formTypeStatus.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
        cell.formTypeStatus.tag=indexPath.row
        
        cell.statusWithoutSelectionTextField.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
        cell.statusWithoutSelectionTextField.tag=indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getFormTypeCellHeight(index: indexPath.row)
    }
    
    private func getFormTypeCellHeight(index:Int) -> CGFloat{
        var height:CGFloat = 0
        let formItem = formsItem[index]
        if formItem.isFromUser ?? false{
            if formItem.isWithPrice ?? false{
                height += 340
            }else{
                height += 260
            }
            
        }else if formItem.system_type != nil{
            height += 190
        }else{
            height = 210
            if formItem.show_price == "1"{
                height += 40
            }
            if formItem.status == "fail"{
                height += 40
            }
            height += CGFloat(formItem.new_boxes?.count ?? 0 ) * 90
        }
        if formItem.isWithPic ?? false{
            height += 120
        }
        return height
    }
    
    private func updateTotalView(){
        totalView.isHidden = formsItem.isEmpty
        if !formsItem.isEmpty{
            var price = 0.0
            var qty = 0.0
            
            formsItem.forEach({ item in
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
            
            totalPriceLabel.text = String(price)
            totalQuantityLabel.text = String(qty)
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
            self.formsItem[indexPath.row].status = name
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
            self.formsItem[indexPath.row].reason = name
            self.formsItem[indexPath.row].reason_id = realmReasons[index].id
            self.formTypeNoteTableview.reloadRows(at: [indexPath], with: .automatic)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func datePickerAction(indexPath:IndexPath) {
        let vc = DatePickerVC.instantiate()
        vc.dateSelected = { selectedDate in
            self.formsItem[indexPath.row].status = selectedDate
            self.formTypeNoteTableview.reloadRows(at: [indexPath], with: .automatic)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func showPickerVC(type: String,parentIndex:Int,childIndex:Int) {
        if type == "Date" {
            let vc = DatePickerVC.instantiate()
            vc.modalPresentationStyle = .overFullScreen
            vc.dateSelected = { selectedDate in
                self.formsItem[parentIndex].new_boxes?[childIndex].value = selectedDate
                let parentCell = self.formTypeNoteTableview.cellForRow(at: IndexPath.init(row: parentIndex, section: 0)) as! FormTypeNoteCell
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
                self.formsItem[parentIndex].new_boxes?[childIndex].value = name
                let parentCell = self.formTypeNoteTableview.cellForRow(at: IndexPath.init(row: parentIndex, section: 0)) as! FormTypeNoteCell
                let childCell = parentCell.tableView.cellForRow(at: IndexPath.init(row: childIndex, section: 0)) as! NewBoxTableViewCell
                childCell.boxTextField.text = name
            }
            self.present(selectionPickerVC, animated: true, completion: nil)
        }
    }
    
    func updateNewBoxData(text: String, parentIndex: Int, childIndex: Int) {
        self.formsItem[parentIndex].new_boxes?[childIndex].value = text
    }
    
    func updatePicStatus(index:Int,withPic: Bool) {
        self.formsItem[index].isWithPic = withPic
        if !withPic{
            self.formsItem[index].image = nil
        }
        self.formTypeNoteTableview.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

// MARK: - Table View Cell (UserFormItemDelegate) Delegate
extension QCFormVC:UserFormItemDelegate{
    
    func selectionAction(type: NewFormItemType, Index: Int) {
        if type != .date{
            let selectionPickerVC = PickerVC.instantiate()
            selectionPickerVC.arr_data = type == .pass_fail ? ["Pass","Fail"] : ["Yes","No"]
            selectionPickerVC.searchBarHiddenStatus = true
            selectionPickerVC.isModalInPresentation = true
            selectionPickerVC.modalPresentationStyle = .overFullScreen
            selectionPickerVC.definesPresentationContext = true
            selectionPickerVC.delegate = { name , selectedIndex in
                // Selection Action Here
                self.formsItem[Index].status = name
                let cell = self.formTypeNoteTableview.cellForRow(at: IndexPath.init(row: Index, section: 0)) as! UserFormItemTableViewCell
                cell.valueTextField.text = name
            }
            self.present(selectionPickerVC, animated: true, completion: nil)
        }else{
            let vc = DatePickerVC.instantiate()
            vc.modalPresentationStyle = .overFullScreen
            vc.dateSelected = { selectedDate in
                self.formsItem[Index].status = selectedDate
                let cell = self.formTypeNoteTableview.cellForRow(at: IndexPath.init(row: Index, section: 0)) as! UserFormItemTableViewCell
                cell.valueTextField.text = selectedDate
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}


// MARK: - Table View Cell (CustomFormItemDelegate) Delegate
extension QCFormVC:CustomFormItemDelegate{
    
    func selectionAction(index: Int,arr:[String],isDate:Bool) {
        if isDate {
            let vc = DatePickerVC.instantiate()
            vc.modalPresentationStyle = .overFullScreen
            vc.dateSelected = { selectedDate in
                self.formsItem[index].status = selectedDate
                let cell = self.formTypeNoteTableview.cellForRow(at: IndexPath.init(row: index, section: 0)) as! CustomFormItemTableViewCell
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
                self.formsItem[index].status = name
                let cell = self.formTypeNoteTableview.cellForRow(at: IndexPath.init(row: index, section: 0)) as! CustomFormItemTableViewCell
                cell.valueTextField.text = name
            }
            self.present(selectionPickerVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: - Presenter Delegate
extension QCFormVC:QCFormPresenterDelegate{
    
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
        navigationController?.popViewController(animated: true)
    }
    
    func getCompanyData(data: CompaniesData) {
        companies=data.companies
        companyBtn.isEnabled=true
        self.companyView.backgroundColor = .black
        SVProgressHUD.dismiss()
        if let companyPickerVC = self.companyPickerVC{
            companyPickerVC.arr_data = companies.map{$0.title ?? ""}
            companyPickerVC.picker.reloadAllComponents()
            if !companyPickerVC.arr_data.isEmpty{
                companyPickerVC.index = selectedCompanyIndex
            }
        }
    }
    
    func getJobData(data: JobData) {
        jobs=data.jobs
        jobBtn.isEnabled=true
        self.jobView.backgroundColor = .black
        if let jobPickerVC = self.jobPickerVC{
            jobPickerVC.arr_data = jobs.map{$0.title ?? ""}
            jobPickerVC.picker.reloadAllComponents()
            if !jobPickerVC.arr_data.isEmpty{
                jobPickerVC.index = selectedJobIndex
            }
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
            formTypePickerVC.picker.reloadAllComponents()
            if !formTypePickerVC.arr_data.isEmpty{
                formTypePickerVC.index = selectedFormTypeIndex
            }
        }
    }
    
    func getDivition(data: DiviosnData) {
        division=data.divisions
        divisionBtn.isEnabled=true
        self.divisionView.backgroundColor = .black
        SVProgressHUD.dismiss()
        
        if let divitionPickerVC = self.divitionPickerVC{
            divitionPickerVC.arr_data = division.map{$0.title ?? ""}
            divitionPickerVC.picker.reloadAllComponents()
            if !divitionPickerVC.arr_data.isEmpty{
                divitionPickerVC.index = selectedDivisionIndex
            }
        }
    }
    
    func getFormItemsData(data: FormItemData) {
        formsItem = data.formItems
        formTypeNoteTableview.reloadData()
        addNewFormItemView.isHidden = !checkAllFieldsSelected()
    }
    
    func getSubContractors(data: SubContractorsResponse) {
        subContractors=data.subContractors ?? []
        SVProgressHUD.dismiss()
        
        if let subContractorPickerVC = self.subContractorPickerVC{
            subContractorPickerVC.arr_data = subContractors.map{$0.name ?? ""}
            subContractorPickerVC.picker.reloadAllComponents()
            if !subContractorPickerVC.arr_data.isEmpty{
                subContractorPickerVC.index = 0
            }
        }
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
        formsItem[selectedCellIndexPath.row].image = imageURL?.absoluteString ?? ""
        dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        SVProgressHUD.dismiss()
    }
}

enum FormPurpose{
    case edit,create,draft,updateDraft
}



