//
//  VerificationCodePresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 10/08/2023.
//

import UIKit
import SVProgressHUD
protocol VerificationCodePresenterDelegate{
    
}

typealias VerificationCodePresenterVCDelegate = VerificationCodePresenterDelegate & UIViewController

class VerificationCodePresenter{
    weak var delegate:VerificationCodePresenterVCDelegate?
    
    func codeCheck(email:String,code:String){
        SVProgressHUD.show()
        AppManager.shared.checkCode(email: email, code: code) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                if response.status ?? false{
                    AppData.email = email
                    try? KeychainWrapper.set(value: email, key: "email")
                    try? KeychainWrapper.set(value: "Bearer"+" "+(response.data?.user?.api_token ?? "") , key: email)
                    DispatchQueue.main.async {
                        let vc = CreateNewPassVC.instantiate()
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
    
    func restPassword(email:String){
        SVProgressHUD.show()
        AppManager.shared.resetPassword(email: email) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                if response.status ?? false{
                    guard let delegate = self.delegate else { return }
                    DispatchQueue.main.async {
                        Alert.showAlert(viewController: delegate, title: response.message ?? "", message: "", completion: { success in })
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

