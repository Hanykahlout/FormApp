//
//  HomeVC.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit
import SVProgressHUD
import CoreTelephony
import SystemConfiguration

class HomeVC: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var airplaneNoteLabel: UILabel!
    
    //MARK: - Properties
    
    let presenter = HomePresenter()
    var email = ""
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        presenter.delegate = self
        tableView.delegate = self
        binding()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.checkDatabase()
        checkUnsubmittedForms()
        
    }
    
    
    private func checkUnsubmittedForms(){
        if UserDefaults.standard.bool(forKey: "internet_connection"){
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: "Submit all stored forms")
                self.presenter.callAllRealmRequests()
            }
        }
    }
    
    
}

// MARK: - Binding
extension HomeVC{
    private func binding(){
        airplaneNoteLabel.isUserInteractionEnabled = true
        airplaneNoteLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(airplaneAction)))
        
        let attributedString = NSMutableAttributedString(string: "Please keep your Airplane mode off from here so you can take advantage of the app's services")
        
        // Add attributes to the specific word
        let range = (attributedString.string as NSString).range(of: "here")
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        airplaneNoteLabel.attributedText = attributedString
    }
    
    @objc private func airplaneAction(){
       
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }

    }
    
    
}

extension HomeVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
    
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "HomeVCTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeVCTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = CGFloat(presenter.data.count * 50)
        return presenter.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVCTableViewCell", for: indexPath) as! HomeVCTableViewCell
        cell.titleLabel.text = presenter.data[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = presenter.data[indexPath.row]
        switch data{
            
        case .Forms:
            let vc = SubmittedFormsVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
            
        case .PORequest:
            let alertVC = UIAlertController(title: "Have you checked the dashboard/WIP to make sure the job is open?", message: "", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Yes", style: .default,handler: { alert in
                let vc = PORequestVC.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            alertVC.addAction(UIAlertAction(title: "No", style: .default,handler: { alert in
                let alertVC2 = UIAlertController(title: "please check that and come back if it's open", message: "", preferredStyle: .alert)
                alertVC2.addAction(.init(title: "Cancel", style: .cancel))
                self.present(alertVC2, animated: true)
            }))
            self.present(alertVC, animated: true)
        case .Materials:
            let vc = MaterialsVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}


extension HomeVC:HomePresenterDelegate{
    
    
}








