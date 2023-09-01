//
//  ForgetPasswordVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 02/08/2023.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Private Properties
    private let presenter = ForgetPasswordPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        binding()
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
        
        navigationItem.title = "Forget Password"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
    }
    
}

// MARK: - Binding

extension ForgetPasswordVC{
    private func binding(){
        sendButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case sendButton:
            let email = emailTextField.text!
            
            if email.hasSuffix("@cpnhinc.com") || email.hasSuffix("@coastaltradesupply.com"){
                presenter.restPassword(email: email)
            }else{
                Alert.showErrorAlert(message: "Invalid email address")
            }
            
        default:
            break
        }
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Presenter Delegate
extension ForgetPasswordVC:ForgetPasswordPresenterDelegate{
    
}


// MARK: - Set Storyboard
extension ForgetPasswordVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}

