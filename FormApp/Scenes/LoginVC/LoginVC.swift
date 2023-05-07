//
//  LoginVC.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit
import SVProgressHUD
class LoginVC: UIViewController {
    
    //MARK: - Outlet
    
    @IBOutlet  private weak var emailCustomTf: MainTF!
    @IBOutlet private weak var passCustomTf: MainTF!
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: - Properties

    let presenter = LoginPresenter()
    //MARK: - Life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
        passCustomTf.valueTxt.isSecureTextEntry = true
    }
    
    
}
extension LoginVC:Storyboarded{
    static var storyboardName: StoryboardName = .main

}
extension LoginVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        signupBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
}

//MARK: - Life cycle

extension LoginVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case signupBtn:
            let vc = SignUpVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case loginBtn:
            login() 
        case backBtn :
            navigationController?.popToRootViewController(animated: true)

        default:
            print("")
        }
    }
    
}

extension LoginVC {
    
    func login() {
        
        do{
            
            let email = try emailCustomTf.valueTxt.validatedText(validationType: .email)
            let pass = try passCustomTf.valueTxt.validatedText(validationType:  .requiredField(field: "password required"))
            SVProgressHUD.setBackgroundColor(.white)
            SVProgressHUD.show(withStatus: "please wait")
            self.presenter.login( email: email, password: pass)
            self.presenter.delegate = self
            
        }catch{
            Alert.showErrorAlert(message: (error as! ValidationError).message)
            
        }
    }
    
}

extension LoginVC:LoginPresenterDelefate {
    
    func getUserData(user: User) {
        do{
            try KeychainWrapper.set(value: user.email ?? "" , key: "email")
            try KeychainWrapper.set(value: "Bearer"+" "+user.api_token! , key: user.email ?? "")
            AppData.email = user.email ?? ""
            let vc=HomeVC.instantiate()
            vc.email = user.email ?? ""
            SVProgressHUD.dismiss()

            navigationController?.pushViewController(vc, animated: true)
            
        } catch let error {
            print(error)
        }
    }
    
}
