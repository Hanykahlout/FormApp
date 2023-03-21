//
//  RequestModel.swift
//  FormApp
//
//  Created by Hany Alkahlout on 12/03/2023.
//


import RealmSwift

class RequestModel: Object {
    @Persisted var id:String?
    @Persisted var url:String?
    @Persisted var body:String?
    @Persisted var headers:String?
    @Persisted var method:String?
    @Persisted var email:String?
    @Persisted var isEdit:Bool?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}




