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
    
    func checkAppStore() {
        SVProgressHUD.show()
        let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        AppManager.shared.checkAppStoreVersion(bundleId: bundleId) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                let shouldUpdate = self.isVersionShouldUpdate(currentVersion ?? "", lowerThan: response.results?.first?.version ?? "")
                self.delegate?.changeApplicationUpdatedStatus(shouldUpdate: shouldUpdate)
                
                
            case .failure(_):
                Alert.showErrorAlert(message: "Request Error: Faild to check the updates for the current version")
            }
        }
    }
    
    private func isVersionShouldUpdate(_ version1: String, lowerThan version2: String) -> Bool {
        let components1 = version1.split(separator: ".").compactMap { Int($0) }
        let components2 = version2.split(separator: ".").compactMap { Int($0) }
        
        let minLength = min(components1.count, components2.count)
        
        for i in 0..<minLength {
            if components1[i] < components2[i] {
                return true
            } else if components1[i] > components2[i] {
                return false
            }
        }
        
        return components1.count < components2.count
    }
}

