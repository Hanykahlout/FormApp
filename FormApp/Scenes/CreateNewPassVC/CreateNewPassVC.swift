//
//  CreateNewPassVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 05/08/2023.
//

import UIKit

class CreateNewPassVC: UIViewController {
    
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Private Properties
    private let presenter = CreateNewPassPresenter()
    
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
        
        navigationItem.title = "Create New Password"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
    }
    
    
}

// MARK: - Binding
extension CreateNewPassVC{
    
    private func binding(){
        continueButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case continueButton:
            
            presenter.updatePassword(password: passwordTextFiled.text!, passwordConfirmation: confirmTextField.text!)
            
        default:
            break
        }
    }
    
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Presenter Delegate
extension CreateNewPassVC:CreateNewPassPresenterDelegate{
    
}

// MARK: - Set Storyboard
extension CreateNewPassVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}

