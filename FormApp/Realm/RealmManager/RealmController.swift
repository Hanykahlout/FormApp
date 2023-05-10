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
            let title = model.title
            let email = model.email
            let company_id = model.company_id
            let created_at = model.created_at
            let project = model.project
            let cusomter = model.customer
            let obj = DataDetails(id: id, title: title, email: email, company_id: company_id, created_at: created_at,project:project,customer: cusomter)
            result.append(obj)
        }
        return result
    }
    
    
    func getFromDBModels(type:String,companyId:String,searchText:String)->[DataDetails]{
        let searchQuery = "AND title CONTAINS[c] '\(searchText)'"
        let predicate = NSPredicate(format: "type == '\(type)' AND company_id == '\(companyId)' \(searchText != "" ? searchQuery : "")")
        
        guard let models = RealmManager.sharedInstance.fetchObjects(DataDetailsDBModel.self,predicate: predicate) else {return []}
        var result = [DataDetails]()
        for model in models {
            let id = model.id
            let title = model.title
            let email = model.email
            let company_id = model.company_id
            let created_at = model.created_at
            let customer = model.customer
            let project = model.project
            let obj = DataDetails(id: id, title: title, email: email, company_id: company_id, created_at: created_at,project:project,customer: customer)
            result.append(obj)
        }
        return result
    }
    
    
    func getFromDBItemsModels(project:String,companyID:Int,formTypeID:String)->[DataDetails] {
        let predicate1 = NSPredicate(format: "(form_type_id == '\(formTypeID)' AND company_id == '\(companyID)' AND development_title == null) OR (form_type_id == '\(formTypeID)' AND development_title == '\(project)' AND development_title != null)")
        guard let models = RealmManager.sharedInstance.fetchObjects(FormItemDBModel.self,predicate: predicate1) else {return []}
        var result = [DataDetails]()
        for model in models {
            let id = model.id
            let title = model.title
            let created_at = model.created_at
            let form_type_id = model.form_type_id
            let system = model.system
            let price = model.price ?? ""
            let show_price = model.show_price ?? ""
            var reasons:[FailReasonData] = []
            model.reasons.forEach{
                reasons.append(FailReasonData(id: $0.id, title: $0.title, form_item_id: $0.form_item_id, created_at: $0.created_at))
            }
            let obj = DataDetails(id: id, title: title, created_at: created_at,form_type_id: form_type_id,system: system,fail_reasons: reasons,price: price,show_price: show_price)
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
    
    
    
    func addToDBModels(models:[DataDetails],type:String){
        for model in models{
            let dbModel = DataDetailsDBModel()
            dbModel.id = model.id
            dbModel.title = model.title
            dbModel.email = model.email
            dbModel.company_id = model.company_id
            dbModel.created_at = model.created_at
            dbModel.type = type
            dbModel.project = model.project
            dbModel.customer = model.customer
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
            dbModel.company_id = model.company_id
            dbModel.system = model.system
            dbModel.price = model.price
            dbModel.show_price = model.show_price
            
            
            dbModel.development_title = model.development_title
            for reason in model.fail_reasons ?? []{
                let dbReason = FormItemReason()
                dbReason.id = reason.id
                dbReason.title = reason.title
                dbReason.created_at = reason.created_at
                dbReason.form_item_id = reason.form_item_id
                dbModel.reasons.append(dbReason)
            }
            RealmManager.sharedInstance.saveObject(dbModel)
        }
    }
    
    
}
