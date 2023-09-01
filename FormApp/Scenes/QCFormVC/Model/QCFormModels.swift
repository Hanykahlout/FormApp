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
    let total_pages:Int?
    let deletedJobs:[DataDetails]
    init(jobs: [DataDetails],deletedJobs:[DataDetails] = [],total_pages:Int?) {
        self.jobs = jobs
        self.deletedJobs = deletedJobs
        self.total_pages = total_pages
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
    var id:Int?
    var title:String?
    var form_item_id:String?
    var created_at:String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case form_item_id
        case created_at
    }
    
    init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        
        if let value = try? container?.decode(Int.self, forKey:.id) {
            id = value
        }
        
        if let value = try? container?.decode(String.self, forKey:.title) {
            title = value
        }
        
        if let value = try? container?.decode(String.self, forKey:.form_item_id) {
            form_item_id = value
        } else if let value = try? container?.decode(Int.self, forKey:.form_item_id) {
            form_item_id = String(value)
        }
        
        if let value = try? container?.decode(String.self, forKey:.created_at) {
            created_at = value
        }
        
        
    }
    
    init(id:Int?,title:String?,form_item_id:String?,created_at:String?) {
        self.id = id
        self.title = title
        self.form_item_id = form_item_id
        self.created_at = created_at
    }
    
}

struct NewBoxData:Decodable{
    var title:String?
    var box_type:String?
    var value:String?
    
    init(title:String?,box_type:String?,value:String?) {
        self.title = title
        self.box_type = box_type
        self.value = title
    }
    
    init(title:String?,box_type:String?) {
        self.title = title
        self.box_type = box_type
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case box_type
        case value
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decode(String.self, forKey:.title) {
            title = value
        }
        
        if let value = try? container.decode(String.self, forKey:.box_type) {
            box_type = value
        }
        
        if let _value = try? container.decode(String.self, forKey:.value) {
            value = _value
        }
    }
}

struct DataDetails:Decodable{
    
    var id:Int?
    var api_id:String?
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
    var is_fixture: Int?
    var users:[String]?
    var form_status:String?
    var tag:String?
    var show_image:Int?
    var show_notes:Int?
    var side_by_side:SideBySideData?
    var pin:String?
    var is_blocked:Int?
    
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
    var isWithPic:Bool? = false
    var image:String? = ""
    
    init(name:String,status:String,new_item_type:NewFormItemType,isFromUser:Bool,isWithPrice:Bool?,price:String?,image:String?,isWithPic:Bool?,tag:String?){
        self.name = name
        self.status = status
        self.new_item_type = new_item_type
        self.isFromUser = isFromUser
        self.isWithPrice = isWithPrice
        self.price = price
        self.image = image
        self.isWithPic = isWithPic
        self.tag = tag
    }
    
    init(id: Int?, title: String?, email: String?, company_id: String?, created_at: String?,project:String?,customer:String?,is_fixture:Int?,users:[String]?,form_status:String?,api_id:String?) {
        self.id = id
        self.api_id = api_id
        self.title = title
        self.email = email
        self.company_id = company_id
        self.created_at = created_at
        self.project = project
        self.customer = customer
        self.is_fixture = is_fixture
        self.users = users
        self.form_status = form_status
        
    }
    
    
    init(id: Int?, title: String?,created_at: String?,form_type_id:String?,system:String?,system_type:String?,system_list:[String]?,new_boxes:[NewBoxData],price:String?,show_price:String?,tag:String?,show_image:Int?,show_notes:Int?,side_by_side:SideBySideData?,pin:String?,isBlocked:Int?) {
        self.id = id
        self.title = title
        self.created_at = created_at
        self.form_type_id = form_type_id
        self.system = system

        self.new_boxes = new_boxes
        self.price = price
        self.show_price = show_price
        self.system_type = system_type
        self.system_list = system_list
        self.tag = tag
        self.pin = pin
        self.show_notes = show_notes
        self.show_image = show_image
        self.side_by_side = side_by_side
        self.is_blocked = isBlocked
    }
    
    
    init(id: Int?, title: String?,status: String?,note:String?,
         system:String?,reasons:[FailReasonData]?,reason_id:Int?,reason:String?,new_boxes:[NewBoxData],image:String?,isWithPic:Bool,price:String?,show_price:String?,show_image:Int?,show_notes:Int?,tag:String?,pin:String?,is_blocked:Int?) {
        self.id = id
        self.title = title
        self.status = status
        self.note = note
        self.system = system
        self.reason_id = reason_id
        self.reason = reason
        self.fail_reasons = reasons
        self.new_boxes = new_boxes
        self.image = image
        self.isWithPic = isWithPic
        self.price = price
        self.show_price = show_price
        self.show_image = show_image
        self.show_notes = show_notes
        self.tag = tag
        self.pin = pin
        self.is_blocked = is_blocked
    }
    
    init(id:Int?,value:String?,title:String?,status:String?,price:String?,show_price:String?,system:String?,system_type:String?,system_list:[String]?,image:String?,isWithPic:Bool?,show_image:Int?,show_notes:Int?,tag:String?,pin:String?,is_blocked:Int?){
        
        self.id = id
        self.title = title
        self.status = status
        self.system_type = system_type
        self.system_list = system_list
        self.system = system
        self.price = price
        self.show_price = show_price
        self.status = value
        self.image = image
        self.isWithPic = isWithPic
        self.show_image = show_image
        self.show_notes = show_notes
        self.tag = tag
        self.pin = pin
        self.is_blocked = is_blocked
    }
    
