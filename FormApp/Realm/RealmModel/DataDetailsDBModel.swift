//
//  DataDetailsDBModel.swift
//  FormApp
//
//  Created by Hany Alkahlout on 08/03/2023.
//

import RealmSwift

class DataDetailsDBModel: Object {
    
    @Persisted var id:Int?
    @Persisted var api_id:String?
    @Persisted var title:String?
    @Persisted var email:String?
    @Persisted var company_id:String?
    @Persisted var created_at:String?
    @Persisted var type:String?
    @Persisted var project:String?
    @Persisted var customer:String?
    @Persisted var is_fixture:Int?
    @Persisted var users:List<String>
    @Persisted var form_status:String?
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
}


