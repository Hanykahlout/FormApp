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
    @Persisted var system_type:String?
    @Persisted var system_list:List<String>
    @Persisted var price:String?
    @Persisted var show_price:String?
    @Persisted var development_title:String?
    @Persisted var new_box:List<FormItemNewBox>
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}


