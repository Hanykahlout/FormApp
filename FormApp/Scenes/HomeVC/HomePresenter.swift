//
//  HomePresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 21/04/2023.
//

import UIKit
import SVProgressHUD

enum HomeAction:String {
    case Forms="Forms"
    case PORequest="PO Request"
    case Materials="Material List"
}

protocol HomePresenterDelegate{
    func handleCheckDatabaseData(data:RequestsStatus)
}

typealias HomeDelegate = HomePresenterDelegate & UIViewController

class HomePresenter{
    weak var delegate: HomeDelegate?
    var data:[HomeAction] = [.Forms,.Materials]
    
    func checkDatabase(refresh:Bool? = nil){
        var appVersion:String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        var iosVersion:String? = UIDevice.current.systemVersion
        var deviceModel:String? = UIDevice.modelName
        if UserDefaults.standard.string(forKey: "ApplicationSessionUUID") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "ApplicationSessionUUID")
        }
        SVProgressHUD.show(withStatus: "Checking if there is data has not been fetched from the server")
        AppManager.shared.checkDatabase(uuid: UserDefaults.standard.string(forKey: "ApplicationSessionUUID")!,iosVersion: iosVersion,deviceModel: deviceModel,applicationVersion: appVersion,refresh: refresh) { response in
            SVProgressHUD.dismiss()
            switch response{
            case let .success(response):
                if response.status == true{
                    if let data = response.data{
                        self.delegate?.handleCheckDatabaseData(data: data)
                        self.getAllDataAndStoreOnDB(data: data)
                    }else{
                        Alert.showErrorAlert(message: "There is an unknown error")
                    }
                }else{
                    Alert.showErrorAlert(message: "There is an unknown error")
                }
            case  .failure(_):
                break
            }
        }
    }
    
    func callAllRealmRequests(){
        guard let email = try? KeychainWrapper.get(key: "email") else {
            SVProgressHUD.dismiss()
            return
        }
        let predicate = NSPredicate(format: "email == %@", email)
        guard let models = RealmManager.sharedInstance.fetchObjects(RequestModel.self,predicate: predicate) else {
            SVProgressHUD.dismiss()
            return
        }
        for model in models {
            submitFormData(model:model,isEdit:model.isEdit ?? false,formsDetails: convertStringToDic(string: model.body ?? ""))
        }
        if models.isEmpty {
            SVProgressHUD.dismiss()
        }
    }
    
    
    func getAllDataAndStoreOnDB(data:RequestsStatus){
        var normal = 1
        var uuid = ""
        if UserDefaults.standard.bool(forKey: "FirstFetchDataDone"){
            normal = 0
            uuid = UserDefaults.standard.string(forKey: "ApplicationSessionUUID") ?? ""
        }else{
            UserDefaults.standard.set(true, forKey: "FirstFetchDataDone")
        }
        SVProgressHUD.show(withStatus: "Please wait until all data fetched from server")
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        if data.company ?? false{
            getCompanies(normal: normal, uuid: uuid) { data in
                RealmController.shared.addToDBModels(models: data?.companies ?? [] , type: "companies")
                for deletedCompany in data?.deletedCompanies ?? []{
                    RealmController.shared.deleteDataDetailsFromRealmDB(id: deletedCompany.id ?? -1)
                }
                dispatchGroup.leave()
            }
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if data.job ?? false{
            self.getJobs(normal: normal, uuid: uuid,companyID: "", search: "") { data in
                RealmController.shared.addToDBModels(models: data?.jobs ?? [] , type: "jobs")
                for deletedJob in data?.deletedJobs ?? []{
                    RealmController.shared.deleteDataDetailsFromRealmDB(id: deletedJob.id ?? -1)
                }
                dispatchGroup.leave()
            }
        }else{
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        if data.division ?? false{
            getDivision(normal: normal, uuid: uuid){ data in
                RealmController.shared.addToDBModels(models: data?.divisions ?? [] , type: "divisions")
                for deletedDivistion in data?.deletedDivisions ?? []{
                    RealmController.shared.deleteDataDetailsFromRealmDB(id: deletedDivistion.id ?? -1)
                }
                dispatchGroup.leave()
            }
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if data.form ?? false{
            getForms(normal: normal, uuid: uuid) { data in
                RealmController.shared.addToDBModels(models: data?.forms ?? [] , type: "forms")
                for deletedForm in data?.deletedForms ?? []{
                    RealmController.shared.deleteDataDetailsFromRealmDB(id: deletedForm.id ?? -1)
                }
                dispatchGroup.leave()
            }
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if data.formItem ?? false{
            self.getFormItem(normal: normal, uuid: uuid,formTypeID: "") { data in
                RealmController.shared.addToFormItemDBModels(models:data?.formItems ?? [])
                for itemDeleted in data?.deletedFormItems ?? []{
                    RealmController.shared.deleteFormItemRealmDB(id: itemDeleted.id ?? -1)
                }
                dispatchGroup.leave()
            }
            
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if data.subContractor ?? false{
            self.getSubContractors(normal: normal, uuid: uuid) { data in
                RealmController.shared.addToSubContractorsDBModel(models:data?.subContractors ?? [])
                for itemDeleted in data?.deletedSubContractors ?? []{
                    RealmController.shared.deleteSubContractorDBModel(id: itemDeleted.id ?? -1)
                }
                dispatchGroup.leave()
            }
            
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if data.failReason ?? false{
                self.getFormItemReasons(normal: normal, uuid: uuid) { data in
                    RealmManager.sharedInstance.addToFormItemReasonDBModels(models:data?.failReasons ?? [])
                    for deleteFailReason in data?.deletedFailReason ?? []{
                        RealmController.shared.deleteFormFailReasons(id: deleteFailReason.id ?? -1)
                    }
                    UserDefaults.standard.set(true, forKey: "AddAllDataToRealm")
                    SVProgressHUD.dismiss()
                    if UserDefaults.standard.bool(forKey: "internet_connection"){
                        DispatchQueue.main.async {
                            SVProgressHUD.show(withStatus: "Submit all stored forms")
                            self.submitAllSortedForms()
                        }
                    }
                }
            }else{
                UserDefaults.standard.set(true, forKey: "AddAllDataToRealm")
                SVProgressHUD.dismiss()
                self.submitAllSortedForms()
                
            }
            
        }
        
    }
    
    private func submitAllSortedForms(){
        if UserDefaults.standard.bool(forKey: "internet_connection"){
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: "Submit all stored forms")
                self.callAllRealmRequests()
            }
        }
    }
    
    private func getCompanies(normal:Int,uuid:String,completion:@escaping (_ data:CompaniesData?)->Void){
        AppManager.shared.getCompanies(normal: normal, uuid: uuid) { Response in
            switch Response{
            case let .success(response):
                if response.status == true{
                    completion(response.data)
                }else{
                    completion(nil)
                }
            case  .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    private func getJobs(normal:Int,uuid:String,companyID:String,search:String,completion:@escaping(_ data:JobData?)->Void){
        AppManager.shared.getJob(normal: normal, uuid: uuid,companyId:companyID,search:search ) { Response in
            switch Response{
            case let .success(response):
                if response.status == true{
                    completion(response.data)
                }else{
                    completion(nil)
                }
            case  .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    private func getForms(normal: Int, uuid: String,completion:@escaping(_ data:FormsData?)->Void){
        AppManager.shared.forms(normal: normal, uuid: uuid){ Response in
            switch Response{
            case let .success(response):
                if response.status == true{
                    completion(response.data)
                }else{
                    completion(nil)
                }
            case  .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    private func getDivision(normal: Int, uuid: String,compltion:@escaping (_ data:DiviosnData?)->Void){
        AppManager.shared.division(normal: normal, uuid: uuid){ Response in
            switch Response{
                
            case let .success(response):
                if response.status == true{
                    compltion(response.data)
                }else{
                    compltion(nil)
                }
            case  .failure(_):
                DispatchQueue.main.async {
                    compltion(nil)
                }
            }
        }
    }
    
    private func getSubContractors(normal: Int, uuid: String,compltion:@escaping (_ data:SubContractorsResponse?)->Void){
        AppManager.shared.subContractors(normal: normal, uuid: uuid){ Response in
            switch Response{
            case let .success(response):
                if response.status == true{
                    compltion(response.data)
                }else{
                    compltion(nil)
                }
            case  .failure(_):
                DispatchQueue.main.async {
                    compltion(nil)
                }
            }
        }
    }
    
    private func getFormItem(normal: Int, uuid: String,formTypeID:String,compltion:@escaping (_ data:FormItemData?)->Void){
        AppManager.shared.getFormItems(normal: normal, uuid: uuid,form_type_id:formTypeID ){ Response in
            switch Response{
            case let .success(response):
                if response.status == true{
                    compltion( response.data)
                }else{
                    compltion(nil)
                }
            case  .failure(_):
                DispatchQueue.main.async {
                    compltion(nil)
                }
            }
        }
    }
    
    
    
    
    private func getFormItemReasons(normal: Int, uuid: String,compltion:@escaping (_ data:FormItemReasons?)->Void){
        AppManager.shared.getFormItemReasons(normal: normal, uuid: uuid){ Response in
            switch Response{
            case let .success(response):
                if response.status == true{
                    compltion( response.data)
                }else{
                    compltion(nil)
                }
            case  .failure(_):
                DispatchQueue.main.async {
                    compltion(nil)
                }
            }
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
        }
        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss()
            Alert.showSuccessAlert(title:"Success",message: "All stored forms have been submitted successfully")
        }
    }
  
    
    func convertStringToDic(string: String) -> [String: Any] {
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
