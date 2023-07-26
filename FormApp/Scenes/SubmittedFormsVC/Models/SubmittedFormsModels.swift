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
    let fixtureForms:[FormInfo]
    let drafts:[FormInfo]
    
}


struct FormInfo:Decodable{
    
    var id:Int?
    var user_id:String?
    var company_id:String?
    var job_id:String?
    var division_id:String?
    var form_type_id:String?
    var created_at:String?
    var updated_at:String?
    var company:DataDetails?
    var job:DataDetails?
    var division:DataDetails?
    var form:DataDetails?
    var sub_contractor:SubContractor?
    var items:[SubmittedFormItems]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case company_id
        case job_id
        case division_id
        case form_type_id
        case created_at
        case updated_at
        case company
        case job
        case division
        case form
        case items
        case sub_contractor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        
        if let value = try? container.decode(Int.self, forKey:.id) {
            id = value
        }
        
        if let value = try? container.decode(SubContractor.self, forKey:.sub_contractor) {
            sub_contractor = value
        }
        
        if let value = try? container.decode(String.self, forKey:.user_id) {
            user_id = value
        } else if let value = try? container.decode(Int.self, forKey:.user_id) {
            user_id = String(value)
        }
        
        if let value = try? container.decode(String.self, forKey:.company_id) {
            company_id = value
        }else  if let value = try? container.decode(Int.self, forKey:.company_id) {
            company_id = String(value)
        }
        
        if let value = try? container.decode(String.self, forKey:.job_id) {
            job_id = value
        }else  if let value = try? container.decode(Int.self, forKey:.job_id) {
            job_id = String(value)
        }
        
        if let value = try? container.decode(String.self, forKey:.division_id) {
            division_id = value
        }else  if let value = try? container.decode(Int.self, forKey:.division_id) {
            division_id = String(value)
        }
        
        if let value = try? container.decode(String.self, forKey:.form_type_id) {
            form_type_id = value
        }else  if let value = try? container.decode(Int.self, forKey:.form_type_id) {
            form_type_id = String(value)
        }
        
        if let value = try? container.decode(String.self, forKey:.created_at) {
            created_at = value
        }
        
        if let value = try? container.decode(String.self, forKey:.updated_at) {
            updated_at = value
        }
        
        if let value = try? container.decode(DataDetails.self, forKey:.company) {
            company = value
        }
        
        if let value = try? container.decode(DataDetails.self, forKey:.job) {
            job = value
        }
        
        if let value = try? container.decode(DataDetails.self, forKey:.division) {
            division = value
        }
        
        if let value = try? container.decode(DataDetails.self, forKey:.form) {
            form = value
        }

        if let value = try? container.decode([SubmittedFormItems].self, forKey:.items) {
            items = value
        }
    }
}


struct SubmittedFormItems:Decodable{
    var id:Int?
    var form_id:String?
    var item_id:Int?
    var name:String?
    var value:String?
    var price:String?
    var image:String?
    var withPrice:String?
    var new_item_type:NewFormItemType? = .text
    var notes:String?
    var new_boxes:[SubmitedNewBoxData]?
    var item:SubmittedFormItemData?
    var fail_reason:FailReasonData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case form_id
        case item_id
        case name
        case value
        case price
        case withPrice
        case new_item_type
        case notes
        case new_boxes
        case item
        case fail_reason
        case image

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decode(Int.self, forKey:.id) {
            id = value
        }

        if let value = try? container.decode(String.self, forKey:.form_id) {
            form_id = value
        }
        
        if let value = try? container.decode(Int.self, forKey:.item_id) {
            item_id = value
        }
        
        if let value = try? container.decode(String.self, forKey:.name) {
            name = value
        }
        
        if let _value = try? container.decode(String.self, forKey:.value) {
            value = _value
        }
        
        if let value = try? container.decode(String.self, forKey:.price) {
            price = value
        }
        
        if let value = try? container.decode(String.self, forKey:.withPrice) {
            withPrice = value
        }
        
        if let value = try? container.decode(String.self, forKey:.notes) {
            notes = value
        }
        
        if let value = try? container.decode(NewFormItemType.self, forKey:.new_item_type) {
            new_item_type = value
        }
        
        if let value = try? container.decode([SubmitedNewBoxData].self, forKey:.new_boxes) {
            new_boxes = value
        }
        
        if let value = try? container.decode(SubmittedFormItemData.self, forKey:.item) {
            item = value
        }
        
        if let value = try? container.decode(FailReasonData.self, forKey:.fail_reason) {
            fail_reason = value
        }
        if let value = try? container.decode(String.self, forKey:.image) {
            image = value
        }
    }
    
}

struct SubmittedFormItemData:Decodable{
    
    var id:Int?
    var title:String?
    var system:String?
    var system_type:String?
    var system_list:[String]?
    var price:String?
    var show_price:String?
    var value:String?
    var form_type_id:String?
    var created_at:String?
    var fail_reason_id: String?
    var fail_reasons:[FailReasonData]?
    var tag:String?
    var pin:String?
    var show_image:Int?
    var show_notes:Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case system
        case system_type
        case system_list
        case price
        case show_price
        case value
        case form_type_id
        case created_at
        case fail_reason_id
        case fail_reasons
        case tag
        case pin
        case show_image
        case show_notes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decode(Int.self, forKey: .id){
            id = value
        }
        
        if let value = try? container.decode(String.self, forKey:.tag) {
            tag = value
        }
        
        if let value = try? container.decode(String.self, forKey:.pin) {
            pin = value
        }
         
        if let value = try? container.decode(Int.self, forKey:.show_image) {
            show_image = value
        }
         
        if let value = try? container.decode(Int.self, forKey:.show_notes) {
            show_notes = value
        }
        
        if let value = try? container.decode(String.self, forKey: .title){
            title = value
        }
        
        if let value = try? container.decode(String.self, forKey: .system){
            system = value
        }
        
        if let value = try? container.decode(String.self, forKey: .system_type){
            system_type = value
        }
        
        if let value = try? container.decode([String].self, forKey: .system_list){
            system_list = value
        }
        
        if let value = try? container.decode(String.self, forKey: .price){
            price = value
        }
        
        if let value = try? container.decode(String.self, forKey: .show_price){
            show_price = value
        }
        
        if let _value = try? container.decode(String.self, forKey: .value){
            value = _value
        }
        
        if let value = try? container.decode(String.self, forKey: .form_type_id){
            form_type_id = value
        }
        
        if let value = try? container.decode(String.self, forKey: .created_at){
            created_at = value
        }
        
        if let value = try? container.decode(String.self, forKey: .fail_reason_id){
            fail_reason_id = value
        }
        
        if let value = try? container.decode([FailReasonData].self, forKey: .fail_reasons){
            fail_reasons = value
        }
        
    }
    
    
}

struct SubmitedNewBoxData:Decodable{
    var type:String?
    var title:String?
    var value:String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        if let value = try? container.decode(String.self, forKey:.type) {
            type = value
        }
        
        if let value = try? container.decode(String.self, forKey:.title) {
            title = value
        }
        
        if let _value = try? container.decode(String.self, forKey:.value) {
            value = _value
        }
        
    }
    
    
}
