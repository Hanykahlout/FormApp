//
//  AppPresenter.swift
//  FormApp
//
//  Created by heba isaa on 19/02/2023.
//

import Foundation
import UIKit
import SVProgressHUD
protocol FormDelegate{
    
    func showAlerts(title:String,message:String)
    func getUserData(user:User)
    func getCompanyData(data:CompaniesData)
    func getJobData(data:JobData)
    func getFormsData(data:FormsData)
    func getDivition(data:DiviosnData)
    func getFormItemsData(data:FormItemData)
    func clearFields()
    func checkUpdatedReuests(data:RequestsStatus)
    func getSubmittedFormsData(data:SubmittedFormData)
}

extension FormDelegate{
    func showAlerts(title:String,message:String){}
    func getUserData(user:User){}
    func getCompanyData(data:CompaniesData){}
    func getJobData(data:JobData){}
    func getFormsData(data:FormsData){}
    func getDivition(data:DiviosnData){}
    func getFormItemsData(data:FormItemData){}
    func clearFields(){}
    func checkUpdatedReuests(data:RequestsStatus){}
    func getSubmittedFormsData(data:SubmittedFormData){}
}
typealias FormsDelegate = FormDelegate & UIViewController

class AppPresenter:NSObject{
    weak var delegate:FormsDelegate?
    
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
    
    
    func logout(){
        AppManager.shared.logout{ Response in
            
            switch Response{
                
            case let .success(response):
                if response.status == true{
                    self.delegate?.showAlerts(title:"Success", message: response.message ?? "")
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
                self.addToDBModels(models: data?.companies ?? [] , type: "companies")
                for deletedCompany in data?.deletedCompanies ?? []{
                    self.deleteDataDetailsFromRealmDB(id: deletedCompany.id ?? -1)
                }
                dispatchGroup.leave()
            }
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if data.job ?? false{
            self.getJobs(normal: normal, uuid: uuid,companyID: "", search: "") { data in
                self.addToDBModels(models: data?.jobs ?? [] , type: "jobs")
                for deletedJob in data?.deletedJobs ?? []{
                    self.deleteDataDetailsFromRealmDB(id: deletedJob.id ?? -1)
                }
                dispatchGroup.leave()
            }
        }else{
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        if data.division ?? false{
            getDivision(normal: normal, uuid: uuid){ data in
                self.addToDBModels(models: data?.divisions ?? [] , type: "divisions")
                for deletedDivistion in data?.deletedDivisions ?? []{
                    self.deleteDataDetailsFromRealmDB(id: deletedDivistion.id ?? -1)
                }
                dispatchGroup.leave()
            }
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if data.form ?? false{
            getForms(normal: normal, uuid: uuid) { data in
                self.addToDBModels(models: data?.forms ?? [] , type: "forms")
                for deletedForm in data?.deletedForms ?? []{
                    self.deleteDataDetailsFromRealmDB(id: deletedForm.id ?? -1)
                }
                dispatchGroup.leave()
            }
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if data.formItem ?? false{
            self.getFormItem(normal: normal, uuid: uuid,formTypeID: "") { data in
                self.addToFormItemDBModels(models:data?.formItems ?? [])
                for itemDeleted in data?.deletedFormItems ?? []{
                    self.deleteFormItemRealmDB(id: itemDeleted.id ?? -1)
                }
                dispatchGroup.leave()
            }
            
        }else{
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            UserDefaults.standard.set(true, forKey: "AddAllDataToRealm")
            SVProgressHUD.dismiss()
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
    
    func submitFormData(isEdit:Bool,isFormNewOnline:Bool,formsDetails:[String : Any]){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        AppManager.shared.submitForms(isEdit:isEdit,formsDetails: formsDetails) { Response in
            dispatchGroup.leave()
            SVProgressHUD.dismiss()
            switch Response{
            case let .success(response):
                if response.status == true{
                    if !isFormNewOnline{
                        Alert.showSuccessAlert(message: response.message ?? "")
                        self.delegate?.clearFields()
                    }
                }else{
                    Alert.showErrorAlert(message: response.message ?? "")
                }
            case  .failure(let error):
                DispatchQueue.main.async {
                    if UserDefaults.standard.bool(forKey: "internet_connection"){
                        Alert.showErrorAlert(message: error.localizedDescription)
                    }else{
                        let url = "\(AppConfig.apiBaseUrl)submitForm"
                        let token = try? KeychainWrapper.get(key: AppData.email) ?? ""
                        let headers:[String:Any] = ["Authorization":token ?? "" ,"Accept":"application/json","Accept-Language":"en"]
                        self.addRequestToRealm(url: url, body: formsDetails, header: headers, method: "post",isEdit: isEdit)
                        self.delegate?.clearFields()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss()
            if isFormNewOnline{
                Alert.showSuccessAlert(title:"Success",message: "All stored forms have been submitted successfully")
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
            submitFormData(isEdit:model.isEdit ?? false,isFormNewOnline:true,formsDetails: convertStringToDic(string: model.body ?? ""))
            RealmManager.sharedInstance.removeObject(model)
        }
        if models.isEmpty {
            SVProgressHUD.dismiss()
        }
    }
    
    func checkDatabase(){
        if UserDefaults.standard.string(forKey: "ApplicationSessionUUID") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "ApplicationSessionUUID")
        }
        AppManager.shared.checkDatabase(uuid: UserDefaults.standard.string(forKey: "ApplicationSessionUUID")!) { response in
            switch response{
            case let .success(response):
                if response.status == true{
                    if let data = response.data{
                        self.delegate?.checkUpdatedReuests(data: data)
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
    
    
    
    // MARK: - Realm DB Actions
    
    // MARK: - Fetch Realm DB Actions
    func getCompaniesFromDB(){
        self.delegate?.getCompanyData(data: CompaniesData(companies: self.getFromDBMdeols(type: "companies")))
    }
    
    func getJobsFromDB(companyID:String,search:String){
        self.delegate?.getJobData(data: JobData(jobs: self.getFromDBJobsModels(companyId: companyID,searchText: search)))
    }
    
    func getFormsFromDB(){
        self.delegate?.getFormsData(data: FormsData(forms: self.getFromDBMdeols(type: "forms")))
    }
    
    func getDivisionFromDB(){
        self.delegate?.getDivition(data: DiviosnData(divisions: self.getFromDBMdeols(type: "divisions")))
    }
    
    func getFormItemFromDB(formTypeID:String){
        self.delegate?.getFormItemsData(data: FormItemData(formItems: self.getFromDBItemsModels(formTypeID: formTypeID)))
    }
    
    
    private func getFromDBMdeols(type:String)->[DataDetails]{
        let predicate = NSPredicate(format: "type == %@", type)
        guard let models = RealmManager.sharedInstance.fetchObjects(DataDetailsDBModel.self,predicate: predicate) else {return []}
        var result = [DataDetails]()
        for model in models {
            let id = model.id
            let title = model.title
            let email = model.email
            let company_id = model.company_id
            let created_at = model.created_at
            let obj = DataDetails(id: id, title: title, email: email, company_id: company_id, created_at: created_at)
            result.append(obj)
        }
        return result
    }
    
    
    private func getFromDBJobsModels(companyId:String,searchText:String)->[DataDetails]{
        let searchQuery = "AND title CONTAINS[c] '\(searchText)'"
        let predicate = NSPredicate(format: "type == %@ AND company_id == %@ \(searchText != "" ? searchQuery : "")","jobs",companyId)
        
        guard let models = RealmManager.sharedInstance.fetchObjects(DataDetailsDBModel.self,predicate: predicate) else {return []}
        var result = [DataDetails]()
        for model in models {
            let id = model.id
            let title = model.title
            let email = model.email
            let company_id = model.company_id
            let created_at = model.created_at
            let obj = DataDetails(id: id, title: title, email: email, company_id: company_id, created_at: created_at)
            result.append(obj)
        }
        return result
    }
    
    
    private func getFromDBItemsModels(formTypeID:String)->[DataDetails]{
        let predicate = NSPredicate(format: "form_type_id == '\(formTypeID)'")
        guard let models = RealmManager.sharedInstance.fetchObjects(FormItemDBModel.self,predicate: predicate) else {return []}
        var result = [DataDetails]()
        for model in models {
            let id = model.id
            let title = model.title
            let created_at = model.created_at
            let form_type_id = model.form_type_id
            let obj = DataDetails(id: id, title: title, created_at: created_at,form_type_id: form_type_id)
            result.append(obj)
        }
        return result
    }
    
    
    // MARK: - Add Realm DB Actions
    
    private func addRequestToRealm(url:String,body:[String:Any],header:[String:Any],method:String,isEdit:Bool){
        let request = RequestModel()
        request.id = UUID().uuidString
        request.url = url
        request.isEdit = isEdit
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.body = String(data: bodyData ?? Data(), encoding: .utf8)
        let headersData = try? JSONSerialization.data(withJSONObject: header, options: .prettyPrinted)
        request.headers = String(data: headersData ?? Data(), encoding: .utf8)
        request.method = method
        request.email = (try? KeychainWrapper.get(key: "email")) ?? ""
        RealmManager.sharedInstance.saveObject(request)
        Alert.showSuccessAlert(title:"The submission succeeded",message: "It is sent when connected to the Internet")
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
    
    
    private func addToDBModels(models:[DataDetails],type:String){
        for model in models{
            let dbModel = DataDetailsDBModel()
            dbModel.id = model.id
            dbModel.title = model.title
            dbModel.email = model.email
            dbModel.company_id = model.company_id
            dbModel.created_at = model.created_at
            dbModel.type = type
            RealmManager.sharedInstance.saveObject(dbModel)
        }
    }
    
    private func addToFormItemDBModels(models:[DataDetails]){
        for model in models{
            let dbModel = FormItemDBModel()
            dbModel.id = model.id
            dbModel.title = model.title
            dbModel.created_at = model.created_at
            dbModel.form_type_id = model.form_type_id
            RealmManager.sharedInstance.saveObject(dbModel)
        }
    }
    
    // MARK: - Remove Realm DB Actions
    
    private func deleteDataDetailsFromRealmDB(id:Int){
        RealmManager.sharedInstance.removeWhere(column: "id", value: id, for: DataDetailsDBModel.self)
    }
    
    private func deleteFormItemRealmDB(id:Int){
        RealmManager.sharedInstance.removeWhere(column: "id", value: id, for: FormItemDBModel.self)
    }
}




