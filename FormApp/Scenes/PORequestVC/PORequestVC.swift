//
//  PORequestVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 20/04/2023.
//

import UIKit
import SVProgressHUD
class PORequestVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var companyView: UIViewDesignable!
    @IBOutlet weak var jobView: UIViewDesignable!
    @IBOutlet weak var costCodeView: UIViewDesignable!
    @IBOutlet weak var divisionLeaderView: UIViewDesignable!
    
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var jobButton: UIButton!
    @IBOutlet weak var costCodeButton: UIButton!
    @IBOutlet weak var divisionleaderButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var costCodeTextField: UITextField!
    @IBOutlet weak var divisionLeaderTextField: UITextField!
    
    private var companies = [DataDetails]()
    private var jobs = [DataDetails]()
    private var divisions = [DataDetails]()
    private var costCodes = [DataDetails]()
    
    private var companyPickerVC: PickerVC?
    private var jobPickerVC: PickerVC?
    private var costCodePickerVC: PickerVC?
    private var divitionPickerVC: PickerVC?
    
    private var companySearchText = ""
    private var jobSearchText = ""
    private var divitionSearchText = ""
    private var selectedJobProject = ""
    
    private var companyID = -1
    private var jobID = -1
    private var divisionID = -1
    private var presenter = PORequestPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        setDefaultFieldsStatus()
        presenter.delegate = self
        presenter.getCompaniesFromDB(search: "")
        
    }
    
    private func setDefaultFieldsStatus(){
        jobView.backgroundColor = .systemGray5
        costCodeView.backgroundColor = .systemGray5
        divisionLeaderView.backgroundColor = .systemGray5
    }
    
    
    @IBAction func backActtion(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
// MARK: - Binding
extension PORequestVC{
    private func binding(){
        backButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        companyButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        jobButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        costCodeButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        divisionleaderButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
    
    @objc private func ButtonWasTapped(btn:UIButton){
        switch btn{
        case backButton:
            navigationController?.popViewController(animated: true)
        case companyButton:
            companyAction()
            break
        case jobButton:
            jobAction()
        case costCodeButton:
            break
        case divisionleaderButton:
            divisionLeaderAction()
        case submitButton:
            break
        default:
            print("")
        }
    }

    private func companyAction(){
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
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.companyTextField.text = self.companies[index].title ?? ""
            self.companyID = self.companies[index].id ?? 0
            
            self.jobs = []
            self.costCodes = []
            self.divisions = []
            
            self.jobTextField.text=""
            self.divisionLeaderTextField.text = ""
            
            self.presenter.getJobsFromDB(companyID: "\(self.companyID)", search: "")
            self.presenter.getDivisionFromDB(companyID: "\(self.companyID)", search: "")
        }
        self.present(companyPickerVC!, animated: true, completion: nil)
    }
    
    private func jobAction(){
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
            self.jobTextField.text = self.jobs[index].title ?? ""
            self.jobID = self.jobs[index].id ?? 0
            self.selectedJobProject = self.jobs[index].project ?? ""
            
        }
        self.present(jobPickerVC!, animated: true, completion: nil)
    }
    
    private func divisionLeaderAction(){
        divitionPickerVC = PickerVC.instantiate()
        divitionPickerVC!.arr_data = divisions.map{$0.title ?? ""}
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
            print("Selected Value:",name)
            print("Selected Index:",index)
            self.divisionLeaderTextField.text = self.divisions[index].title ?? ""
            self.divisionID = self.divisions[index].id ?? 0

        }
        self.present(divitionPickerVC!, animated: true, completion: nil)
    }
    
    
}


extension PORequestVC:PORequestPresenterDelegate{
    func clearFields() {
        jobView.backgroundColor = .systemGray5
        costCodeView.backgroundColor = .systemGray5
        divisionLeaderView.backgroundColor = .systemGray5
        
        jobButton.isEnabled = false
        costCodeButton.isEnabled = false
        divisionleaderButton.isEnabled = false
        
        companyTextField.text = ""
        jobTextField.text = ""
        costCodeTextField.text = ""
        divisionLeaderTextField.text = ""
    }
    
    func getCompanyData(data: CompaniesData) {
        companies = data.companies
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
        jobs = data.jobs
        jobButton.isEnabled = true
        self.jobView.backgroundColor = .clear
        if let jobPickerVC = self.jobPickerVC{
            jobPickerVC.arr_data = jobs.map{$0.title ?? ""}
            jobPickerVC.picker.reloadAllComponents()
            if !jobPickerVC.arr_data.isEmpty{
                jobPickerVC.index = 0
            }
        }
    }
    
    func getDivition(data: DiviosnData) {
        divisions = data.divisions
        divisionleaderButton.isEnabled=true
        divisionLeaderView.backgroundColor = .clear
        SVProgressHUD.dismiss()

        if let divitionPickerVC = self.divitionPickerVC{
            divitionPickerVC.arr_data = divisions.map{$0.title ?? ""}
            divitionPickerVC.picker.reloadAllComponents()
            if !divitionPickerVC.arr_data.isEmpty{
                divitionPickerVC.index = 0
            }
        }
    }
    
    
}




extension PORequestVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
