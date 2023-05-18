//
//  FormItemDBModel.swift
//  FormApp
//
//  Created by Hany Alkahlout on 13/03/2023.
//

import RealmSwift

class FormItemDBModel: Object {
    
    @Persisted var id:Int?
    @Persisted var title:String?
    @Persisted var created_at:String?
    @Persisted var form_type_id:String?
    @Persisted var system:String?
    @Persisted var price:String?
    @Persisted var show_price:String?
    @Persisted var development_title:String?
    @Persisted var reasons:List<FormItemReason>
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
