//
//  DataDetailsDBModel.swift
//  FormApp
//
//  Created by Hany Alkahlout on 08/03/2023.
//

import RealmSwift

class DataDetailsDBModel: Object {
    @Persisted var id:Int?
    @Persisted var title:String?
    @Persisted var email:String?
    @Persisted var company_id:String?
    @Persisted var created_at:String?
    @Persisted var type:String?
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
