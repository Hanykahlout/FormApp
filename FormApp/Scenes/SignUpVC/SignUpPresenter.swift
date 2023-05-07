//
//  SignUpPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 20/04/2023.
//

import UIKit

protocol SignUpPresenterDelegate{
    func getUserData(user:User)
}

typealias SignUpDelegate = SignUpPresenterDelegate & UIViewController

class SignUpPresenter:NSObject{
    weak var delegate:SignUpDelegate?
    
    // MARK: - API Requests
    func signup(firstName:String,lastName:String,email:String,password:String){
        AppManager.shared.signUpUser(fname: firstName, lname: lastName, email: email, password: password) { Response in
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
