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
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var addNewFormItemButton: UIButton!
    @IBOutlet weak var addNewFormItemView: UIView!
    @IBOutlet weak var formTypeNoteTableview: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var companyView: UIViewDesignable!
    @IBOutlet weak var jobView: UIViewDesignable!
    @IBOutlet weak var divisionView: UIViewDesignable!
    @IBOutlet weak var formTypeView: UIViewDesignable!
    
    @IBOutlet weak var companyBtn: UIButton!
    @IBOutlet weak var jobBtn: UIButton!
    @IBOutlet weak var divisionBtn: UIButton!
    @IBOutlet weak var formTypeBtn: UIButton!
    
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
    
    private var companyID=0
    private var formTypeID=0
    private var jobID=0
    private var divisionID=0
    
    private var selectedIndex = -1
    
    private var formData:[String : Any] = [:]
    private var requestSubmitted:Bool = false
    private var companySearchText = ""
    private var jobSearchText = ""
    private var divitionSearchText = ""
    private var formTypeSearchText = ""
    private var companyPickerVC: PickerVC?
    private var jobPickerVC: PickerVC?
    private var divitionPickerVC: PickerVC?
    private var formTypePickerVC: PickerVC?
    private var selectedJobProject = ""
    var editData: FormInfo?
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BindButtons()
        BtnStatus()
        
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.show(withStatus: "please wait")
        
        presenter.delegate=self
        presenter.getCompaniesFromDB(search: "")
        setupTableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkEditData()
    }
    
    private func checkEditData(){
        if let editData = editData{
            headerTitleLabel.text = editData.form?.title ?? ""
            addNewFormItemView.isHidden = false
            companyID = editData.company?.id ?? 0
            companyBtn.isEnabled = true
            companyView.backgroundColor = .black
            companiesData.text = editData.company?.title ?? ""
            
            jobID = editData.job?.id ?? 0
            jobBtn.isEnabled = true
            jobView.backgroundColor = .black
            jobData.text = editData.job?.title ?? ""
            jobView.backgroundColor = .black
            
            formTypeID = editData.form?.id ?? 0
            formTypeBtn.isEnabled = true
            formTypeView.backgroundColor = .black
            formTypeData.text = editData.form?.title ?? ""
            
            divisionID = editData.division?.id ?? 0
            divisionBtn.isEnabled = true
            divisionView.backgroundColor = .black
            diviosnLeaderData.text = editData.division?.title ?? ""
            
            for item in editData.items ?? []{
                if item.id == nil{
                    let name = item.name ?? ""
                    let status = item.value ?? ""
                    let new_item_type = item.new_item_type ?? .text
                    let isFromUser = true
                    let isWithPrice = item.withPrice == "1"
                    let price = item.price
                    
                    formsItem.append(.init(name: name , status: status ,new_item_type: new_item_type,isFromUser: isFromUser ,isWithPrice: isWithPrice ,price: price))
                    
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
                    formsItem.append(.init(id: id,value: value,title: title, status: status,price: price,show_price: show_price,system: system, system_type: system_type, system_list: system_list))
                    
                }else{
                    var newBoxs = [NewBoxData]()
                    for box in item.new_boxes ?? []{
                        newBoxs.append(.init(title:box.title,box_type: box.type,value: box.value))
                    }
                    let id = Int(item.item_id ?? "-1")!
                    let title = item.item?.title ?? ""
                    let status = item.value ?? ""
                    let note = item.notes ?? ""
                    let system = item.item?.system
                    let reasons = item.item?.fail_reasons
                    let reason_id = item.fail_reason?.id
                    let reason = item.fail_reason?.title
                    formsItem.append(.init(id: id, title: title, status: status, note: note,system: system,reasons: reasons,reason_id: reason_id,reason: reason,new_boxes: newBoxs))
                }
            }
            formTypeNoteTableview.reloadData()
        }
    }
    
    func BtnStatus(){
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
    
    
    
    
    
    @IBAction func companyAction(_ sender: Any) {
        companyPickerVC = PickerVC.instantiate()
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
        }
        self.present(companyPickerVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func jobAction(_ sender: Any) {
        jobPickerVC = PickerVC.instantiate()
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
        }
        self.present(jobPickerVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func divisionLeaderAction(_ sender: Any) {
        divitionPickerVC = PickerVC.instantiate()
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
        }
        self.present(divitionPickerVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func FormTypeAction(_ sender: Any) {
        formTypePickerVC = PickerVC.instantiate()
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
            self.presenter.getFormItemFromDB(project: self.selectedJobProject,
                                             formTypeID:"\(self.formTypeID)" )
        }
        self.present(formTypePickerVC!, animated: true, completion: nil)
        
    }
    
    
}
extension QCFormVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        submitBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        addNewFormItemButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
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
}

extension QCFormVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case submitBtn:
            submitAction()
        case backBtn :
            navigationController?.popViewController(animated: true)
        case addNewFormItemButton:
            let vc = CreateFormItemVC.instantiate()
            vc.modalPresentationStyle = .overCurrentContext
            vc.addAction = { type , isWithPrice in
                self.formsItem.append(.init(name: "", status: "", new_item_type: type,isFromUser: true, isWithPrice: isWithPrice,price: "0"))
                self.formTypeNoteTableview.insertRows(at: [IndexPath.init(row: self.formsItem.count - 1, section: 0)], with: .automatic)
            }
            present(vc, animated: true)
        default:
            print("")
        }
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
                        self.submitForm(formsDetails: self.formDetailsParameter())
                    }else{
                        Alert.showErrorAlert(message:  "Add your form Item Data,You have at least to choose status for every item" )
                    }
                }
            }
            
        }catch{
            Alert.showErrorAlert(message: (error as! ValidationError).message)
        }
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
}

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
        var totalHeight:CGFloat = 0.0
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
            cell.setData(data: formsItem[indexPath.row],index: indexPath.row)
            
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
            cell.setData(data: formsItem[indexPath.row],index: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    private func getFormTypeCellHeight(index:Int) -> CGFloat{
        var height:CGFloat = 0
        let formItem = formsItem[index]
        if formItem.isFromUser ?? false{
            height += 280
        }else if formItem.system_type != nil{
            height += 160
        }else{
            height = 160
            if formItem.show_price == "1"{
                height += 30
            }
            if formItem.status == "fail"{
                height += 35
            }
            height += CGFloat(formItem.new_boxes?.count ?? 0 ) * 90
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
                    if item.show_price == "1" || item.isFromUser ?? false{
                        price += (quantity) * (Double(item.price ?? "0.0") ?? 0.0)
                    }
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


// MARK: - Table View Cell Delegate
extension QCFormVC:FormTypeNoteCellDelegate,UserFormItemDelegate,CustomFormItemDelegate{
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
    
    
    func reasonPickerAction(reasons:[FailReasonData],indexPath: IndexPath) {
        let vc = PickerVC.instantiate()
        vc.arr_data = reasons.map{$0.title ?? "----"}
        vc.searchBarHiddenStatus = true
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            self.formsItem[indexPath.row].reason = name
            self.formsItem[indexPath.row].reason_id = reasons[index].id
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
}

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
                companyPickerVC.index = 0
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
                jobPickerVC.index = 0
            }
        }
    }
    
    func getFormsData(data: FormsData) {
        forms=data.forms
        formTypeBtn.isEnabled=true
        self.formTypeView.backgroundColor = .black
        SVProgressHUD.dismiss()
        
        if let formTypePickerVC = self.formTypePickerVC{
            formTypePickerVC.arr_data = forms.map{$0.title ?? ""}
            formTypePickerVC.picker.reloadAllComponents()
            if !formTypePickerVC.arr_data.isEmpty{
                formTypePickerVC.index = 0
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
                divitionPickerVC.index = 0
            }
        }
    }
    
    func getFormItemsData(data: FormItemData) {
        formsItem = data.formItems
        formTypeNoteTableview.reloadData()
        addNewFormItemView.isHidden = false
    }
    
    
}

