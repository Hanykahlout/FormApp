//
//  FormItemNewBox.swift
//  FormApp
//
//  Created by Hany Alkahlout on 24/05/2023.
//

import RealmSwift

class FormItemNewBox: Object {
    
    @Persisted var title:String?
    @Persisted var box_type:String?
    
}


