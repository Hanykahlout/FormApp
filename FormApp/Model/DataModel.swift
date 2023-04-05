//
//  DataModel.swift
//  FormApp
//
//  Created by heba isaa on 18/02/2023.
//

import Foundation

struct User:Decodable{
    
    let fname:String?
    let lname:String?
    let email:String?
    let status:String?
    let api_token:String?
    let id:Int?
    
}
struct Empty:Decodable{}

struct CompaniesData:Decodable{
    
    let companies:[DataDetails]
    let deletedCompanies:[DataDetails]
    
    init(companies: [DataDetails],deletedCompanies:[DataDetails] = []) {
        self.companies = companies
        self.deletedCompanies = deletedCompanies
    }
}

struct JobData:Decodable{
    let jobs:[DataDetails]
    let deletedJobs:[DataDetails]
    init(jobs: [DataDetails],deletedJobs:[DataDetails] = []) {
        self.jobs = jobs
        self.deletedJobs = deletedJobs
    }
}

struct FormsData:Decodable{
    let forms:[DataDetails]
    let deletedForms:[DataDetails]
    
    init(forms: [DataDetails],deletedForms:[DataDetails] = []) {
        self.forms = forms
        self.deletedForms = deletedForms
    }
}

struct DiviosnData:Decodable{
    let divisions:[DataDetails]
    let deletedDivisions:[DataDetails]
    init(divisions: [DataDetails],deletedDivisions:[DataDetails] = []) {
        self.divisions = divisions
        self.deletedDivisions = deletedDivisions
    }
}

struct FormItemData:Decodable{
    let formItems:[DataDetails]
    let deletedFormItems:[DataDetails]
    init(formItems: [DataDetails],deletedFormItems:[DataDetails] = []) {
        self.formItems = formItems
        self.deletedFormItems = deletedFormItems
    }
}

struct FormItemReasons:Decodable{
    let failReasons:[FailReasonData]
    let deletedFailReason:[FailReasonData]
    init(failReasons: [FailReasonData],deletedFailReason:[FailReasonData] = []) {
        self.failReasons = failReasons
        self.deletedFailReason = deletedFailReason
    }
}

struct RequestsStatus:Decodable{
    let company: Bool?
    let job: Bool?
    let form: Bool?
    let division: Bool?
    let formItem: Bool?
    let failReason: Bool?
    
    init(company: Bool?, job: Bool?, form: Bool?, division: Bool?,formItem:Bool?,failReason:Bool?) {
        self.company = company
        self.job = job
        self.form = form
        self.division = division
        self.formItem = formItem
        self.failReason = failReason
    }
    
}

struct DataDetails:Decodable{
    
    var id:Int?
    var title:String?
    var email:String?
    var company_id:String?
    var created_at:String?
    var form_type_id:String?
    var status: String?
    var reason: String?
    var reason_id: Int?
    var note: String?
    var project:String?
    var system:String?
    var development_title:String?
    var fail_reasons: [FailReasonData]?
    
    init(id: Int?, title: String?, email: String?, company_id: String?, created_at: String?) {
        self.id = id
        self.title = title
        self.email = email
        self.company_id = company_id
        self.created_at = created_at
    }
     
    
    init(id: Int?, title: String?,created_at: String?,form_type_id:String?,system:String?,fail_reasons:[FailReasonData]) {
        self.id = id
        self.title = title
        self.created_at = created_at
        self.form_type_id = form_type_id
        self.system = system
        self.fail_reasons = fail_reasons
    }
    
    
    init(id: Int?, title: String?,status: String?,note:String?,
         system:String?,reasons:[FailReasonData]?,reason_id:Int?,reason:String?) {
        self.id = id
        self.title = title
        self.status = status
        self.note = note
        self.system = system
        self.reason_id = reason_id
        self.reason = reason
        self.fail_reasons = reasons
    }
}



struct SubmittedFormData:Decodable{
    let passForms:[FormInfo]
    let failForms:[FormInfo]
    
}


struct FormInfo:Decodable{
    
    let id:Int?
    let user_id:String?
    let company_id:String?
    let job_id:String?
    let division_id:String?
    let form_type_id:String?
    let created_at:String?
    let updated_at:String?
    let company:DataDetails?
    let job:DataDetails?
    let division:DataDetails?
    let form:DataDetails?
    let items:[SubmittedFormItems]?
}


struct SubmittedFormItems:Decodable{
    let id:Int?
    let form_id:String?
    let item_id:String?
    let value:String?
    let notes:String?
    let item:SubmittedFormItemData?
    let fail_reason:FailReasonData?
}

struct SubmittedFormItemData:Decodable{
    let id:Int?
    let title:String?
    let system:String?
    let form_type_id:String?
    let created_at:String?
    let fail_reason_id: String?
    let fail_reasons:[FailReasonData]?
}

struct FailReasonData:Decodable{
    let id:Int?
    let title:String?
    let form_item_id:String?
    let created_at:String?
}


