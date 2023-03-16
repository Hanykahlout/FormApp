//
//  BaseResponse.swift
//  FormApp
//
//  Created by heba isaa on 18/02/2023.
//

import Foundation
struct BaseResponse<T:Decodable>: Decodable{
    
    let status: Bool?
    let code: Int?
    let message: String?
//    let errors: [ErrorElement]?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
//        case errors
        case  data
    }
}
