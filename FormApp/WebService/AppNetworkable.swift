//
//  AppNetworkable.swift
//  FormApp
//
//  Created by Hany Alkahlout on 18/02/2023.
//

import Foundation
import Moya
import Network
import Alamofire

protocol AppNetworkable:Networkable  {
    
    func getCurrentVersion(completion: @escaping (Result<BaseResponse<VersionModel>, Error>)-> ())
    func changeVersion(uuid:String,checkDatabase:Bool,model:String,completion: @escaping (Result<BaseResponse<VersionModel>, Error>)-> ())
    func signUpUser(fname:String,lname:String,email:String,password:String,completion: @escaping (Result<BaseResponse<User>, Error>)-> ())
    func login(email:String,password:String,completion: @escaping (Result<BaseResponse<User>, Error>)-> ())
    
    func getCompanies(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<CompaniesData>, Error>)-> ())
    func getJob(page:Int?,normal: Int?, uuid: String?,companyId:String,search:String,completion: @escaping (Result<BaseResponse<JobData>, Error>)-> ())
    func forms(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<FormsData>, Error>)-> ())
    func division(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<DiviosnData>, Error>)-> ())
    func subContractors(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<SubContractorsResponse>, Error>)-> ())
    func getFormItemReasons(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<FormItemReasons>, Error>)-> ())
    func getFormItems(normal: Int?, uuid: String?,form_type_id:String,project:String?,completion: @escaping (Result<BaseResponse<FormItemData>, Error>)-> ())
    func logout(completion: @escaping (Result<BaseResponse<Empty>, Error>)-> ())
    
    func submitForms(formPurpose:FormPurpose,formsDetails:[String : Any],completion: @escaping (Result<BaseResponse<FormItemData>, Error>)-> ())
    
    func getPhaseSpecial(completion: @escaping (Result<BaseResponse<PhasesBuilders>, Error>)-> ())
    func getHouseMaterials(company_id: Int, job_id: Int, phase: String, special: String,completion: @escaping (Result<BaseResponse<MaterialsData>, Error>)-> ())
    func createHouseMaterial(isEdit:Bool,houseMaterialData:[String:Any],completion: @escaping (Result<BaseResponse<Material>, Error>)-> ())
    func getSpecialList(jobId:String,builder:String,completion: @escaping (Result<BaseResponse<SpecialList>, Error>)-> ())
    func updateOnline(startDate:Date?,endDate:Date?,completion: @escaping (Result<BaseResponse<VersionModel>, Error>)-> ())
    func checkAppStoreVersion(bundleId:String,completion: @escaping (Result<AppStoreReponse, Error>)-> ())
    func resetPassword(email:String,completion: @escaping (Result<BaseResponse<VersionModel>, Error>)-> ())
    func checkCode(email:String,code:String,completion: @escaping (Result<BaseResponse<CheckCodeData>, Error>)-> ())
    func updatePassword(password:String,passwordConfirmation:String,completion: @escaping (Result<BaseResponse<VersionModel>, Error>)-> ())
    
    func getCities(search:String,state:String,completion: @escaping (Result<BaseResponse<CitiesData>, Error>)-> ())
    func getZip(search:String,city:String,completion: @escaping (Result<BaseResponse<ZipData>, Error>)-> ())
    
    func storeJob(data:[String:Any],completion: @escaping (Result<BaseResponse<VersionModel>, Error>)-> ())
    func getBudgets(model:String,builder:String,completion: @escaping (Result<BaseResponse<BudgetResponse>, Error>)-> ())
    
    func getWarranties(completion: @escaping (Result<BaseResponse<WarrantiesResponse>, Error>)-> ())
    func getWarranty(workOrderNumber:String,completion: @escaping (Result<BaseResponse<WarrantyResponse>, Error>)-> ())
    func storeWarranty(data:[String:Any],completion: @escaping (Result<BaseResponse<VersionModel>, Error>)-> ())
    func getUsers(search:String,completion: @escaping (Result<BaseResponse<UsersResponse>, Error>)-> ())
    func getNotifications(completion: @escaping (Result<BaseResponse<NotificationResponse>, Error>)-> ())
    func getSubmittedForm(submittedFromId:String,completion: @escaping (Result<BaseResponse<FormInfo>, Error>)-> ())
    
}


