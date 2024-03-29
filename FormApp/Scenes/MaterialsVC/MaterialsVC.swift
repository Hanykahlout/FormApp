//
//  MaterialsVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 02/05/2023.
//

import UIKit

class MaterialsVC: UIViewController {
    
    
    
    @IBOutlet weak var companyTextField: UIPaddedTextField!
    @IBOutlet weak var companyView: UIViewDesignable!
    @IBOutlet weak var companyButton: UIButton!
    
    @IBOutlet weak var jobsTextField: UIPaddedTextField!
    @IBOutlet weak var jobsView: UIViewDesignable!
    @IBOutlet weak var jobsButton: UIButton!
    
    
    @IBOutlet weak var phaseTextField: UIPaddedTextField!
    @IBOutlet weak var phaseView: UIViewDesignable!
    @IBOutlet weak var phaseButton: UIButton!
    
    @IBOutlet weak var specialTextField: UIPaddedTextField!
    @IBOutlet weak var specialView: UIViewDesignable!
    @IBOutlet weak var specialButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataStackView: UIStackView!
    
    private var companyPickerVC: PickerVC?
    private var jobPickerVC: PickerVC?
    private var phasePickerVC: PickerVC?
    private var specialPickerVC: PickerVC?
    
    private var presenter: MaterialsPresetner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MaterialsPresetner()
        presenter.delegate = self
        setUpTableView()
        
        BindingAction()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        presenter.getMaterialsFromAPI()
        presenter.getPhaseSpecialFromAPI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // MARK: - Private Functions
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.title = "Materials"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.backgroundColor = .white
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
        let rightButton = UIButton()
        rightButton.corner_radius = 10
        rightButton.clipsToBounds = true
        rightButton.setImage(UIImage(systemName: "plus"), for: .normal)
        rightButton.tintColor = .white
        rightButton.backgroundColor = .orange
        rightButton.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        navigationItem.rightBarButtonItem = .init(customView: rightButton)
        
    }
}

// MARK: - SetUp TableView Delegate And DataSource
extension MaterialsVC:UITableViewDelegate,UITableViewDataSource{
    
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "MaterialTableViewCell", bundle: nil), forCellReuseIdentifier: "MaterialTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyDataStackView.isHidden = !presenter.getMaterials().isEmpty
        return presenter.getMaterials().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialTableViewCell", for: indexPath) as! MaterialTableViewCell
        cell.setData(data: presenter.getMaterials()[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MaterialsDetailsVC.instantiate()
        vc.material = presenter.getMaterials()[indexPath.row]
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .overCurrentContext
        navigationController?.present(nav, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: -cell.frame.height)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            cell.transform = .identity
            cell.alpha = 1.0
        }
    }
    
}

