//
//  QCFormVC.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit
import SVProgressHUD

class QCFormVC: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet weak var formTypeNoteTableview: UITableView!
    
    @IBOutlet weak var jobView: UIViewDesignable!
    
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
    
    private let presenter = AppPresenter()
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
    private var searchText = ""
    private var jobPickerVC: PickerVC?
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
        presenter.getCompaniesFromDB()
        presenter.getDivisionFromDB()
        presenter.getFormsFromDB()
        setupTableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let editData = editData{
            companyID = editData.company?.id ?? 0
            companyBtn.isEnabled = true
            companiesData.text = editData.company?.title ?? ""
            
            jobID = editData.job?.id ?? 0
            jobBtn.isEnabled = true
            jobData.text = editData.job?.title ?? ""
            jobView.backgroundColor = .black
            
            formTypeID = editData.form?.id ?? 0
            formTypeBtn.isEnabled = true
            formTypeData.text = editData.form?.title ?? ""
            
            divisionID = editData.division?.id ?? 0
            divisionBtn.isEnabled = true
            diviosnLeaderData.text = editData.division?.title ?? ""
            
            for item in editData.items ?? []{
                formsItem.append(.init(id: Int(item.item_id ?? "-1")!, title: item.item?.title ?? "", status: item.value ?? "", note: item.notes ?? "",system: item.item?.system,reasons: item.item?.fail_reasons,reason_id: item.fail_reason?.id,reason: item.fail_reason?.title))
                formTypeNoteTableview.reloadData()
            }
        }
    }
    
    
    func BtnStatus(){
        formTypeBtn.isEnabled=false
        companyBtn.isEnabled=false
        jobBtn.isEnabled=false
        divisionBtn.isEnabled=false
        
        jobView.backgroundColor = .systemGray5
        
        diviosnLeaderData.isEnabled=false
        jobData.isEnabled=false
        companiesData.isEnabled=false
        formTypeData.isEnabled=false
        
    }
    
    func setupTableview(){
        formTypeNoteTableview.register(FormTypeNoteCell.self)
        formTypeNoteTableview.delegate=self
        formTypeNoteTableview.dataSource = self
    }
    
    
    @IBAction func companyAction(_ sender: Any) {
        let vc = PickerVC.instantiate()
        vc.arr_data = companies.map{$0.title ?? ""}
        
        vc.searchBarHiddenStatus = true
        
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.companiesData.text = name
            self.companyID = self.companies[index].id ?? 0
            
            self.jobView.backgroundColor = .black
            
            self.jobs = []
            self.jobData.text=""
            self.presenter.getJobsFromDB(companyID: "\(self.companyID)", search: "")
            
            self.presenter.getFormItemFromDB(project: self.selectedJobProject,
                                             companyID:self.companyID,
                                             formTypeID:"\(self.formTypeID)" )
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func jobAction(_ sender: Any) {
        jobPickerVC = PickerVC.instantiate()
        jobPickerVC!.searchText = searchText
        jobPickerVC!.arr_data = jobs.map{$0.title ?? ""}
        jobPickerVC!.companyId = self.companyID
        jobPickerVC!.searchAction = { searchText in
            self.searchText = searchText
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
                                             companyID:self.companyID,
                                             formTypeID:"\(self.formTypeID)" )
        }
        self.present(jobPickerVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func divisionLeaderAction(_ sender: Any) {
        let vc = PickerVC.instantiate()
        vc.arr_data = division.map{$0.title ?? ""}
        vc.searchBarHiddenStatus = true
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.diviosnLeaderData.text = name
            self.divisionID = self.division[index].id ?? 0
            
            
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func FormTypeAction(_ sender: Any) {
        let vc = PickerVC.instantiate()
        vc.arr_data = forms.map{$0.title ?? ""}
        vc.searchBarHiddenStatus = true
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            // Selection Action Here
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.formTypeData.text = name
            self.formTypeID = self.forms[index].id ?? 0
            self.presenter.getFormItemFromDB(project: self.selectedJobProject,
                                             companyID:self.companyID,
                                             formTypeID:"\(self.formTypeID)" )
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
}
extension QCFormVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        submitBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
    
    @objc func AddFormItemNote( _ sender:UITextField){
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        formsItem[indexPath.row].note = sender.text ?? ""
        
    }
    
    
    @objc func AddFormItemStatus( _ sender:UITextField){
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        formsItem[indexPath.row].status = sender.text ?? ""
    }
    
}

extension QCFormVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
            
        case submitBtn:
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
            
        case backBtn :
            navigationController?.popViewController(animated: true)
            
        default:
            print("")
        }
        
    }
    
    
    private func isAllFormItemsSelected() -> Bool{
        for item in formsItem{
            let chechResult = item.status == nil
            if chechResult{
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

extension QCFormVC:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formsItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FormTypeNoteCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(obj: formsItem[indexPath.row])
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.formTitleNote.addTarget(self, action: #selector(AddFormItemNote), for: .editingDidEnd)
        cell.formTitleNote.tag=indexPath.row
        
        cell.formTypeStatus.addTarget(self, action: #selector(AddFormItemStatus), for: .editingDidEnd)
        cell.formTypeStatus.tag=indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
}

// MARK: - Table View Cell Delegate
extension QCFormVC:FormTypeNoteCellDelegate{
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
    
}

extension QCFormVC:FormDelegate{
    
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
    
    func getUserData(user: User) {}
    
    func getCompanyData(data: CompaniesData) {
        companies.removeAll()
        companies=data.companies
        companyBtn.isEnabled=true
        SVProgressHUD.dismiss()
    }
    
    func getJobData(data: JobData) {
        jobs.removeAll()
        jobs=data.jobs
        jobBtn.isEnabled=true
        if let jobPickerVC = self.jobPickerVC{
            jobPickerVC.arr_data = jobs.map{$0.title ?? ""}
            jobPickerVC.picker.reloadAllComponents()
            if !jobPickerVC.arr_data.isEmpty{
                jobPickerVC.index = 0
            }
        }
    }
    
    func getFormsData(data: FormsData) {
        forms.removeAll()
        forms=data.forms
        formTypeBtn.isEnabled=true
        SVProgressHUD.dismiss()
        
    }
    
    func getDivition(data: DiviosnData) {
        division.removeAll()
        division=data.divisions
        divisionBtn.isEnabled=true
        SVProgressHUD.dismiss()
        
    }
    
    func getFormItemsData(data: FormItemData) {
        formsItem.removeAll()
        formsItem = data.formItems
        formTypeNoteTableview.reloadData()
        
    }
    
    
}

extension QCFormVC{
    func submitForm(formsDetails:[String:Any]){
        presenter.submitFormData(isEdit:editData != nil ,isFormNewOnline: false,formsDetails: formsDetails)
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
            
            formData["form_items[\(index)][item_id]"] = formsItem[index].id ?? 0
            
            let status = formsItem[index].status ?? ""
            formData["form_items[\(index)][value]"] = status == "N/A" ? "" : status.lowercased()
            
            formData["form_items[\(index)][notes]"] = formsItem[index].note ?? ""
            formData["form_items[\(index)][fail_reason_id]"] = formsItem[index].reason_id
        }
        
        return formData
    }
    
}




