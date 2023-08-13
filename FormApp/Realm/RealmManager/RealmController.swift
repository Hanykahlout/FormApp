//
//  RealmController.swift
//  FormApp
//
//  Created by Hany Alkahlout on 23/04/2023.
//

import UIKit


class RealmController{
    
    public static var shared: RealmController = {
        let generalActions = RealmController()
        return generalActions
    }()
    
    private init(){}
    
    func getFromDBModels(type:String,searchText:String)->[DataDetails]{
        let searchQuery = "AND title CONTAINS[c] '\(searchText)'"
        let predicate = NSPredicate(format: "type == %@ \(searchText != "" ? searchQuery : "")", type)
        guard let models = RealmManager.sharedInstance.fetchObjects(DataDetailsDBModel.self,predicate: predicate) else {return []}
        var result = [DataDetails]()
        for model in models {
            let id = model.id
            let api_id = model.api_id
            let title = model.title
            let email = model.email
            let company_id = model.company_id
            let created_at = model.created_at
            let project = model.project
            let cusomter = model.customer
            let is_fixture = model.is_fixture
            let users = Array(model.users)
            let form_status = model.form_status
            let obj = DataDetails(id: id, title: title, email: email, company_id: company_id, created_at: created_at,project:project,customer: cusomter,is_fixture: is_fixture,users: users,form_status: form_status,api_id:api_id)
            result.append(obj)
        }
        return result
    }
    
    
    func getFromDBModels(type:String,companyId:String,searchText:String)->[DataDetails]{
        var searchQuery = ""
        if type == "jobs"{
            searchQuery = "AND (api_id ENDSWITH[c] '\(searchText)' OR title CONTAINS[c] '\(searchText)')"
        }else{
            searchQuery = "AND title CONTAINS[c] '\(searchText)'"
        }
        
        let predicate = NSPredicate(format: "type == '\(type)' AND company_id == '\(companyId)' \(searchText != "" ? searchQuery : "")")
        
        guard let models = RealmManager.sharedInstance.fetchObjects(DataDetailsDBModel.self,predicate: predicate) else {return []}
        var result = [DataDetails]()
        for model in models {
            let id = model.id
            let api_id = model.api_id
            let title = model.title
            let email = model.email
            let company_id = model.company_id
            let created_at = model.created_at
            let customer = model.customer
            let project = model.project
            let is_fixture = model.is_fixture
            let users = Array(model.users)
            let form_status = model.form_status
            let obj = DataDetails(id: id, title: title, email: email, company_id: company_id, created_at: created_at,project:project,customer: customer,is_fixture: is_fixture,users: users,form_status: form_status,api_id:api_id)
            result.append(obj)
        }
        return result
    }
    
    func getSubContractorsDBModel(searchText:String)->[SubContractor]{

        var models = [SubContractorsDBModel]()
        if searchText == ""{
            models = RealmManager.sharedInstance.fetchObjects(SubContractorsDBModel.self) ?? []
        }else{
            let predicate = NSPredicate(format: "name CONTAINS[c] '\(searchText)'")
            models = RealmManager.sharedInstance.fetchObjects(SubContractorsDBModel.self,predicate: predicate) ?? []
        }
        var result = [SubContractor]()
        for model in models {
            let id = model.id
            let name = model.name
            let telephone = model.telephone
            let vendor = model.vendor
            let companyID = model.company_id
            let createdAt = model.created_at
            
            let obj = SubContractor(id: id, name: name, telephone: telephone, vendor: vendor, company_id: companyID,created_at:createdAt)
            result.append(obj)
        }
        return result
    }
    
    
    func getFromDBItemsModels(project:String,formTypeID:String)->[DataDetails] {
        let predicate1 = NSPredicate(format: "(form_type_id == '\(formTypeID)' AND development_title == null) OR (form_type_id == '\(formTypeID)' AND development_title == '\(project)' AND development_title != null)")
        
        guard let models = RealmManager.sharedInstance.fetchObjects(FormItemDBModel.self,predicate: predicate1) else {return []}
        var result = [DataDetails]()
        for model in models {
            let id = model.id
            let title = model.title
            let created_at = model.created_at
            let form_type_id = model.form_type_id
            let system = model.system
            let system_type = model.system_type
            let system_list = Array(model.system_list)
            let price = model.price ?? ""
            let show_price = model.show_price ?? ""
            let tag = model.tag
            let show_image = model.show_image
            let show_notes = model.show_notes
            let pin = model.pin
            let isBlocked = model.is_blocked
            
            let firstSide = SideData(
                type: model.side_by_side?.first_field?.type ?? "",
                title: model.side_by_side?.first_field?.title ?? "")
            
            let secondSide = SideData(
                type: model.side_by_side?.second_field?.type ?? "",
                title: model.side_by_side?.second_field?.title ?? "")
            
            let sideBySide = SideBySideData(first_field: firstSide,second_field: secondSide)
            
            var newBoxs:[NewBoxData] = []
            model.new_box.forEach{
                newBoxs.append(NewBoxData(title: $0.title,box_type: $0.box_type))
            }
            
            
            let obj = DataDetails(id: id, title: title, created_at: created_at,form_type_id: form_type_id,system: system,system_type: system_type,system_list: system_list,new_boxes: newBoxs,price: price,show_price: show_price,tag: tag,show_image: show_image,show_notes: show_notes,side_by_side: sideBySide,pin: pin,isBlocked: isBlocked)
            
            
            result.append(obj)
        }
        
        return result
    }
    
    
    func deleteFormFailReasons(id:Int){
        RealmManager.sharedInstance.removeWhere(column: "id", value: id, for: FormItemReason.self)
    }
    
    
    func deleteDataDetailsFromRealmDB(id:Int){
        RealmManager.sharedInstance.removeWhere(column: "id", value: id, for: DataDetailsDBModel.self)
    }
    
    
    func deleteFormItemRealmDB(id:Int){
        RealmManager.sharedInstance.removeWhere(column: "id", value: id, for: FormItemDBModel.self)
    }
    
