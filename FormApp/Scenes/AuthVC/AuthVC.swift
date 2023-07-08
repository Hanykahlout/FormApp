//
//  ViewController.swift
//  FormApp
//
//  Created by Hany Alkahlout on 25/01/2023.
//

import UIKit
import LocalAuthentication
class AuthVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var faceIdButton: UIButtonDesignable!
    //MARK: - Properties
    private let presenter = AuthPresenter()
    var isFromUnautherized = false
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        BindButtons()
        faceIdButton.isHidden = isFromUnautherized
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: "internet_connection") {
            presenter.checkVersion()
        }else{
            signupBtn.isEnabled = true
            loginBtn.isEnabled = true
            faceIdButton.isEnabled = true
        }
    }
    
    // MARK: - Private Functions
    
    
    private func AuthorizeFaceID(){
        let context = LAContext()
        let reason = "please authorize with touch id! "
        
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication,
                               localizedReason: reason,
                               reply: { (success, error) in
            DispatchQueue.main.async {
                if success{
                    self.goToHomeVC()
                }else{
                    let alert = UIAlertController(title: "Failed to Authenticate ", message: "please try Again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel,handler:nil))
                    self.present(alert, animated: true)
                }
            }
        })
    }
    
    private func goToHomeVC(){
        let nav1 = UINavigationController()
        let mainView = HomeVC.instantiate()
        nav1.viewControllers = [mainView]
        nav1.navigationBar.isHidden = true
        sceneDelegate?.setRootVC(vc: nav1)
    }
    
    
}

//MARK: - Binding
extension AuthVC{
    
    func BindButtons(){
        signupBtn.isEnabled = false
        loginBtn.isEnabled = false
        faceIdButton.isEnabled = false
        
        signupBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        faceIdButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
}

//MARK: - Binding

extension AuthVC{
    
    @objc func ButtonWasTapped(btn:UIButton){

        switch btn{
        case signupBtn:
            let vc = SignUpVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case loginBtn:
            let vc = LoginVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case faceIdButton:
            AuthorizeFaceID()
        default:
            print("")
        }
        
    }
}

// MARK: - Presenter Delegate
extension AuthVC:AuthPresenterDelegate{
    func changeApplicationUpdatedStatus(shouldUpdate: Bool) {
        if shouldUpdate{
            signupBtn.isEnabled = false
            loginBtn.isEnabled = false
            faceIdButton.isEnabled = false
            let alertVC = UIAlertController(title: "You have to update the application", message: "", preferredStyle: .alert)
            alertVC.addAction(.init(title: "Update Now", style: .default,handler: { action in
                if let url = URL(string: "https://apps.apple.com/us/app/chesapeake-app/id6449914587"){
                    UIApplication.shared.open(url)
                }
            }))
            alertVC.addAction(.init(title: "Cancel", style: .default,handler: { action in
                exit(0)
            }))
            present(alertVC, animated: true)
        }else{
            signupBtn.isEnabled = true
            loginBtn.isEnabled = true
            faceIdButton.isEnabled = true
        }
    }
}

extension AuthVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
    
}


