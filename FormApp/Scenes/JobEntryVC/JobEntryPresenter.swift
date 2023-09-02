//
//  JobEntryPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 8/27/23.
//

import UIKit
import SVProgressHUD
protocol JobEntryPresenterDelegate{
    func updateFieldData(searchType:JobEntrySearchType)
    func updateCityField()
    func updateZipField()
    func successStoreJob()
    func handelBuilderData(data:Budgets?)
    func showSignInVC()
}

typealias JobEntryPresenterVCDelegate = JobEntryPresenterDelegate & UIViewController


class JobEntryPresenter{
    
    weak var delegate:JobEntryPresenterVCDelegate?
    var data:ApiListsData?
    var cities:CitiesData?
    var zip:ZipData?
    var selectedState = ""
    var selectedBuilder = ""
    var selectedModel = ""
    var selectedProjectManager = ""
    var selectedBusinessManager = ""
    
    func getApiList(search:String? = nil,searchType:JobEntrySearchType){
        
        SVProgressHUD.show()
        AppManager.shared.getApiLists(search: search, searchType: searchType) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if response.status ?? false{
                        self.data = response.data
                        self.delegate?.updateFieldData(searchType: searchType)
                    }else{
                        Alert.showErrorAlert(message: response.message ?? "")
                    }
                case .failure(let error):
                    Alert.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    
    func getCities(search:String,state:String){
        SVProgressHUD.show()
        AppManager.shared.getCities(search:search,state: state) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if response.status ?? false{
                        self.cities = response.data
                        self.delegate?.updateCityField()
                    }else{
                        Alert.showErrorAlert(message: response.message ?? "")
                    }
                case .failure(let error):
                    Alert.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    
    func getZip(search:String,city:String){
        SVProgressHUD.show()
        AppManager.shared.getZip(search:search,city: city) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if response.status ?? false{
                        self.zip = response.data
                        self.delegate?.updateZipField()
                    }else{
                        Alert.showErrorAlert(message: response.message ?? "")
                    }
                case .failure(let error):
                    Alert.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    func storeJob(data:[String:Any]){
        SVProgressHUD.show()
        AppManager.shared.storeJob(data: data) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if response.status ?? false{
                        self.showAlert(title: "Success", message: response.message ?? "") {
                            self.delegate?.successStoreJob()
                        }
                    }else{
                        self.showAlert( title: "Error", message: response.message ?? "") {
                            if response.code == 402{
                                self.delegate?.showSignInVC()
                            }
                            if let level =  data["level"] as? Int,
                               level == -1{
                                self.delegate?.successStoreJob()
                            }
                        }
                        
                    }
                case .failure(let error):
                    Alert.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    func getBuilders(){
        SVProgressHUD.show()
        AppManager.shared.getBudgets(model: selectedModel, builder: selectedBuilder) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                    if response.status ?? false{
                        self.delegate?.handelBuilderData(data:response.data?.budgets)
                    }else{
                        Alert.showErrorAlert(message: response.message ?? "")
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

enum JobEntrySearchType{
    
    case none,
         search_builder,
         search_division,
         search_company,
         search_project_manager,
         search_business_manager,
         search_model,
         search_project,
         search_state,
         search_cost_code
}

