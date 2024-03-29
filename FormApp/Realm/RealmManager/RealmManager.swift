//
//  RealmManager.swift
//  FormApp
//
//  Created by Hany Alkahlout on 08/03/2023.
//

import Foundation
import RealmSwift

class RealmManager: RealmManagerInterface {
    
    // MARK: - Variables And Properties
    static let sharedInstance = RealmManager()
    
    
    func checkMigration(){
        let config = Realm.Configuration(
            schemaVersion: 4, // Set the new schema version.
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 4 {
                    
                    migration.enumerateObjects(ofType: FormItemDBModel.className()) { oldObject, newObject in
                        newObject?["is_blocked"] = nil
                    }
                    
                    let uuid = UserDefaults.standard.string(forKey: "ApplicationSessionUUID") ?? ""
                    AppManager.shared.changeVersion(uuid: uuid, checkDatabase: true, model: "formItem") { result in }

                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
    }
    
    // MARK: Saving
    func saveObjects<T: Object>(_ objects: [T]) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(objects)
            }
        }
    }
    
    func saveObject<T: Object>(_ object: T) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(object,update: .modified)
            }
        }
    }
    
    // MARK: Fetching
    func fetchObjects<T: Object>(_ type: T.Type) -> [T]? {
        guard let realm = try? Realm() else { return nil }
        return Array(realm.objects(type))
    }
    
    
    func fetchObjects<T: Object>(_ type: T.Type, predicate: NSPredicate) -> [T]? {
        guard let realm = try? Realm() else { return nil }
        return Array(realm.objects(type).filter(predicate))
    }
    
    
    // MARK: Remove
    func removeObjects<T: Object>(_ objects: [T]) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(objects)
            }
        }
    }
    
    
    func removeObject<T: Object>(_ object: T) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(object)
            }
        }
    }
    
    
    func removeAllObjectsOfType<T: Object>(_ type: T.Type) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(realm.objects(T.self))
            }
        }
    }
    
    
    func removeAll() {
        if let realm = try? Realm() {
            try? realm.write({
                realm.deleteAll()
            })
        }
    }
    
    
    func removeWhere<T: Object>(column:String,value:Any,for: T.Type){
        if let realm = try? Realm() {
            try! realm.write {
                realm.delete(realm.objects(T.self).filter("\(column) = \(value)"))
            }
        }
    }
    
    private func getFormItemById(id:Int) -> FormItemDBModel?{
        let predicate = NSPredicate(format: "id == \(id)")
        return RealmManager.sharedInstance.fetchObjects(FormItemDBModel.self, predicate: predicate)?.first
    }
    
    
    private func checkFailReasonsExist(id:Int)->Bool{
        let predicate = NSPredicate(format: "id == \(id)")
        return !(RealmManager.sharedInstance.fetchObjects(FormItemReason.self,predicate: predicate)?.isEmpty ?? true)
    }
    
    func addToFormItemReasonDBModels(models:[FailReasonData]){
        for model in models{
            let dbModel = FormItemReason()
            dbModel.id = model.id
            dbModel.title = model.title
            dbModel.form_item_id = model.form_item_id
            dbModel.created_at = model.created_at
            RealmManager.sharedInstance.saveObject(dbModel)
            
        }
    }
    
}
             