    func deleteSubContractorDBModel(id:Int){
        RealmManager.sharedInstance.removeWhere(column: "id", value: id, for: SubContractorsDBModel.self)
    }
    
    
    func addToDBModels(models:[DataDetails],type:String){
        for model in models{
            let dbModel = DataDetailsDBModel()
            dbModel.id = model.id
            dbModel.api_id = model.api_id
            dbModel.title = model.title
            dbModel.email = model.email
            dbModel.company_id = model.company_id
            dbModel.created_at = model.created_at
            dbModel.type = type
            dbModel.project = model.project
            dbModel.customer = model.customer
            dbModel.is_fixture = model.is_fixture
            dbModel.users.append(objectsIn: model.users ?? [])
            dbModel.form_status = model.form_status
            
            RealmManager.sharedInstance.saveObject(dbModel)
        }
    }
    
    
    func addToFormItemDBModels(models:[DataDetails]){
        for model in models{
            let dbModel = FormItemDBModel()
            dbModel.id = model.id
            dbModel.title = model.title
            dbModel.created_at = model.created_at
            dbModel.form_type_id = model.form_type_id
            dbModel.system = model.system
            dbModel.system_type = model.system_type
            dbModel.system_list.append(objectsIn: model.system_list ?? [])
            dbModel.price = model.price
            dbModel.show_price = model.show_price
            dbModel.development_title = model.development_title
            dbModel.tag = model.tag
            dbModel.show_image = model.show_image
            dbModel.show_notes = model.show_notes
            dbModel.pin = model.pin
            dbModel.is_blocked = model.is_blocked
            // Add Side By Side Objects
            let sideBySideModel = SideBySideDBModel()
            
            let firstSideModel = SideDBModel()
            firstSideModel.title = model.side_by_side?.first_field?.title ?? ""
            firstSideModel.type = model.side_by_side?.first_field?.type ?? ""
            
            let secondSideModel = SideDBModel()
            secondSideModel.title = model.side_by_side?.second_field?.title ?? ""
            secondSideModel.type = model.side_by_side?.second_field?.type ?? ""
            
            sideBySideModel.first_field = firstSideModel
            sideBySideModel.second_field = secondSideModel
            
            dbModel.side_by_side = sideBySideModel
            
            // Add New Boxs Objects
            for new_box in model.new_boxes ?? []{
                let newBox = FormItemNewBox()
                newBox.title = new_box.title
                newBox.box_type = new_box.box_type
                dbModel.new_box.append(newBox)
            }
            RealmManager.sharedInstance.saveObject(dbModel)
        }
    }
    
    
    func addToSubContractorsDBModel(models:[SubContractor]){
        for model in models{
            let dbModel = SubContractorsDBModel()
            dbModel.id = model.id
            dbModel.name = model.name
            dbModel.telephone = model.telephone
            dbModel.vendor = model.vendor
            dbModel.company_id = model.company_id
            dbModel.created_at = model.created_at
            
            RealmManager.sharedInstance.saveObject(dbModel)
        }
    }
    
    
}
     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                




