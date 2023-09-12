//
//  AppTarget.swift
//  FormApp
//
//  Created by Hany Alkahlout on 18/02/2023.
//

import Foundation
import Moya

enum AppTarget:TargetType{
    
    case SignUp(fname:String,lname:String,email:String,password:String)
    case login(email:String,password:String)
    
    case getCompanies(normal:Int?,uuid:String?)
    case getJob(page:Int?,normal:Int?,uuid:String?,companyId:String,search:String)
    case forms(normal:Int?,uuid:String?)
    case divisions(normal:Int?,uuid:String?)
    case subContractors(normal:Int?,uuid:String?)
    case getFormItems(normal:Int?,uuid:String?,form_type_id:String,project:String?)
    case formItemReasons(normal:Int?,uuid:String?)
    
    case logout
    case submitForms(formPurpose:FormPurpose,formsDetails:[String : Any])
    case checkDatabase(uuid:String,iosVersion:String?,deviceModel:String?,applicationVersion:String?,refresh:Bool?)
    case editSubmittedForm(submitted_form_id:String)
    case submittedForms(search:String)
    
    case getLists
    case getSpecialList(job_id:String,builder:String)
    case getHouseMaterials(company_id:Int,job_id:Int,phase:String,special:String)
    case createHouseMaterial(isEdit:Bool,houseMaterialData:[String:Any])
    case version
    case changeVersion(uuid:String,checkDatabase:Bool,model:String)
    case updateOnline(start: Date?,end: Date?)
    case checkAppStoreVersion(bundleId:String)
    case resetPassword(email:String)
    case checkCode(email:String,code:String)
    case updatePassword(password:String,passwordConfirmation:String)
    
    case getApiLists(search:String? = nil,searchType:JobEntrySearchType)
    
    case getZIP(search:String,city:String)
    case getCities(search:String,state:String)
    
    case storeJob(data:[String:Any])
    case getBudgets(model:String,builder:String)
    
    case getWarranties
    case getWarranty(workOrderNumber:String)
    case storeWarranty(data:[String:Any])
    
    var baseURL: URL {
        switch self{
        case .checkAppStoreVersion:
            return URL(string: "\(AppConfig.appStoreURL)")!
        default:
            return URL(string: "\(AppConfig.apiBaseUrl)")!
        }
        
    }
    
