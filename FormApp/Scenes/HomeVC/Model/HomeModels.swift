//
//  HomeModels.swift
//  FormApp
//
//  Created by Hany Alkahlout on 21/04/2023.
//

import Foundation

struct RequestsStatus:Decodable{
    let company: Bool?
    let job: Bool?
    let form: Bool?
    let division: Bool?
    let formItem: Bool?
    let failReason: Bool?
    
    init(company: Bool?, job: Bool?, form: Bool?, division: Bool?,formItem:Bool?,failReason:Bool?) {
        self.company = company
        self.job = job
        self.form = form
        self.division = division
        self.formItem = formItem
        self.failReason = failReason
    }
    
}

