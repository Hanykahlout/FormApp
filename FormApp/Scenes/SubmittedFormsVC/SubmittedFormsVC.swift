//
//  FormsViewController.swift
//  FormApp
//
//  Created by Hany Alkahlout on 19/03/2023.
//

import UIKit
import SVProgressHUD

class SubmittedFormsVC: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var searchBarView: SearchView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupSegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataStackView: UIStackView!
    @IBOutlet weak var airplaneNoteLabel: UILabel!
    
    private let presnter = SubmittedFormsPresenter()
    private var data = [FormInfo]()
    private var formsData:SubmittedFormData?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presnter.delegate = self
        binding()
        setUpTableView()
        searchBarView.txtSearch.textColor = .white
        emptyDataStackView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presnter.getSubmittedForms(search: "")
        checkUnsubmittedForms()
    }
    
    private func checkUnsubmittedForms(){
        if UserDefaults.standard.bool(forKey: "internet_connection"){
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: "Submit all stored forms")
                self.presnter.callAllRealmRequests()
            }
        }
    }
    
    // MARK: - Private Functions
    
}


// MARK: - Binding
extension SubmittedFormsVC{
    private func binding(){
        createButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        setUpSegment()
        searchBarView.btnSearch.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        
        airplaneNoteLabel.isUserInteractionEnabled = true
        airplaneNoteLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(airplaneAction)))
        
        let attributedString = NSMutableAttributedString(string: "Please keep your Airplane mode off from here so you can take advantage of the app's services")
        
        // Add attributes to the specific word
        let range = (attributedString.string as NSString).range(of: "here")
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        airplaneNoteLabel.attributedText = attributedString
    }

    private func setUpSegment(){
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        groupSegment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        groupSegment.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
    }
    
    @objc private func ButtonWasTapped(btn:UIButton){
        switch btn{
        case backButton:
            navigationController?.popViewController(animated: true)
        case createButton:
            let vc = QCFormVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
    }
    
    @objc private func indexChanged(_ sender: UISegmentedControl) {
        if let formsData = formsData{
            getSubmittedFormsData(data: formsData)
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
    
}

extension SubmittedFormsVC:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormTableViewCell.self)
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
        vc.editData = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SubmittedFormsVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}



extension SubmittedFormsVC:SubmittedFormsPresenterDelegate{
    func getSubmittedFormsData(data: SubmittedFormData) {
        formsData = data
        self.data = groupSegment.selectedSegmentIndex == 0 ? data.passForms : data.failForms
        self.tableView.reloadData()
        self.emptyDataStackView.isHidden = !self.data.isEmpty
    }
    
}
