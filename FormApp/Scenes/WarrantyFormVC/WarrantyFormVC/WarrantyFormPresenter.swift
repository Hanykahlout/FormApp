//
//  WarrantyFormPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/11/23.
//

import UIKit
import SVProgressHUD

protocol WarrantyFormPresenterDelegate{
    func setWarrantyDetails(data:WarrantyResponse)
}

typealias WarrantyFormPresenterVCDelegate = WarrantyFormPresenterDelegate & UIViewController


class WarrantyFormPresenter{
    
    weak var delegate:WarrantyFormPresenterVCDelegate?

    func getWarrantyData(workOrderNumber:String){
        
        SVProgressHUD.show()
        AppManager.shared.getWarranty(workOrderNumber: workOrderNumber) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if let data = response.data ,response.status ?? false{
                        self.delegate?.setWarrantyDetails(data: data)
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
