//
//  SubmittedFormsModels.swift
//  FormApp
//
//  Created by Hany Alkahlout on 21/04/2023.
//

import Foundation

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