    init(id:Int?,sideBySide:SideBySideData,tag:String?,pin:String?,is_blocked:Int?) {
        self.id = id
        self.side_by_side = sideBySide
        self.system = "side-by-side"
        self.tag = tag
        self.pin = pin
        self.is_blocked = is_blocked
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case email
        case company_id
        case created_at
        case form_type_id
        case price
        case show_price
        case status
        case reason
        case reason_id
        case note
        case project
        case customer
        case system
        case system_type
        case isFromUser
        case development_title
        case new_boxes
        case system_list
        case fail_reasons
        case new_item_type
        case isWithPrice
        case is_fixture
        case users
        case form_status
        case tag
        case show_image
        case show_notes
        case pin
        case is_blocked
        case side_by_side
        case api_id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        if let value = try? container.decode(Int.self, forKey:.id) {
            id = value
        }
        
        if let value = try? container.decode(Int.self, forKey:.is_blocked) {
            is_blocked = value
        }

        if let value = try? container.decode(String.self, forKey:.api_id) {
            api_id = value
        }
        
        if let value = try? container.decode([String].self, forKey:.users) {
            users = value
        }
        
        if let value = try? container.decode(SideBySideData.self, forKey:.side_by_side) {
            side_by_side = value
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
        
        if let value = try? container.decode(String.self, forKey:.form_status) {
            form_status = value
        }
        
        if let value = try? container.decode(String.self, forKey:.title) {
            title = value
        }
        if let value = try? container.decode(String.self, forKey:.name) {
            name = value
        }
        if let value = try? container.decode(String.self, forKey:.email) {
            email = value
        }
        if let value = try? container.decode(String.self, forKey:.company_id) {
            company_id = value
        } else if let value = try? container.decode(Int.self, forKey:.company_id) {
            company_id = String(value)
        }
        if let value = try? container.decode(String.self, forKey:.created_at) {
            created_at = value
        }
        
        if let value = try? container.decode(String.self, forKey:.form_type_id) {
            form_type_id = value
        }else if let value = try? container.decode(Int.self, forKey:.form_type_id) {
            form_type_id = String(value)
        }
            
        
        if let value = try? container.decode(String.self, forKey:.price) {
            price = value
        }
        
        if let value = try? container.decode(Int.self, forKey:.is_fixture) {
            is_fixture = value
        }
        if let value = try? container.decode(String.self, forKey:.show_price) {
            show_price = value
        }
        if let value = try? container.decode(String.self, forKey:.status) {
            status = value
        }
        if let value = try? container.decode(String.self, forKey:.reason) {
            reason = value
        }
        
        if let value = try? container.decode(Int.self, forKey:.reason_id) {
            reason_id = value
        }
        
        if let value = try? container.decode(String.self, forKey:.note) {
            note = value
        }
        if let value = try? container.decode(String.self, forKey:.project) {
            project = value
        }
        if let value = try? container.decode(String.self, forKey:.customer) {
            customer = value
        }
        if let value = try? container.decode(String.self, forKey:.system) {
            system = value
        }
        if let value = try? container.decode(String.self, forKey:.system_type) {
            system_type = value
        }
        
        
        if let value = try? container.decode(Bool.self, forKey:.isFromUser) {
            isFromUser = value
        }
        
        
        if let value = try? container.decode(String.self, forKey:.development_title) {
            development_title = value
        }
        
        if let value = try? container.decode([NewBoxData].self, forKey:.new_boxes) {
            new_boxes = value
        }
        
        if let value = try? container.decode([String].self, forKey:.system_list) {
            system_list = value
        }
        
        if let value = try? container.decode([FailReasonData].self, forKey:.fail_reasons) {
            fail_reasons = value
        }
        
        if let value = try? container.decode(NewFormItemType.self, forKey:.new_item_type) {
            new_item_type = value
        }
        
        if let value = try? container.decode(Bool.self, forKey:.isWithPrice) {
            isWithPrice = value
        }
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

// MARK: - SubContractorsResponse
struct SubContractorsResponse: Codable {
    let subContractors: [SubContractor]?
    let deletedSubContractors: [SubContractor]?
    
    init(subContractors: [SubContractor]?, deletedSubContractors: [SubContractor]? = []) {
        self.subContractors = subContractors
        self.deletedSubContractors = deletedSubContractors
    }
    
}

// MARK: - SubContractor
struct SubContractor: Codable {
    let id: Int?
    let name: String?
    let telephone: String?
    let vendor: String?
    let company_id: Int?
    var created_at: String?

    enum CodingKeys: String, CodingKey {
        case id, name, telephone, vendor
        case company_id
        case created_at
    }
    
    init(id: Int?, name: String?, telephone: String?, vendor: String?, company_id: Int?, created_at: String? = nil) {
        self.id = id
        self.name = name
        self.telephone = telephone
        self.vendor = vendor
        self.company_id = company_id
        self.created_at = created_at
    }
    
}

struct SideBySideData:Codable{
    var first_field:SideData?
    var second_field:SideData?
}

struct SideData:Codable{
    var type:String?
    var title:String?
    var value:String?
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
