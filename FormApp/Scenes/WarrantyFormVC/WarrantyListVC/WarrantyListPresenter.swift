//
//  WarrantyListPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/30/23.
//


import UIKit
import SVProgressHUD

protocol WarrantyListPresenterDelegate{
    func setWarrantiesData(data: WarrantiesResponse)
}

typealias WarrantyListPresenterVCDelegate = WarrantyListPresenterDelegate & UIViewController


class WarrantyListPresenter{
    
    weak var delegate:WarrantyListPresenterVCDelegate?
    
    func getWarranties(){
        
        SVProgressHUD.show()
        AppManager.shared.getWarranties { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if let data = response.data,response.status ?? false{
                        self.delegate?.setWarrantiesData(data: data)
                    }else{
                        Alert.showErrorAlert(message: response.message ?? "Unknow Error!!")
                    }
                case .failure(let error):
                    Alert.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
        
    }
    
}
