//
//  AppTarget.swift
//  FormApp
//
//  Created by heba isaa on 18/02/2023.
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
    case getFormItems(form_type_id:String)
    case logout
    case submitForms(isEdit:Bool,formsDetails:[String : Any])
    case checkDatabase(uuid:String)
    case editSubmittedForm(submitted_form_id:String)
    case submittedForms(search:String)
    
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
        case .logout:return "logout"
        case .submitForms(let isEdit,_): return isEdit ? "updateSubmittedForm" : "submitForm"
        case .checkDatabase:return "checkDatabase"
        case .editSubmittedForm:return "editSubmittedForm"
        case .submittedForms:return "submittedForms"
        }
    }
    var method: Moya.Method {
        switch self{
        case .SignUp,.login,.logout,.submitForms:
            return .post
        case .getCompanies,.getJob,.forms,.divisions,.getFormItems,.checkDatabase,.editSubmittedForm,.submittedForms:
            return .get
       
        }
    }
    
    var task: Task{
        switch self{
        case .getCompanies(let normal,_),.forms(let normal,_),.divisions(let normal,_):
            if normal == 1{
                return .requestPlain
            }
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .SignUp,.login,.logout,.submitForms:
            return .requestParameters(parameters: param, encoding: URLEncoding.httpBody)
        case .getJob,.getFormItems,.editSubmittedForm,.checkDatabase,.submittedForms:
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)

        }
    }
    
    
    var headers: [String : String]?{
        switch self{
        case .submittedForms,.getCompanies,.getJob,
             .forms,.divisions,.getFormItems,.logout,
             .submitForms,.checkDatabase,.editSubmittedForm:
            
            do {
                let token = try KeychainWrapper.get(key: AppData.email) ?? ""
                return ["Authorization":token ,"Accept":"application/json","Accept-Language":"en"]
            }
            catch{
                return ["Accept":"application/json","Accept-Language":"en"]
            }
        case .SignUp,.login:
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
        case .getCompanies(let normal,let uuid),.forms(let normal,let uuid),.divisions(let normal,let uuid):
            if normal == 1{
                return [:]
            }
            return ["normal":normal,"uuid":uuid]
        case .getFormItems(let form_type_id):
            return ["form_type_id":form_type_id]
        case .submitForms(_,let formsDetails):
            return formsDetails
        case .editSubmittedForm(let submitted_form_id):
            return ["submitted_form_id": submitted_form_id]
 
        case .checkDatabase(let uuid):
            return ["uuid":uuid]
        case .submittedForms(let search):
            return ["search":search]
        default:
            return [ : ]
        }
        
    }
    
}
