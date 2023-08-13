//
//  SuccessAlertVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 08/08/2023.
//

import UIKit

class SuccessAlertVC: UIViewController {
    
    
    @IBOutlet weak var goToHomeButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Public Properties
    var message = "Your account is ready to use"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageLabel.text = message
    }
    
}

// MARK: - Binding
extension SuccessAlertVC{
    private func binding(){
        goToHomeButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case goToHomeButton:
            goToHomeNav()
        default:
            break
        }
    }
}

// MARK: - Set Storyboard
extension SuccessAlertVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
