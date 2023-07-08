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
    
    func callAllRealmRequests(){
        guard let email = try? KeychainWrapper.get(key: "email") else {
            return
        }
        let predicate = NSPredicate(format: "email == %@", email)
        guard let models = RealmManager.sharedInstance.fetchObjects(RequestModel.self,predicate: predicate) else {
            self.getSubmittedForms(search: "")
            return
        }
        for model in models {
            submitFormData(model:model,isEdit:model.isEdit ?? false,formsDetails: convertStringToDic(string: model.body ?? ""))
        }
        if models.isEmpty {
            self.getSubmittedForms(search: "")
        }
    }
    
    private func submitFormData(model: RequestModel,isEdit:Bool,formsDetails:[String : Any]){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        AppManager.shared.submitForms(formPurpose: isEdit ? .edit : .create,formsDetails: formsDetails) { Response in
            dispatchGroup.leave()
            switch Response{
            case .success(let response):
                if response.status == false{
                    Alert.showErrorAlert(message: response.message ?? "")
                }
                RealmManager.sharedInstance.removeObject(model)
            case  .failure(let error):
                DispatchQueue.main.async {
                    if UserDefaults.standard.bool(forKey: "internet_connection"){
                        Alert.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
            self.getSubmittedForms(search: "")
        }
        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss()
            Alert.showSuccessAlert(title:"Success",message: "All stored forms have been submitted successfully")
        }
    }
    
    
    private func convertStringToDic(string: String) -> [String: Any] {
        if let data = string.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }
    
}

