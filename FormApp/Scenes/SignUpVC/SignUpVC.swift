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
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: - Properties
    
    let presenter = SignUpPresenter()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private Functions
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)

        navigationItem.title = "Sign Up"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
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
    }
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case signupBtn:
            signup()
        case loginBtn:
            navigationController?.popToRootViewController(animated: true)
            let vc = LoginVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
        
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
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


