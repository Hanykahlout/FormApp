//
//  FormsViewController.swift
//  FormApp
//
//  Created by Hany Alkahlout on 19/03/2023.
//

import UIKit
import SVProgressHUD

class SubmittedFormsVC: UIViewController {
    
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var searchBarView: SearchView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataStackView: UIStackView!
    @IBOutlet weak var airplaneNoteLabel: UILabel!
    
    private let presnter = SubmittedFormsPresenter()
    private var data = [FormInfo]()
    private var formsData:SubmittedFormData?
    private var refreshControl = UIRefreshControl()
    private var optionsPicker:PickerVC?
    private var selectedOptionIndex = 0
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presnter.delegate = self
        binding()
        setUpTableView()
        searchBarView.txtSearch.textColor = .white
        emptyDataStackView.isHidden = false
        refreshControl.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        SVProgressHUD.show()
        presnter.getSubmittedForms(search: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func checkUnsubmittedForms(){
        if UserDefaults.standard.bool(forKey: "internet_connection"){
            DispatchQueue.main.async {
                self.presnter.callAllRealmRequests()
            }
        }else{
            if refreshControl.isRefreshing{
                refreshControl.endRefreshing()
            }
            Alert.showErrorAlert(message: "Internet connection error!!")
        }
    }
    
    // MARK: - Private Functions
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.title = "Forms"
        
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
    private func optionsAction() {
        optionsPicker = PickerVC.instantiate()
        optionsPicker!.index = selectedOptionIndex
        optionsPicker!.arr_data = ["Completed Passed Forms","Uncompleted Failed Forms","Fixture Forms","Drafts"]
        optionsPicker!.searchBarHiddenStatus = true
        optionsPicker!.isModalInPresentation = true
        optionsPicker!.modalPresentationStyle = .overFullScreen
        optionsPicker!.definesPresentationContext = true
        optionsPicker!.delegate = {name , index in
            self.optionLabel.text = name
            self.selectedOptionIndex = index
            if let formsData = self.formsData{
                self.getSubmittedFormsData(data: formsData)
            }
        }
        self.present(optionsPicker!, animated: true, completion: nil)
    }
    
    
}


// MARK: - Binding
extension SubmittedFormsVC{
    private func binding(){
        optionsButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        searchBarView.btnSearch.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        
        airplaneNoteLabel.isUserInteractionEnabled = true
        airplaneNoteLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(airplaneAction)))
        
        let attributedString = NSMutableAttributedString(string: "if you don’t have good service please click here to put your phone in airplane mode to use offline. Please remember to turn airplane mode off when finished. When you get good service please come back into app to send forms.")
        
        // Add attributes to the specific word
        let range = (attributedString.string as NSString).range(of: "here")
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        airplaneNoteLabel.attributedText = attributedString
        
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createAction(){
        let vc = QCFormVC.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func ButtonWasTapped(btn:UIButton){
        switch btn{
        case optionsButton:
            optionsAction()
        default:
            print("")
        }
    }
    
    @objc private func airplaneAction(){
        
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    
    @objc private func searchAction(_ sender : UIButton){
        searchBarView.txtSearch.text = searchBarView.txtSearch.text!.trimmingCharacters(in: .whitespaces)
        presnter.getSubmittedForms(search: searchBarView.txtSearch.text!)
    }
    
    @objc private func refreshAction(){
        checkUnsubmittedForms()
    }
    
}

extension SubmittedFormsVC:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormTableViewCell.self)
        tableView.refreshControl = refreshControl
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FormTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setData(data:data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = QCFormVC.instantiate()
        if selectedOptionIndex == 3{
            vc.draftData = data[indexPath.row]
        }else{
            vc.editData = data[indexPath.row]
        }
        
        navigationController?.pushViewController(vc, animated: true)
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

extension SubmittedFormsVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}



extension SubmittedFormsVC:SubmittedFormsPresenterDelegate{
    func getSubmittedFormsData(data: SubmittedFormData) {
        formsData = data
        switch selectedOptionIndex{
        case 0:
            self.data = data.passForms
        case 1:
            self.data = data.failForms
        case 2:
            self.data = data.fixtureForms
        case 3:
            self.data = data.drafts
        default:break
        }
        self.tableView.reloadData()
        self.emptyDataStackView.isHidden = !self.data.isEmpty
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
    }
    
}

