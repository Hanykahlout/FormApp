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

        navigationItem.title = "Login"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
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
        
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Life cycle

extension LoginVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case signupBtn:
            navigationController?.popViewController(animated: true)
            let vc = SignUpVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case loginBtn:
            login()
            
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
            if email.hasSuffix("@cpnhinc.com") || email.hasSuffix("@coastaltradesupply.com"){
                SVProgressHUD.setBackgroundColor(.white)
                SVProgressHUD.show(withStatus: "please wait")
                self.presenter.login( email: email, password: pass)
                self.presenter.delegate = self
            }else{
                Alert.showErrorAlert(message: "Invalid email address")
            }
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
            AppData.id = user.id ?? -1
            SVProgressHUD.dismiss()
            goToHomeNav()
            
            
        } catch let error {
            print(error)
        }
    }
    
}