    var path: String {
        switch self {
        case .SignUp:return "signUp"
        case .login:return "login"
        case .getCompanies:return "companies"
        case .getJob:return "jobs"
        case .forms:return "forms"
        case .divisions:return "divisions"
        case .getFormItems:return "formItems"
        case .subContractors:return "subContractors"
        case .logout:return "logout"
        case .submitForms(let formPurpose,_):
            switch formPurpose{
            case .create: return "submitForm"
            case .edit: return "updateSubmittedForm"
            case .draft: return "saveForm"
            case .updateDraft: return "updateDraft"
            }
        case .checkDatabase:return "checkDatabase"
        case .editSubmittedForm:return "editSubmittedForm"
        case .submittedForms:return "submittedForms"
        case .formItemReasons:return "failReasons"
        case .getLists:return "getLists"
        case .getSpecialList:return "getSpecialList"
        case .getHouseMaterials:return "getHouseMaterials"
        case .createHouseMaterial(let isEdit,_):return isEdit ? "updateHouseMaterial" : "createHouseMaterial"
        case .version:return "version"
        case .changeVersion:return "changeVersion"
        case .updateOnline:return "updateOnline"
        case .checkAppStoreVersion:return "lookup"
        case .resetPassword: return "resetPassword"
        case .checkCode: return "checkCode"
        case .updatePassword: return "updatePassword"
        case .getApiLists: return "getApiLists"
        case .getCities: return "getCities"
        case .getZIP: return "getZIP"
        case .storeJob: return "storeJob"
        case .getBudgets: return "getBudgets"
        case .getWarranties: return "getWarranties"
        case .getWarranty: return "getWarranty"
        case .storeWarranty: return "storeWarranty"
        }
    }
    
    
    var method: Moya.Method {
        switch self{
            
        case .SignUp,.login,.logout,.submitForms,.createHouseMaterial,.changeVersion,.updateOnline,.resetPassword,.checkCode,.updatePassword,.storeJob,.storeWarranty:
            return .post
            
        case .getCompanies,.getJob,.forms,
                .divisions,.getFormItems,.subContractors,
                .checkDatabase,.editSubmittedForm,.submittedForms,
                .formItemReasons,.getLists,.getHouseMaterials,
                .getSpecialList,.version,.checkAppStoreVersion,
                .getApiLists,.getCities,.getZIP,.getBudgets,.getWarranties,.getWarranty:
            
            return .get
        }
    }
    
    
    var task: Task{
        switch self{
        case .getLists,.version,.getWarranties:
            return .requestPlain
            
        case .getCompanies(let normal,_),.forms(let normal,_),.divisions(let normal,_),
                .formItemReasons(let normal,_),.subContractors(let normal,_):
            
            if normal == 1{
                return .requestPlain
            }
            
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            
        case .SignUp,.login,.logout,
                .createHouseMaterial,.changeVersion,.updateOnline,
                .resetPassword,.checkCode,.updatePassword,.storeJob:
            
            return .requestParameters(parameters: param, encoding: URLEncoding.httpBody)
            
        case .getJob,.getFormItems,.editSubmittedForm,
                .checkDatabase,.submittedForms,.getHouseMaterials,
                .getSpecialList,.checkAppStoreVersion,.getCities,
                .getZIP,.getApiLists,.getBudgets,.getWarranty:
            
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            
        case .submitForms(_, let formsDetails):
            
            var formData: [MultipartFormData] = []
            do{
                for (key,value) in formsDetails{
                    if key.contains("image"){
                        if (value as? String)?.hasPrefix("file:") ?? false{
                            let url = URL(string: value as! String)!
                            let imageData = try Data(contentsOf: url)
                            let image = UIImage(data: imageData)
                            if let imageData = image!.jpegData(compressionQuality: 0.5){
                                formData.append(MultipartFormData(provider: .data(imageData), name: key, fileName: "\(Date.init().timeIntervalSince1970).\(url.pathExtension)", mimeType: url.mimeType()))
                            }
                        }else{
                            formData.append(MultipartFormData(provider: .data((value as! String).data(using: .utf8) ?? Data()), name: key))
                        }
                    }else{
                        formData.append(MultipartFormData(provider: .data((value as! String).data(using: .utf8) ?? Data()), name: key))
                    }
                }
            } catch {
                
            }
            
            return .uploadMultipart(formData)
            
        case .storeWarranty(let data):
            var formData: [MultipartFormData] = []
            do{
                for (key,value) in data{
                    
                    if key == "isPhoto" {
                        continue
                    }else if key == "attachment"{
                        if let url = value as? URL{
                            
                            if url.startAccessingSecurityScopedResource() {
                                
                                let fileData = try Data(contentsOf: url)
                                
                                if data["isPhoto"] as! Bool {
                                    
                                    let image = UIImage(data: fileData)
                                    if let imageData = image!.jpegData(compressionQuality: 0.5){
                                        formData.append(MultipartFormData(provider: .data(imageData), name: key, fileName: "\(Date.init().timeIntervalSince1970).\(url.pathExtension)", mimeType: url.mimeType()))
                                    }
                                    
                                    
                                }else{
                                    
                                    formData.append(MultipartFormData(provider: .data(fileData), name: key, fileName: "\(Date.init().timeIntervalSince1970).\(url.pathExtension)", mimeType: "application/octet-stream"))
                                    
                                }
                            }
                            url.stopAccessingSecurityScopedResource()
                            
                        }
                    }else{
                        formData.append(MultipartFormData(provider: .data((value as! String).data(using: .utf8) ?? Data()), name: key))
                    }
                }
            } catch let error{
                print("There is error here",error.localizedDescription)
            }
            
            return .uploadMultipart(formData)
            
        }
        
    }
    
