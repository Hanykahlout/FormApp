//
//  CreateNewPassPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 10/08/2023.
//

import UIKit
import SVProgressHUD

protocol CreateNewPassPresenterDelegate{
    
}

typealias CreateNewPassPresenterVCDelegate = CreateNewPassPresenterDelegate & UIViewController

class CreateNewPassPresenter{
    
    weak var delegate:CreateNewPassPresenterVCDelegate?
    
    func updatePassword(password:String,passwordConfirmation:String){
        SVProgressHUD.show()
        AppManager.shared.updatePassword(password:password,passwordConfirmation:passwordConfirmation) { result in
            SVProgressHUD.dismiss()
            
            switch result {
                
            case .success(let response):
                
                if response.status ?? false{
                    
                    DispatchQueue.main.async {
                        let vc = SuccessAlertVC.instantiate()
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.message = response.message ?? "Your account is ready to use"
                        self.delegate?.present(vc, animated: true)
                    }
                    
                }else{
                    Alert.showErrorAlert(message: response.message ?? "")
                }
                
            case .failure(let error):
                Alert.showErrorAlert(message: error.localizedDescription)
            }
            
            
        }
    }
    
    
}
