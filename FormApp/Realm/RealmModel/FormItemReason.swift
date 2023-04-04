//
//  FormItemReason.swift
//  FormApp
//
//  Created by Hany Alkahlout on 04/04/2023.
//

import RealmSwift

class FormItemReason: Object {
    
    @Persisted var id:Int?
    @Persisted var title:String?
    @Persisted var form_item_id:String?
    @Persisted var created_at:String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