    var headers: [String : String]?{
        switch self{
            
        case .submittedForms,.getCompanies,.getJob,
                .forms,.divisions,.getFormItems,.subContractors,.logout,
                .submitForms,.checkDatabase,.editSubmittedForm,
                .formItemReasons,.getLists,.getHouseMaterials,
                .createHouseMaterial,.getSpecialList,.updateOnline,
                .updatePassword,.getApiLists,.getCities,
                .getZIP,.storeJob,.getBudgets,.getWarranties,.getWarranty:
            
            do {
                let token = try KeychainWrapper.get(key: AppData.email) ?? ""
                
                return ["Authorization":token ,"Accept":"application/json","Accept-Language":"en"]
            }
            catch{
                return ["Accept":"application/json","Accept-Language":"en"]
            }
            
        case .storeWarranty:
            do {
                let token = try KeychainWrapper.get(key: AppData.email) ?? ""
                
                return ["Authorization":token ,"Accept":"application/json","Accept-Language":"en","Content-type": "multipart/form-data"]
            }
            catch{
                return ["Accept":"application/json","Accept-Language":"en","Content-type": "multipart/form-data"]
            }
            
            
        case .SignUp,.login,.version,
                .changeVersion,.checkAppStoreVersion,.resetPassword,
                .checkCode:
            
            return ["Accept":"application/json","Accept-Language":"en"]
            
        }
    }
    
    
    var param: [String : Any]{
        switch self {
        case .SignUp(let fname,let lname,let email,let password):
            return ["fname":fname,"lname":lname,"email":email,"password":password]
        case .login(let email,let password):
            return ["email":email,"password":password]
        case .getJob(let page,let normal,let uuid,let companyId,let search):
            
            var data:[String:Any] = [:]
            
            if !(normal == 1 || (normal == nil && uuid == nil)){
                data["normal"] = normal!
                data["uuid"] = uuid!
                data["company_id"] = companyId
                data["search"] = search
            }else{
                data["company_id"] = companyId
                data["search"] = search
            }
            
            if let page = page{
                data["page"] = page
            }
            
            return data
            
        case .getCompanies(let normal,let uuid),.forms(let normal,let uuid),.divisions(let normal,let uuid),.formItemReasons(let normal,let uuid),.subContractors(let normal,let uuid):
            if normal == 1 || (normal == nil && uuid == nil){
                return [:]
            }
            return ["normal":normal!,"uuid":uuid!]
        case .getFormItems(let normal,let uuid,let form_type_id,let project):
            
            var data:[String:Any] = [:]
            if !(normal == 1 || (normal == nil && uuid == nil)){
                data["normal"] = normal!
                data["uuid"] = uuid
                data["form_type_id"] = form_type_id
            }else{
                data["form_type_id"] = form_type_id
            }
            
            if let project = project{
                data["project"] = project
                data["form_type_id"] = form_type_id
            }
            
            return data
        case .editSubmittedForm(let submitted_form_id):
            return ["submitted_form_id": submitted_form_id]
        case .checkDatabase(let uuid,let iosVersion,let deviceModel, let applicationVersion,let refresh):
            var data:[String:Any] = [:]
            
            data["uuid"] = uuid
            if let iosVersion = iosVersion{
                data["ios_version"] = iosVersion
            }
            
            if let deviceModel = deviceModel{
                data["device_model"] = deviceModel
            }
            
            if let applicationVersion = applicationVersion{
                data["application_version"] = applicationVersion
            }
            
            if let refresh = refresh{
                data["refresh"] = refresh
            }
            
            return data
        case .submittedForms(let search):
            return ["search":search]
        case .getHouseMaterials(let company_id,let job_id,let phase,let special) :
            return ["company_id":company_id,"job_id":job_id,"phase":phase,"special":special]
        case .createHouseMaterial(_,let houseMaterialData):
            return houseMaterialData
        case .getSpecialList(let job_id,let builder):
            return ["job_id":job_id,"builder":builder]
        case .changeVersion(let uuid, let checkDatabase, let model):
            return ["uuid":uuid,"checkDatabase":checkDatabase,"model":model]
        case .updateOnline(let start, let end):
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .init(identifier: "en")
            dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
            
            var body:[String:Any] = [:]
            if let start = start{
                body["entrance_date"] = dateFormatter.string(from: start)
            }
            
            if let end = end{
                body["leave_date"] = dateFormatter.string(from: end)
            }
            return body
        case .checkAppStoreVersion(let bundleId):
            return ["bundleId":bundleId,"unique_id":UUID().uuidString]
        case .resetPassword(let email):
            return ["email":email]
        case .checkCode(let email, let code):
            return ["email":email,"code":code]
        case .updatePassword(let password, let passwordConfirmation):
            return ["password":password,"password_confirmation":passwordConfirmation]
        case .getCities(let search,let state):
            return ["search":search,"state":state]
        case .getZIP(let search,let city):
            return ["search":search,"city":city]
        case .storeJob(let data):
            return data
        case .getApiLists(let search, let searchType):
            var data:[String:Any] = [:]
            switch searchType {
            case .none:
                break
            case .search_builder:
                data["search_builder"] = search
            case .search_division:
                data["search_division"] = search
            case .search_company:
                data["search_company"] = search
            case .search_project_manager:
                data["search_project_manager"] = search
            case .search_business_manager:
                data["search_business_manager"] = search
            case .search_model:
                data["search_model"] = search
            case .search_project:
                data["search_project"] = search
            case .search_state:
                data["search_state"] = search
            case .search_cost_code:
                data["search_cost_code"] = search
            }
            
            return data
        case .getBudgets(let model, let builder):
            return ["model":model,"builder":builder]
        case .getWarranty(let workOrderNumber):
            return ["work_order_number":workOrderNumber]
        default:
            return [ : ]
        }
        
    }
    
}
