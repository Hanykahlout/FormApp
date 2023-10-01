//
//  NotificaitonVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/23/23.
//

import UIKit

class NotificaitonVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    private let presenter = NotificaitonPresenter()
    private var notifications = [NotificationData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        presenter.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationItem.title = "Notificaitons"
        presenter.getNotifications()
    }
    

}
// MARK: -  Table View Delegate And DataSource

extension NotificaitonVC:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.setData(data: notifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch notifications[indexPath.row].type{
        case "form":
            
            let vc = QCFormVC.instantiate()
            vc.isForwardNotification = true
            vc.formId = Int(notifications[indexPath.row].modelID ?? "0") ?? 0
            navigationController?.pushViewController(vc, animated: true)
        
        case "warranty":
            let vc = WarrantyFormVC.instantiate()
            vc.workOrderNumber = notifications[indexPath.row].modelID ?? ""
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
}

// MARK: -  Presenter Delegate

extension NotificaitonVC:NotificaitonPresenterDelegate{
    func setNotificaitons(data: [NotificationData]) {
        self.notifications = data
        self.tableView.reloadData()
    }
}

// MARK: - Set Storyboard

extension NotificaitonVC:Storyboarded{
    
    static var storyboardName: StoryboardName = .main
}
