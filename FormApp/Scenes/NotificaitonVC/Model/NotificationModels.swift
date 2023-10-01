//
//  NotificationModels.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/23/23.
//

import Foundation


struct NotificationResponse: Codable {
    let notifications: [NotificationData]?
}


struct NotificationData: Codable {
    let id: Int?
    let title, body, modelID, type: String?
    let createdAt:String?
    enum CodingKeys: String, CodingKey {
        case id, title, body
        case modelID = "model_id"
        case type
        case createdAt = "created_at"
    }
}
