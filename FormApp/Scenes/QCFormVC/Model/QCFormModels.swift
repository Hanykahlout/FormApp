//
//  QCFormModels.swift
//  FormApp
//
//  Created by Hany Alkahlout on 21/04/2023.
//

import Foundation

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

struct FailReasonData:Decodable{
    let id:Int?
    let title:String?
    let form_item_id:String?
    let created_at:String?
}

struct NewBoxData:Decodable{
    var title:String?
    var box_type:String?
    
}

struct DataDetails:Decodable{
    
    var id:Int?
    var title:String?
    var name:String?
    var email:String?
    var company_id:String?
    var created_at:String?
    var form_type_id:String?
    var price:String?
    var show_price:String?
    var status: String?
    var reason: String?
    var reason_id: Int?
    var note: String?
    var project:String?
    var customer:String?
    var system:String?
    var system_type:String?
    var isFromUser:Bool? = false
    var development_title:String?
    var new_boxes:[NewBoxData]?
    var system_list:[String]?
    var fail_reasons: [FailReasonData]?
    var new_item_type:NewFormItemType? = .text
    var isWithPrice:Bool? = false
    
    init(name:String,status:String,new_item_type:NewFormItemType,isFromUser:Bool,isWithPrice:Bool?,price:String?){
        self.name = name
        self.status = status
        self.new_item_type = new_item_type
        self.isFromUser = isFromUser
        self.isWithPrice = isWithPrice
        self.price = price
    }
    
    init(id: Int?, title: String?, email: String?, company_id: String?, created_at: String?,project:String?,customer:String?) {
        self.id = id
        self.title = title
        self.email = email
        self.company_id = company_id
        self.created_at = created_at
        self.project = project
        self.customer = customer
    }
    
    
    init(id: Int?, title: String?,created_at: String?,form_type_id:String?,system:String?,system_type:String?,system_list:[String]?,fail_reasons:[FailReasonData],new_boxes:[NewBoxData],price:String?,show_price:String?) {
        self.id = id
        self.title = title
        self.created_at = created_at
        self.form_type_id = form_type_id
        self.system = system
        self.fail_reasons = fail_reasons
        self.new_boxes = new_boxes
        self.price = price
        self.show_price = show_price
        self.system_type = system_type
        self.system_list = system_list
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
    
    init(id:Int?,value:String?,title:String?,status:String?,price:String?,show_price:String?,system:String?,system_type:String?,system_list:[String]?){
        
        self.id = id
        self.title = title
        self.status = status
        self.system_type = system_type
        self.system_list = system_list
        self.system = system
        self.price = price
        self.show_price = show_price
        self.status = value
    }
  
}

struct PhasesBuilders:Decodable{
    var phase:[String]
    var builders:[String]
    var communities:[String]
    var suppliers:[Supplier]
}

struct MaterialsData:Decodable{
    var materials:[Material]
}

struct Material:Decodable{
   var id:Int?
   var item_no:String?
   var name:String?
   var builder:String?
   var community:String?
   var model_type:String?
   var phase:String?
   var special:String?
   var quantity:String?
   var supplier:Supplier?

}

struct Supplier:Decodable{
    var id:Int?
    var name:String?
}

struct SpecialList:Decodable{
    var special:[String]
    
}
