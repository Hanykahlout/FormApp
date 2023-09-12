//
//  AttachTypeVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/11/23.
//

import UIKit

class AttachTypeVC: UIViewController {

    @IBOutlet weak var attachPhotoButton: UIButton!
    @IBOutlet weak var attachFileButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    // MARK: - Public Attributes
    
    var selectAction:((_ isPhoto:Bool) -> Void)?
    
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        // Do any additional setup after loading the view.
    }
  
    
    

}

// MARK: - Binding

extension AttachTypeVC{
    
    private func binding(){
        attachPhotoButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        attachFileButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        
        switch sender{
        case attachPhotoButton:
            dismiss(animated: true) {
                self.selectAction?(true)
            }
        case attachFileButton:
            dismiss(animated: true) {
                self.selectAction?(false)
            }
        case cancelButton:
            dismiss(animated: true)
        default:
            break
        }
        
    }
    
}


// MARK: - Set Storyboard

extension AttachTypeVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
