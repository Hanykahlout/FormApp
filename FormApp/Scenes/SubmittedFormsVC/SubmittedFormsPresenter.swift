//
//  SubmittedFormsPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 21/04/2023.
//

import UIKit
import SVProgressHUD

protocol SubmittedFormsPresenterDelegate{
    func getSubmittedFormsData(data: SubmittedFormData) 
}

typealias SubmittedFormsDelegate = SubmittedFormsPresenterDelegate & UIViewController

class SubmittedFormsPresenter{
    weak var delegate: SubmittedFormsDelegate?
    
    func getSubmittedForms(search:String){
        SVProgressHUD.show()
        AppManager.shared.getSubmittedForms(searchText: search) { response in
            SVProgressHUD.dismiss()
            switch response {
            case .success(let response):
                if let data = response.data{
                    DispatchQueue.main.async {
                        self.delegate?.getSubmittedFormsData(data: data)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    
}
