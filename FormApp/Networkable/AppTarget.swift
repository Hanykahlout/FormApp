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
    case getCompanies
    case getJob(companyId:String,search:String)
    case forms
    case divisions
    case getFormItems(form_type_id:String)
    case logout
    case submitForms(formsDetails:[String : Any])
    case checkDatabase(uuid:String)
    case editSubmittedForm(submitted_form_id:String)
    case updateSubmittedForm(formsDetails:[String:Any])
    
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
        case .submitForms:return "submitForm"
        case .checkDatabase:return "checkDatabase"
        case .editSubmittedForm:return "editSubmittedForm"
        case .updateSubmittedForm:return "updateSubmittedForm"
        }
    }
    var method: Moya.Method {
        switch self{
        case .SignUp,.login,.logout,.submitForms,.updateSubmittedForm:
            return .post
        case .getCompanies,.getJob,.forms,.divisions,.getFormItems,.checkDatabase,.editSubmittedForm:
            return .get
       
        }
    }
    
    var task: Task{
        switch self{
        case .getCompanies,.forms,.divisions:
            return .requestPlain
        case .SignUp,.login,.logout,.submitForms,.updateSubmittedForm:
            return .requestParameters(parameters: param, encoding: URLEncoding.httpBody)
        case .getJob,.getFormItems,.editSubmittedForm,.checkDatabase:
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)

        }
    }
    
    
    var headers: [String : String]?{
        switch self{
        case .getCompanies,.getJob,.forms,.divisions,.getFormItems,.logout,.submitForms,.checkDatabase,.editSubmittedForm,.updateSubmittedForm:
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
        case .getJob(let companyId,let search):
            return ["company_id":companyId,"search":search]
        case .getFormItems(let form_type_id):
            return ["form_type_id":form_type_id]
        case .submitForms(let formsDetails):
            return formsDetails
        case .editSubmittedForm(let submitted_form_id):
            return ["submitted_form_id": submitted_form_id]
        case .updateSubmittedForm(let formsDetails):
            return formsDetails
        case .checkDatabase(let uuid):
            return ["uuid":uuid]
        default:
            return [ : ]
        }
        
    }
    
}
