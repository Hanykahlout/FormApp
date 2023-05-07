//
//  CreateMaterialPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 07/05/2023.
//

import UIKit
import SVProgressHUD

protocol CreateMaterialPresenterDelegate{
    func successSubmtion()
}

typealias CreateMaterialDelegate = CreateMaterialPresenterDelegate & UIViewController

class CreateMaterialPresenter{
    weak var delegate:CreateMaterialDelegate?
    
    func createMaterial(itemNo:String,name:String,
                        builder:String,community:String,
                        modelType:String,phase:String,
                        special:String,quantity:String){
        let body = [
            "item_no":itemNo,
            "name":name,
            "builder":builder,
            "community":community,
            "model_type":modelType,
            "phase":phase,
            "special":special,
            "quantity":quantity
        ]

        SVProgressHUD.show()
        AppManager.shared.createHouseMaterial(houseMaterialData: body) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                Alert.showSuccessAlert(message: response.message ?? "")
                self.delegate?.successSubmtion()
            case .failure(let error):
                Alert.showErrorAlert(message: error.localizedDescription)
            }
        }
        
        
    }
    
}