extension QCFormVC{
    func submitForm(formsDetails:[String:Any]){
        presenter.submitFormData(isEdit:editData != nil ,formsDetails: formsDetails)
    }
    
    func formDetailsParameter() -> [String:Any]{
        
        formData["company_id"] = "\(companyID)"
        formData["job_id"] = "\(jobID)"
        formData["division_id"] = "\(divisionID)"
        formData["form_type_id"] = "\(formTypeID)"
        
        if editData != nil{
            formData["submitted_form_id"] = editData!.id ?? -1
        }
        
        for index in 0 ..< formsItem.count{
            if formsItem[index].isFromUser ?? false{
                formData["new_items[\(index)][name]"] = formsItem[index].name ?? ""
                formData["new_items[\(index)][value]"] = formsItem[index].status ?? ""
                formData["new_items[\(index)][new_item_type]"] = (formsItem[index].new_item_type ?? .text).rawValue
                formData["new_items[\(index)][withPrice]"] = (formsItem[index].isWithPrice ?? false) ? "1" : "0"
                formData["new_items[\(index)][price]"] = formsItem[index].price ?? ""
            }else{
                formData["form_items[\(index)][item_id]"] = formsItem[index].id ?? 0
                let status = formsItem[index].status ?? ""
                formData["form_items[\(index)][value]"] = status == "N/A" ? "" : status.lowercased()
                formData["form_items[\(index)][notes]"] = formsItem[index].note ?? ""
                formData["form_items[\(index)][fail_reason_id]"] = formsItem[index].reason_id
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
    
}



