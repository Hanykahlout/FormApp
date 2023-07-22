//
//  HomeVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 25/01/2023.
//

import UIKit
import SVProgressHUD
import CoreTelephony
import SystemConfiguration

class HomeVC: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshView: UIView!
    
    //MARK: - Properties
    
    let presenter = HomePresenter()
    
    
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
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { timer in
            self.presenter.checkDatabase()
        }
        presenter.checkDatabase()
    }
    
}

// MARK: - Binding
extension HomeVC{
    private func binding(){
        refreshButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case refreshButton:
            presenter.checkDatabase(refresh: true)
        default:break
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
    func handleCheckDatabaseData(data: RequestsStatus) {
        refreshView.isHidden = data.refreshButton ?? "" != "active"
    }
    
}

