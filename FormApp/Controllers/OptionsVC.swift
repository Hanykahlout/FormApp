//
//  OptionsVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 16/03/2023.
//

import UIKit

class OptionsVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitNewFormButton: UIButton!
    @IBOutlet weak var submittedFormsButton: UIButton!
    @IBOutlet weak var failedFormsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindButtons()
        // Do any additional setup after loading the view.
    }
    
    
}

extension OptionsVC{
    
    //MARK: - Binding
    
    func BindButtons(){
        backButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        submitNewFormButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        submittedFormsButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
        failedFormsButton.addTarget(self, action: #selector(ButtonWasTapped), for: .touchUpInside)
    }
}


extension OptionsVC{
    
    @objc func ButtonWasTapped(btn:UIButton){
        switch btn{
        case backButton:
            navigationController?.popViewController(animated: true)
        case submitNewFormButton:
            let vc = QCFormVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case submittedFormsButton:break
        case failedFormsButton:break
        default:
            print("")
        }
        
    }
}

extension OptionsVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
