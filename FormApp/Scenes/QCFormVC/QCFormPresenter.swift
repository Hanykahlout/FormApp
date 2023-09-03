//
//  QCFormPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 21/04/2023.
//

import UIKit
import SVProgressHUD

protocol QCFormPresenterDelegate{
    func clearFields()
    func getCompanyData(data: CompaniesData)
    func getJobData(data: JobData)
    func getFormsData(data: FormsData)
    func getDivition(data: DiviosnData)
    func getSubContractors(data: SubContractorsResponse)
    func getFormItemsData(data: FormItemData)
    func checkUnblockedItems()
}


typealias QCFormDelegate = QCFormPresenterDelegate & UIViewController


class QCFormPresenter{
    weak var delegate:QCFormDelegate?
    
    func getCompaniesFromDB(search:String){
        self.delegate?.getCompanyData(data: CompaniesData(companies: RealmController.shared.getFromDBModels(type: "companies",searchText: search)))
    }
    
    
    func getJobsFromDB(companyID:String,search:String){
        self.delegate?.getJobData(data: JobData(jobs: RealmController.shared.getFromDBModels(type:"jobs",companyId: companyID,searchText: search), total_pages: 1))
        
    }
    
    
    func getFormsFromDB(companyID:String,search:String){
        self.delegate?.getFormsData(data: FormsData(forms: RealmController.shared.getFromDBModels(type:"forms",companyId: companyID,searchText: search)))
    }
    
    
    func getDivisionFromDB(companyID:String,search:String){
       
            self.delegate?.getDivition(data: DiviosnData(divisions: RealmController.shared.getFromDBModels(type:"divisions",companyId: companyID,searchText: search)))

    }
    
    func getSubContractorsDBModel(search:String){
            self.delegate?.getSubContractors(data: SubContractorsResponse(subContractors: RealmController.shared.getSubContractorsDBModel(searchText: search)))
        
    }
    
    
    func getFormItemFromDB(project:String,formTypeID:String){
        self.delegate?.getFormItemsData(data: FormItemData(formItems: RealmController.shared.getFromDBItemsModels(project:project,formTypeID: formTypeID)))
    }
    
    
    func submitFormData(formPurpose:FormPurpose,formsDetails:[String : Any]){
        AppManager.shared.submitForms(formPurpose:formPurpose,formsDetails: formsDetails) { Response in
            SVProgressHUD.dismiss()
            switch Response{
            case let .success(response):
                if response.status == true{
                    Alert.showSuccessAlert(message: response.message ?? "")
                    
                    if formPurpose != .draft && formPurpose != .updateDraft{
                        self.delegate?.clearFields()
                        self.delegate?.navigationController?.popViewController(animated: true)
                    }else{
                        self.delegate?.checkUnblockedItems()
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
                        self.addRequestToRealm(url: url, body: formsDetails, header: headers, method: "post",isEdit: formPurpose == .edit)
                        self.delegate?.clearFields()
                        self.delegate?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    
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
    
    
    
    
}


