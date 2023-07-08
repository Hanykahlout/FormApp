//
//  SubContractorsDBModel.swift
//  FormApp
//
//  Created by Hany Alkahlout on 24/06/2023.
//

import RealmSwift

class SubContractorsDBModel: Object {
    
    @Persisted var id:Int?
    @Persisted var name:String?
    @Persisted var telephone:String?
    @Persisted var vendor:String?
    @Persisted var company_id:Int?
    @Persisted var created_at:String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

