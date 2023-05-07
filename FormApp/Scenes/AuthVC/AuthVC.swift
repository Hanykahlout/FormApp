//
//  ViewController.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit
import LocalAuthentication
class AuthVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var faceIdButton: UIButtonDesignable!
    //MARK: - Properties
    var isFromUnautherized = false
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
        faceIdButton.isHidden = isFromUnautherized
    }
    
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
extension AuthVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        signupBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        faceIdButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
}

//MARK: - Life cycle

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

extension AuthVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
    
}


