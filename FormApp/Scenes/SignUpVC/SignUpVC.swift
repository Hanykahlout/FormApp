//
//  SignUpVC.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit
import SVProgressHUD
class SignUpVC: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet private weak var firstNameTf: MainTF!
    @IBOutlet private weak var lastNameTf: MainTF!
    @IBOutlet private weak var emailTf: MainTF!
    @IBOutlet private weak var passwordTf: MainTF!
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: - Properties
    
    let presenter = SignUpPresenter()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
    }
    
}


extension SignUpVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
    
}

extension SignUpVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        signupBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
}

//MARK: - Life cycle

extension SignUpVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case signupBtn:
            signup()
        case loginBtn:
            navigationController?.popToRootViewController(animated: true)
            let vc = LoginVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case backBtn :
            navigationController?.popToRootViewController(animated: true)
        default:
            print("")
        }
        
    }
}


extension SignUpVC{
    func signup(){
        
        do{
            let fname = try firstNameTf.valueTxt.validatedText(validationType: .requiredField(field: "first name required"))
            let lname = try lastNameTf.valueTxt.validatedText(validationType: .requiredField(field: "last name requied"))
            let email = try emailTf.valueTxt.validatedText(validationType: .email)
            let pass = try passwordTf.valueTxt.validatedText(validationType: .requiredField(field: "password required"))
            if email.hasSuffix("@cpnhinc.com") || email.hasSuffix("@coastaltradesupply.com"){
                SVProgressHUD.setBackgroundColor(.white)
                SVProgressHUD.show(withStatus: "please wait")
                self.presenter.signup(firstName: fname, lastName: lname, email: email, password: pass)
            }else{
                Alert.showErrorAlert(message: "Invalid email address")
            }
            self.presenter.delegate = self
        }catch{
            Alert.showErrorAlert(message: (error as! ValidationError).message)
        }
        
    }
}


extension SignUpVC: SignUpPresenterDelegate{
    
    func getUserData(user: User) {
        do{
            try KeychainWrapper.set(value: user.email ?? "" , key: "email")
            try KeychainWrapper.set(value: "Bearer"+" "+user.api_token! , key: user.email ?? "")
            AppData.email = user.email ?? ""
            AppData.id = user.id ?? -1
            SVProgressHUD.dismiss()
            self.goToHomeNav()
            
        } catch let error {
            print(error)
        }
    }
    
}