// MARK: - Material Table View Cell Delegate
extension MaterialsVC:MaterialCellDelegate{
    func editMaterialAction(material: Material) {
        let vc = CreateMaterialVC.instantiate()
        vc.presenter.setMaterial(material: material)
        vc.presenter.setSelectionData(selectionData: presenter.selectionData)
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Binding
extension MaterialsVC{
    private func BindingAction(){
        companyButton.addTarget(self, action: #selector(binding), for: .touchUpInside)
        jobsButton.addTarget(self, action: #selector(binding), for: .touchUpInside)
        phaseButton.addTarget(self, action: #selector(binding), for: .touchUpInside)
        specialButton.addTarget(self, action: #selector(binding), for: .touchUpInside)
    }
    
    
    @objc private func binding(_ sender:UIButton){
        switch sender{
        case companyButton:
            companiesAction()
        case jobsButton:
            jobsAction()
        case phaseButton:
            phasesAction()
        case specialButton:
            specialsAction()
        
        default:
            break
        }
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createAction(){
        let vc = CreateMaterialVC.instantiate()
        vc.presenter.setSelectionData(selectionData: presenter.selectionData)
        vc.phase = phaseTextField.text!
        vc.builder = presenter.selectedjob?.customer ?? ""
        vc.community = presenter.selectedjob?.project ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func companiesAction(){
        companyPickerVC = PickerVC.instantiate()
        companyPickerVC!.arr_data = presenter.getCompanies()
        companyPickerVC!.searchText = presenter.companySearchText
        companyPickerVC!.index = presenter.selectedCompanyIndex
        companyPickerVC!.searchBarHiddenStatus = false
        companyPickerVC!.searchAction = { searchText in
            self.presenter.companySearchText = searchText
            self.presenter.selectedCompanyIndex = 0
            self.presenter.getCompaniesFromDB(search: searchText)
        }
        companyPickerVC!.isModalInPresentation = true
        companyPickerVC!.modalPresentationStyle = .overFullScreen
        companyPickerVC!.definesPresentationContext = true
        companyPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.companyTextField.text = self.presenter.getCompanies(at: index).title ?? ""
            self.presenter.companyID = self.presenter.getCompanies(at: index).id ?? 0
            self.presenter.selectedCompanyIndex = index
            self.presenter.getJobsFromDB(companyID: "\(self.presenter.companyID)", search: "")
            self.presenter.getMaterialsFromAPI()
        }
        self.present(companyPickerVC!, animated: true, completion: nil)
    }
    
    
    private func jobsAction(){
        jobPickerVC = PickerVC.instantiate()
        jobPickerVC!.arr_data = presenter.getJobs()
        jobPickerVC!.searchText = presenter.jobSearchText
        jobPickerVC!.index = presenter.selectedJobIndex
        jobPickerVC!.searchBarHiddenStatus = false
        jobPickerVC!.searchAction = { searchText in
            self.presenter.jobSearchText = searchText
            self.presenter.selectedJobIndex = 0
            self.presenter.getJobsFromDB(companyID: String(self.presenter.companyID), search: searchText)
        }
        jobPickerVC!.isModalInPresentation = true
        jobPickerVC!.modalPresentationStyle = .overFullScreen
        jobPickerVC!.definesPresentationContext = true
        jobPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.jobsTextField.text = self.presenter.getJobs(at: index).title ?? ""
            self.presenter.jobID = self.presenter.getJobs(at: index).id ?? 0
            self.presenter.selectedjob = self.presenter.getJobs(at: index)
            self.presenter.selectedJobIndex = index
            self.presenter.getMaterialsFromAPI()
            self.presenter.getSpecialFromAPI()
        }
        self.present(jobPickerVC!, animated: true, completion: nil)
    }
    
    
    private func phasesAction(){
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
            self.phaseTextField.text = self.presenter.phasesSearchText == "" ? self.presenter.getPhase(at:index) : self.presenter.getSearchedPhases(at:index)
            self.presenter.phase = self.phaseTextField.text!
            self.presenter.selectedPhasesIndex = index
            self.presenter.getMaterialsFromAPI()
        }
        self.present(phasePickerVC!, animated: true, completion: nil)
    }
    
    
    private func specialsAction(){
        
        specialPickerVC = PickerVC.instantiate()
        specialPickerVC!.arr_data = presenter.specialsSearchText == "" ? presenter.getSpecials() : presenter.getSearchedSpecials()
        specialPickerVC!.searchText = presenter.specialsSearchText
        specialPickerVC!.index = presenter.selectedSpecialsIndex
        specialPickerVC!.searchBarHiddenStatus = false
        specialPickerVC!.searchAction = { searchText in
            self.presenter.specialsSearchText = searchText
            self.presenter.selectedSpecialsIndex = 0
            self.presenter.searchSpecials(search: searchText)
        }
        specialPickerVC!.isModalInPresentation = true
        specialPickerVC!.modalPresentationStyle = .overFullScreen
        specialPickerVC!.definesPresentationContext = true
        specialPickerVC!.delegate = {name , index in
            // Selection Action Here
            self.specialTextField.text = self.presenter.specialsSearchText == "" ? self.presenter.getSpecial(at: index) : self.presenter.getSearchedSpecials(at: index)
            self.presenter.special = self.specialTextField.text!
            self.presenter.selectedSpecialsIndex = index
            self.presenter.getMaterialsFromAPI()
        }
        self.present(specialPickerVC!, animated: true, completion: nil)
    }
    
}


extension MaterialsVC:MaterialsPresetnerDelegate{
    func updateCompaniesUI() {
        if let companyPickerVC = self.companyPickerVC{
            companyPickerVC.arr_data = self.presenter.getCompanies()
            companyPickerVC.picker.reloadAllComponents()
            if !companyPickerVC.arr_data.isEmpty || !presenter.companySearchText.isEmpty{
                self.companyView.backgroundColor = .clear
                self.companyButton.isEnabled = true
                companyPickerVC.index = presenter.selectedCompanyIndex
            }else{
                self.companyView.backgroundColor = .systemGray5
                self.companyButton.isEnabled = false
                self.companyTextField.text = ""
            }
        }
    }
    
    func updateJobsUI() {
        if !(presenter.getJobs() as [DataDetails]).isEmpty || !presenter.jobSearchText.isEmpty{
            self.jobsView.backgroundColor = .clear
            self.jobsButton.isEnabled = true
        }else{
            self.jobsView.backgroundColor = .systemGray5
            self.jobsButton.isEnabled = false
            jobsTextField.text = ""
        }
        
        if let jobPickerVC = self.jobPickerVC{
            jobPickerVC.arr_data = self.presenter.getJobs()
            jobPickerVC.picker.reloadAllComponents()
            if !jobPickerVC.arr_data.isEmpty{
                jobPickerVC.index = presenter.selectedJobIndex
            }
        }
    }
    
    func updatePhasesUI() {
        
        if !presenter.getPhases().isEmpty || !presenter.phasesSearchText.isEmpty{
            phaseView.backgroundColor = .clear
            phaseButton.isEnabled = true
        }else{
            phaseView.backgroundColor = .systemGray5
            phaseButton.isEnabled = false
            phaseTextField.text = ""
        }
        
        
        if let phasePickerVC = phasePickerVC{
            phasePickerVC.arr_data = presenter.phasesSearchText == "" ? presenter.getPhases() : presenter.getSearchedPhases()
            phasePickerVC.picker.reloadAllComponents()
            if !phasePickerVC.arr_data.isEmpty{
                phasePickerVC.index = presenter.selectedPhasesIndex
            }
        }
    }
    
    
    func updateSpecialsUI() {
        if !presenter.getSpecials().isEmpty || !presenter.specialsSearchText.isEmpty{
            specialView.backgroundColor = .clear
            specialButton.isEnabled = true
        }else{
            specialView.backgroundColor = .systemGray5
            specialButton.isEnabled = false
            specialTextField.text = ""
        }
        
        if let specialPickerVC = specialPickerVC{
            specialPickerVC.arr_data = presenter.specialsSearchText == "" ? presenter.getSpecials() : presenter.getSearchedSpecials()
            specialPickerVC.picker.reloadAllComponents()
            if !specialPickerVC.arr_data.isEmpty{
                specialPickerVC.index = presenter.selectedSpecialsIndex
            }
        }
    }
    
    func updateMaterialsUI() {
        tableView.reloadData()
    }
    
    
}


extension MaterialsVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}


