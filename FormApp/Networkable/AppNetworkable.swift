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
    
    func signUpUser(fname:String,lname:String,email:String,password:String,completion: @escaping (Result<BaseResponse<User>, Error>)-> ())
    func login(email:String,password:String,completion: @escaping (Result<BaseResponse<User>, Error>)-> ())
    func getCompanies(normal: Int, uuid: String,completion: @escaping (Result<BaseResponse<CompaniesData>, Error>)-> ())
    func getJob(normal: Int, uuid: String,companyId:String,search:String,completion: @escaping (Result<BaseResponse<JobData>, Error>)-> ())
    func forms(normal: Int, uuid: String,completion: @escaping (Result<BaseResponse<FormsData>, Error>)-> ())
    func division(normal: Int, uuid: String,completion: @escaping (Result<BaseResponse<DiviosnData>, Error>)-> ())
    func logout(completion: @escaping (Result<BaseResponse<Empty>, Error>)-> ())
    func getFormItems(normal: Int, uuid: String,form_type_id:String,completion: @escaping (Result<BaseResponse<FormItemData>, Error>)-> ())
    func submitForms(isEdit:Bool,formsDetails:[String : Any],completion: @escaping (Result<BaseResponse<FormItemData>, Error>)-> ())
    func getFormItemReasons(normal: Int, uuid: String,completion: @escaping (Result<BaseResponse<FormItemReasons>, Error>)-> ())
    func getPhaseSpecial(completion: @escaping (Result<BaseResponse<PhasesBuilders>, Error>)-> ())
    func getHouseMaterials(company_id: Int, job_id: Int, phase: String, special: String,completion: @escaping (Result<BaseResponse<MaterialsData>, Error>)-> ())
    func createHouseMaterial(isEdit:Bool,houseMaterialData:[String:Any],completion: @escaping (Result<BaseResponse<Material>, Error>)-> ())
    func getSpecialList(jobId:String,builder:String,completion: @escaping (Result<BaseResponse<SpecialList>, Error>)-> ())
    
}


class AppManager: AppNetworkable {
    
    typealias targetType = AppTarget
    
    var provider: MoyaProvider<AppTarget> = MoyaProvider<AppTarget>(plugins: [NetworkLoggerPlugin()])
    
    public static var shared: AppManager = {
        let generalActions = AppManager()
        return generalActions
    }()
    
    
    func signUpUser(fname:String,lname:String,email:String,password:String,completion: @escaping (Result<BaseResponse<User>, Error>)-> ()) {
        request(target: .SignUp(fname:fname,lname:lname,email:email,password:password), completion: completion)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<BaseResponse<User>, Error>) -> ()) {
        request(target: .login(email: email, password: password), completion: completion)
    }
    
    func getCompanies(normal: Int, uuid: String,completion: @escaping (Result<BaseResponse<CompaniesData>, Error>) -> ()) {
        request(target: .getCompanies(normal: normal, uuid: uuid), completion: completion)
    }
    
    func getJob(normal: Int, uuid: String,companyId: String,search:String, completion: @escaping (Result<BaseResponse<JobData>, Error>) -> ()) {
        request(target: .getJob(normal: normal, uuid: uuid,companyId: companyId,search:search), completion: completion)
    }
    
    func forms(normal: Int, uuid: String,completion: @escaping (Result<BaseResponse<FormsData>, Error>) -> ()) {
        request(target: .forms(normal: normal, uuid: uuid), completion: completion)
    }
    
    func division(normal: Int, uuid: String,completion: @escaping (Result<BaseResponse<DiviosnData>, Error>) -> ()) {
        request(target: .divisions(normal: normal, uuid: uuid), completion: completion)
    }
    
    func logout(completion: @escaping (Result<BaseResponse<Empty>, Error>) -> ()) {
        request(target: .logout, completion: completion)
    }
    
    func getFormItems(normal: Int, uuid: String,form_type_id: String, completion: @escaping (Result<BaseResponse<FormItemData>, Error>) -> ()) {
        request(target:.getFormItems(normal: normal, uuid: uuid,form_type_id: form_type_id), completion: completion)
    }
    
    func submitForms(isEdit:Bool,formsDetails: [String : Any], completion: @escaping (Result<BaseResponse<FormItemData>, Error>) -> ()) {
        request(target: .submitForms(isEdit:isEdit,formsDetails: formsDetails), completion: completion)
    }
    
    func checkDatabase(uuid:String,completion: @escaping (Result<BaseResponse<RequestsStatus>, Error>) -> ()) {
        request(target: .checkDatabase(uuid: uuid), completion: completion)
    }
    
    func getSubmittedForms(searchText:String,completion: @escaping (Result<BaseResponse<SubmittedFormData>, Error>) -> ()){
        request(target: .submittedForms(search: searchText), completion: completion)
    }
    
    func getFormItemReasons(normal: Int, uuid: String,completion: @escaping (Result<BaseResponse<FormItemReasons>, Error>)-> ()) {
        request(target: .formItemReasons(normal: normal, uuid: uuid), completion: completion)
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
