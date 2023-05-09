//
//  MaterialsDetailsVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 09/05/2023.
//

import UIKit

class MaterialsDetailsVC: UIViewController {
    
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    var material:Material?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qtyLabel.text = material?.quantity ?? "----"
        descriptionLabel.text = material?.name ?? "----"
        binding()
    }


}
// MARK: - Binding
extension MaterialsDetailsVC{
    private func binding(){
        closeButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender: UIButton){
        switch sender{
        case closeButton:
            navigationController?.dismiss(animated: true)
        default:
            break
        }
    }
}
                                    
                                    
                                    
extension MaterialsDetailsVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
