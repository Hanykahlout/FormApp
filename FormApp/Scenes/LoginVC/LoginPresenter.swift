//
//  LoginPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 21/04/2023.
//

import UIKit
import SVProgressHUD

protocol LoginPresenterDelefate{
    func getUserData(user: User)
}

typealias LoginDelegate = LoginPresenterDelefate & UIViewController


class LoginPresenter{
    weak var delegate:LoginDelegate?
    
    func login(email:String,password:String){
        AppManager.shared.login(email: email, password: password) { Response in
            SVProgressHUD.dismiss()
            switch Response{
                
            case let .success(response):
                if response.status == true{
                    self.delegate?.getUserData(user: response.data!)
                    
                }else{
                    Alert.showErrorAlert(message: response.message ?? "")
                }
            case  .failure(let error):
                DispatchQueue.main.async {
                    if UserDefaults.standard.bool(forKey: "internet_connection"){
                        Alert.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    

    
}