class AppManager: AppNetworkable {
    
    typealias targetType = AppTarget
    
    var provider: MoyaProvider<AppTarget> = MoyaProvider<AppTarget>(plugins: [NetworkLoggerPlugin()])
    
    public static var shared: AppManager = {
        let generalActions = AppManager()
        return generalActions
    }()
    
    func getCurrentVersion(completion: @escaping (Result<BaseResponse<VersionModel>, Error>) -> ()) {
        request(target: .version, completion: completion)
    }
    
    func changeVersion(uuid: String, checkDatabase: Bool, model: String, completion: @escaping (Result<BaseResponse<VersionModel>, Error>) -> ()) {
        request(target: .changeVersion(uuid: uuid, checkDatabase: checkDatabase, model: model), completion: completion)
    }
    func signUpUser(fname:String,lname:String,email:String,password:String,completion: @escaping (Result<BaseResponse<User>, Error>)-> ()) {
        request(target: .SignUp(fname:fname,lname:lname,email:email,password:password), completion: completion)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<BaseResponse<User>, Error>) -> ()) {
        request(target: .login(email: email, password: password), completion: completion)
    }
    
    func getCompanies(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<CompaniesData>, Error>) -> ()) {
        request(target: .getCompanies(normal: normal, uuid: uuid), completion: completion)
    }
    
    func getJob(page:Int?,normal: Int?, uuid: String?,companyId: String,search:String, completion: @escaping (Result<BaseResponse<JobData>, Error>) -> ()) {
        request(target: .getJob(page:page,normal: normal, uuid: uuid,companyId: companyId,search:search), completion: completion)
    }
    
    func forms(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<FormsData>, Error>) -> ()) {
        request(target: .forms(normal: normal, uuid: uuid), completion: completion)
    }
    
    func division(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<DiviosnData>, Error>) -> ()) {
        request(target: .divisions(normal: normal, uuid: uuid), completion: completion)
    }
    
    func subContractors(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<SubContractorsResponse>, Error>) -> ()) {
        request(target: .subContractors(normal: normal, uuid: uuid), completion: completion)
    }
    
    func getFormItems(normal: Int?, uuid: String?,form_type_id: String,project:String? ,completion: @escaping (Result<BaseResponse<FormItemData>, Error>) -> ()) {
        request(target:.getFormItems(normal: normal, uuid: uuid,form_type_id: form_type_id,project:project), completion: completion)
    }
    
    func getFormItemReasons(normal: Int?, uuid: String?,completion: @escaping (Result<BaseResponse<FormItemReasons>, Error>)-> ()) {
        request(target: .formItemReasons(normal: normal, uuid: uuid), completion: completion)
    }
    
    
    func logout(completion: @escaping (Result<BaseResponse<Empty>, Error>) -> ()) {
        request(target: .logout, completion: completion)
    }

    
    func submitForms(formPurpose:FormPurpose,formsDetails: [String : Any], completion: @escaping (Result<BaseResponse<FormItemData>, Error>) -> ()) {
        request(target: .submitForms(formPurpose:formPurpose,formsDetails: formsDetails), completion: completion)
    }
    
    func checkDatabase(uuid:String,iosVersion:String?,deviceModel:String?,applicationVersion:String?,refresh:Bool?,completion: @escaping (Result<BaseResponse<RequestsStatus>, Error>) -> ()) {
        request(target: .checkDatabase(uuid: uuid,iosVersion:iosVersion,deviceModel:deviceModel,applicationVersion:applicationVersion,refresh: refresh), completion: completion)
    }
    
    func getSubmittedForms(searchText:String,completion: @escaping (Result<BaseResponse<SubmittedFormData>, Error>) -> ()){
        request(target: .newSubmittedForms(search: searchText), completion: completion)
    }
    
  
    func getPhaseSpecial(completion: @escaping (Result<BaseResponse<PhasesBuilders>, Error>)-> ()){
        request(target: .getLists, completion: completion)
    }
    
    
    func getHouseMaterials(company_id: Int, job_id: Int, phase: String, special: String,completion: @escaping (Result<BaseResponse<MaterialsData>, Error>) -> ()) {
        request(target: .getHouseMaterials(company_id: company_id, job_id: job_id, phase: phase, special: special), completion: completion)
    }
    
    
    func createHouseMaterial(isEdit:Bool,houseMaterialData: [String : Any], completion: @escaping (Result<BaseResponse<Material>, Error>) -> ()) {
        request(target: .createHouseMaterial(isEdit:isEdit,houseMaterialData: houseMaterialData), completion: completion)
    }
    
    func getSpecialList(jobId: String,builder:String, completion: @escaping (Result<BaseResponse<SpecialList>, Error>) -> ()) {
        request(target: .getSpecialList(job_id: jobId,builder: builder), completion: completion)
    }
    
    func updateOnline(startDate: Date?, endDate: Date?, completion: @escaping (Result<BaseResponse<VersionModel>, Error>) -> ()) {
        request(target: .updateOnline(start: startDate, end: endDate), completion: completion)
    }
    
    func checkAppStoreVersion(bundleId: String, completion: @escaping (Result<AppStoreReponse, Error>) -> ()) {
        request(target: .checkAppStoreVersion(bundleId: bundleId), completion: completion)
    }
    
    func resetPassword(email: String, completion: @escaping (Result<BaseResponse<VersionModel>, Error>) -> ()) {
        request(target: .resetPassword(email: email), completion: completion)
    }
    
    func checkCode(email: String, code: String, completion: @escaping (Result<BaseResponse<CheckCodeData>, Error>) -> ()) {
        request(target: .checkCode(email: email, code: code), completion: completion)
    }
    
    func updatePassword(password: String, passwordConfirmation: String, completion: @escaping (Result<BaseResponse<VersionModel>, Error>) -> ()) {
        request(target: .updatePassword(password: password, passwordConfirmation: passwordConfirmation), completion: completion)
    }
    
    func getApiLists(search:String? = nil,searchType:JobEntrySearchType,completion: @escaping (Result<BaseResponse<ApiListsData>, Error>) -> ()) {
        request(target: .getApiLists(search: search, searchType: searchType), completion: completion)
    }
    
    func getCities(search:String,state: String, completion: @escaping (Result<BaseResponse<CitiesData>, Error>) -> ()) {
        request(target: .getCities(search:search,state: state), completion: completion)
    }
    
    func getZip(search:String,city:String,completion: @escaping (Result<BaseResponse<ZipData>, Error>) -> ()) {
        request(target: .getZIP(search:search,city: city), completion: completion)
    }
    
    
    func storeJob(data: [String : Any], completion: @escaping (Result<BaseResponse<VersionModel>, Error>) -> ()) {
        request(target: .storeJob(data: data), completion: completion)
    }
    
    
    func getBudgets(model: String, builder: String, completion: @escaping (Result<BaseResponse<BudgetResponse>, Error>) -> ()) {
        request(target: .getBudgets(model: model, builder: builder), completion: completion)
    }
    
    func getWarranties(completion: @escaping (Result<BaseResponse<WarrantiesResponse>, Error>) -> ()) {
        request(target: .getWarranties, completion: completion)
    }
    
    func getWarranty(workOrderNumber: String, completion: @escaping (Result<BaseResponse<WarrantyResponse>, Error>) -> ()) {
        request(target: .getWarranty(workOrderNumber: workOrderNumber), completion: completion)
    }
    
    func storeWarranty(data: [String : Any], completion: @escaping (Result<BaseResponse<VersionModel>, Error>) -> ()) {
        request(target: .storeWarranty(data: data), completion: completion)
    }
    
    func getUsers(search: String, completion: @escaping (Result<BaseResponse<UsersResponse>, Error>) -> ()) {
        request(target: .getUsers(search: search), completion: completion)
    }
    
    func getNotifications(completion: @escaping (Result<BaseResponse<NotificationResponse>, Error>) -> ()) {
        request(target: .pushNotifications, completion: completion)
    }
    
    func getSubmittedForm(submittedFromId: String, completion: @escaping (Result<BaseResponse<FormInfo>, Error>) -> ()) {
        request(target: .getSubmittedForm(submittedFormId: submittedFromId), completion: completion)
    }
    
    
    func monitorNetwork(conectedAction:(()->Void)?,notConectedAction:(()->Void)?){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied{
                notConectedAction?()
            }else{
                conectedAction?()
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
}
