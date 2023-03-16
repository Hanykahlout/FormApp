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
    init(companies: [DataDetails]) {
        self.companies = companies
    }
}
struct JobData:Decodable{
    let jobs:[DataDetails]
    init(jobs: [DataDetails]) {
        self.jobs = jobs
    }
}
struct FormsData:Decodable{
    let forms:[DataDetails]
    init(forms: [DataDetails]) {
        self.forms = forms
    }
}

struct DiviosnData:Decodable{
    let divisions:[DataDetails]
    init(divisions: [DataDetails]) {
        self.divisions = divisions
    }
}

struct FormItemData:Decodable{
    let form_items:[DataDetails]
    init(form_items: [DataDetails]) {
        self.form_items = form_items
    }
}

struct RequestsStatus:Decodable{
    let company: Bool?
    let job: Bool?
    let form: Bool?
    let division: Bool?
    init(company: Bool?, job: Bool?, form: Bool?, division: Bool?) {
        self.company = company
        self.job = job
        self.form = form
        self.division = division
    }
}

struct DataDetails:Codable{
    
    let id:Int?
    let title:String?
    let email:String?
    let company_id:String?
    let created_at:String?
    var status: String?
    var note: String?
    
    init(id: Int?, title: String?, email: String?, company_id: String?, created_at: String?) {
        self.id = id
        self.title = title
        self.email = email
        self.company_id = company_id
        self.created_at = created_at
    }
    
    
    init(id: Int?, title: String?,created_at: String?) {
        self.id = id
        self.title = title
        self.email = ""
        self.company_id = ""
        self.created_at = created_at
    }
    
}



