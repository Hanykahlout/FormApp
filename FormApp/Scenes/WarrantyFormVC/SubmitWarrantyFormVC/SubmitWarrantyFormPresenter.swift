//
//  SubmitWarrantyFormPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/12/23.
//

import UIKit
import SVProgressHUD

protocol SubmitWarrantyFormPresenterDelegate{
    
}

typealias SubmitWarrantyFormPresenterVCDelegate = SubmitWarrantyFormPresenterDelegate & UIViewController

class SubmitWarrantyFormPresenter{
    
    weak var delegate:SubmitWarrantyFormPresenterVCDelegate?
    
    
    func storeWarranty(data:[String:Any]){
        SVProgressHUD.show()
        AppManager.shared.storeWarranty(data: data) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if response.status ?? false{
                        self.showAlert(title: "Success", message: response.message ?? "") {
                            self.delegate?.navigationController?.popToRootViewController(animated: true)
                        }
                    }else{
                        Alert.showErrorAlert(message: response.message ?? "Unknow Error!!")
                    }
                case .failure(let error):
                    Alert.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(title:String,message:String, completion: @escaping () -> Void){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Cancel", style: .cancel, handler: { action in
            completion()
        }))
        self.delegate?.present(alertVC, animated: true)
    }
    
}



