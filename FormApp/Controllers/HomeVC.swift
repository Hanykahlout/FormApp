//
//  HomeVC.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit
import SVProgressHUD
class HomeVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var qcFormBtn: UIButton!
    @IBOutlet weak var emailSupportBtn: UIButton!
    
    //MARK: - Properties
    
    let presenter = AppPresenter()
    var email = ""
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
        presenter.checkDatabase()
        presenter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppManager.shared.monitorNetwork {
            SVProgressHUD.show(withStatus: "Submit all stored forms")
            self.presenter.callAllRealmRequests()
        } notConectedAction: {}
    }
    
}

extension HomeVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        qcFormBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        emailSupportBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        
    }
}


extension HomeVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
    
}

extension HomeVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case qcFormBtn:
            let vc = OptionsVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case emailSupportBtn:
            self.sendEmail(email: "blowe@cpnhinc.com")
            
//        case logoutBtn:
//            do{
//                try KeychainWrapper.set(value:"" , key: self.email )
//                AppData.email = self.email
//                self.presenter.logout()
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController")
//                self.sceneDelegate?.setRootVC(vc: vc)
//
//            } catch let error {
//                print(error)
//            }
        default:
            print("")
        }
        
    }
}

extension HomeVC:FormDelegate{
    func checkUpdatedReuests(data: RequestsStatus) {
        self.presenter.getAllDataAndStoreOnDB(data: data)
    }
    
}
