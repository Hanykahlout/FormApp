//
//  AuthPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 27/06/2023.
//

import UIKit
import SVProgressHUD

protocol AuthPresenterDelegate{
    func changeApplicationUpdatedStatus(shouldUpdate:Bool)
}

typealias AuthDelegate = AuthPresenterDelegate & UIViewController

class AuthPresenter{
    
    weak var delegate:AuthDelegate?
    
    func checkVersion() {
        SVProgressHUD.show()
        AppManager.shared.getCurrentVersion { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                if response.status ?? false{
                    if currentVersion ?? "" < response.data?.version ?? ""{
                        self.delegate?.changeApplicationUpdatedStatus(shouldUpdate: true)
                    }else{
                        self.delegate?.changeApplicationUpdatedStatus(shouldUpdate: false)
                    }
                }else{
                    Alert.showErrorAlert(message: "Server Error: Faild to check the updates for the current version")
                }
            case .failure(_):
                Alert.showErrorAlert(message: "Request Error: Faild to check the updates for the current version")
            }
        }
    }
}



