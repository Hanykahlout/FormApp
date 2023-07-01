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
    case getCompanies(normal:Int,uuid:String)
    case getJob(normal:Int,uuid:String,companyId:String,search:String)
    case forms(normal:Int,uuid:String)
    case divisions(normal:Int,uuid:String)
    case subContractors(normal:Int,uuid:String)
    case getFormItems(normal:Int,uuid:String,form_type_id:String)
    case logout
    case submitForms(isEdit:Bool,formsDetails:[String : Any])
    case checkDatabase(uuid:String)
    case editSubmittedForm(submitted_form_id:String)
    case submittedForms(search:String)
    case formItemReasons(normal:Int,uuid:String)
    case getLists
    case getSpecialList(job_id:String,builder:String)
    case getHouseMaterials(company_id:Int,job_id:Int,phase:String,special:String)
    case createHouseMaterial(isEdit:Bool,houseMaterialData:[String:Any])
    case version
    case changeVersion(uuid:String,checkDatabase:Bool,model:String)
    
    var baseURL: URL {
        return URL(string: "\(AppConfig.apiBaseUrl)")!
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
        case .submitForms(let isEdit,_): return isEdit ? "updateSubmittedForm" : "submitForm"
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
        }
    }

    
    var method: Moya.Method {
        switch self{
        case .SignUp,.login,.logout,.submitForms,.createHouseMaterial,.changeVersion:
            return .post
        case .getCompanies,.getJob,.forms,.divisions,.getFormItems,.subContractors,.checkDatabase,.editSubmittedForm,.submittedForms,.formItemReasons,.getLists,.getHouseMaterials,.getSpecialList,.version:
            return .get
        }
    }
    
    
    var task: Task{
        switch self{
        case .getLists,.version:
            return .requestPlain
        case .getCompanies(let normal,_),.forms(let normal,_),.divisions(let normal,_),.formItemReasons(let normal,_),.subContractors(let normal,_):
            if normal == 1{
                return .requestPlain
            }
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .SignUp,.login,.logout,.createHouseMaterial,.changeVersion:
            return .requestParameters(parameters: param, encoding: URLEncoding.httpBody)
        case .getJob,.getFormItems,.editSubmittedForm,.checkDatabase,.submittedForms,.getHouseMaterials,.getSpecialList:
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .submitForms(_, let formsDetails):
            var formData: [MultipartFormData] = []
            do{
                for (key,value) in formsDetails{
                    if key.contains("image"){
                        if (value as? String)?.hasPrefix("file:") ?? false{
                            let url = URL(string: value as! String)!
                            let imageData = try Data(contentsOf: url)
                            
                            formData.append(MultipartFormData(provider: .data(imageData), name: key, fileName: "\(Date.init().timeIntervalSince1970).\(url.pathExtension)", mimeType: url.mimeType()))
                        }
                    }else{
                        formData.append(MultipartFormData(provider: .data((value as! String).data(using: .utf8) ?? Data()), name: key))
                    }
                }
            }catch{

            }
            return .uploadMultipart(formData)
        }
        
    }
    
    
    var headers: [String : String]?{
        switch self{
        case .submittedForms,.getCompanies,.getJob,
                .forms,.divisions,.getFormItems,.subContractors,.logout,
                .submitForms,.checkDatabase,.editSubmittedForm,
                .formItemReasons,.getLists,.getHouseMaterials,.createHouseMaterial,.getSpecialList:
            do {
                let token = try KeychainWrapper.get(key: AppData.email) ?? ""
                return ["Authorization":token ,"Accept":"application/json","Accept-Language":"en"]
            }
            catch{
                return ["Accept":"application/json","Accept-Language":"en"]
            }
        case .SignUp,.login,.version,.changeVersion:
            return ["Accept":"application/json","Accept-Language":"en"]
        }
    }
    
    
    var param: [String : Any]{
        switch self {
        case .SignUp(let fname,let lname,let email,let password):
            return ["fname":fname,"lname":lname,"email":email,"password":password]
        case .login(let email,let password):
            return ["email":email,"password":password]
        case .getJob(let normal,let uuid,let companyId,let search):
            if normal == 1{
                return ["company_id":companyId,"search":search]
            }
            return ["normal":normal,"uuid":uuid,"company_id":companyId,"search":search]
        case .getCompanies(let normal,let uuid),.forms(let normal,let uuid),.divisions(let normal,let uuid),.formItemReasons(let normal,let uuid),.subContractors(let normal,let uuid):
            if normal == 1{
                return [:]
            }
            return ["normal":normal,"uuid":uuid]
        case .getFormItems(let normal,let uuid,let form_type_id):
            if normal == 1{
                return ["form_type_id":form_type_id]
            }
            return ["normal":normal,"uuid":uuid,"form_type_id":form_type_id]
        case .editSubmittedForm(let submitted_form_id):
            return ["submitted_form_id": submitted_form_id]
        case .checkDatabase(let uuid):
            return ["uuid":uuid]
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
        default:
            return [ : ]
        }
        
    }
    
    
    
}
