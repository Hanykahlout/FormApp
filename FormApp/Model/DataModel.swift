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

struct RequestsStatus:Decodable{
    let company: Bool?
    let job: Bool?
    let form: Bool?
    let division: Bool?
    let formItem: Bool?
    init(company: Bool?, job: Bool?, form: Bool?, division: Bool?,formItem:Bool?) {
        self.company = company
        self.job = job
        self.form = form
        self.division = division
        self.formItem = formItem
    }
}

struct DataDetails:Codable{
    
    let id:Int?
    let title:String?
    let email:String?
    let company_id:String?
    let created_at:String?
    let form_type_id:String?
    var status: String?
    var note: String?
    
    
    
    init(id: Int?, title: String?, email: String?, company_id: String?, created_at: String?) {
        self.id = id
        self.title = title
        self.email = email
        self.company_id = company_id
        self.created_at = created_at
        self.form_type_id = ""
    }
    
    
    init(id: Int?, title: String?,created_at: String?,form_type_id:String?) {
        self.id = id
        self.title = title
        self.email = ""
        self.company_id = ""
        self.created_at = created_at
        self.form_type_id = form_type_id
    }
    
    
    init(id: Int?, title: String?,status: String?,note:String?) {
        self.id = id
        self.title = title
        self.status = status
        self.note = note
    
        self.email = ""
        self.company_id = ""
        self.created_at = ""
        self.form_type_id = ""
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
    let pass:String?
    let notes:String?
    let item:SubmittedFormItemData?
}

struct SubmittedFormItemData:Decodable{
    let id:Int?
    let title:String?
    let form_type_id:String?
    let created_at:String?
}

