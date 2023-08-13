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
    @Persisted var tag:String?
    @Persisted var show_image:Int?
    @Persisted var show_notes:Int?
    @Persisted var pin:String?
    @Persisted var is_blocked:Int?
    @Persisted var side_by_side:SideBySideDBModel?
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}



class SideBySideDBModel: Object {
    
    @Persisted var first_field:SideDBModel?
    @Persisted var second_field:SideDBModel?
    
}

class SideDBModel: Object {
    
    @Persisted var type:String?
    @Persisted var title:String?
    
}
