//
//  JobEntrySiginInVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/1/23.
//

import UIKit

class JobEntrySiginInVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButtonDesignable!
    @IBOutlet weak var signInButton: UIButtonDesignable!
    
    private let presenter = JobEntrySiginInPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        binding()
    }
    
    // MARK: - Private Functions
    
    private func validation() -> Bool{
        let userName = usernameTextField.text!
        let password = passwordTextField.text!
        var isError = false
        if userName.isEmpty {
            isError = true
            showError(on: usernameTextField)
        }
        if password.isEmpty {
            isError = true
            showError(on: passwordTextField)
        }
        return !isError
    }
    
    private func signInAction(){
        if validation(){
            NotificationCenter.default.post(name: .init("JobEntrySiginIn"), object: (username:usernameTextField.text!,password:passwordTextField.text!))
            dismiss(animated: true)
        }else{
            Alert.showErrorAlert(message: "Please fill in all fields before signing in")
        }
    }
    
    
}

// MARK: - Binding

extension JobEntrySiginInVC{
    
    private func binding(){
        signInButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case signInButton:
            signInAction()
        case cancelButton:
            dismiss(animated: true)
        default:
            break
        }
    }
    
}

// MARK: - Presenter Delegate

extension JobEntrySiginInVC:JobEntrySiginInPresenterDelegate{
    
}

// MARK: - Set Storyboard

extension JobEntrySiginInVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
