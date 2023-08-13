//
//  ForgetPasswordPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 10/08/2023.
//

import UIKit
import SVProgressHUD
protocol ForgetPasswordPresenterDelegate{
    
}

typealias ForgetPasswordPresenterVCDelegate = ForgetPasswordPresenterDelegate & UIViewController

class ForgetPasswordPresenter{
    
    weak var delegate:ForgetPasswordPresenterVCDelegate?
    
    func restPassword(email:String){
        SVProgressHUD.show()
        AppManager.shared.resetPassword(email: email) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                if response.status ?? false{
                    DispatchQueue.main.async {
                        let vc = VerificationCodeVC.instantiate()
                        vc.email = email
                        self.delegate?.navigationController?.pushViewController(vc, animated: true)
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
