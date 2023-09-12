//
//  WarrantyFormModels.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/11/23.
//

import Foundation

// MARK: - WarrantiesResponse
struct WarrantiesResponse: Decodable {
    var warranties: [Warranty]?
}

// MARK: - Warranty
struct Warranty: Decodable {
    let workOrderNumber, builder, newConstruction: String?
    let company: Int?
    let division: String?
    let dispatcher, serviceTech: String?
    var isSelected = false
    enum CodingKeys: String, CodingKey {
        case workOrderNumber = "work_order_number"
        case builder
        case newConstruction = "new_construction"
        case company, division, dispatcher
        case serviceTech = "service_tech"
    }
}


// MARK: - WarrantyResponse
struct WarrantyResponse: Codable {
    let id: Int?
    let workOrderNumber, serviceDate, builder: String?
    let dispatcherID: Int?
    let specialInstructions, reportedProblem, customerPo, workAddress: String?
    let supervisor, division: String?
    let company: Int?
    let billTo, coeDate, newConstruction: String?
    let serviceTechID: Int?
    let updatedAt, createdAt: String?
    let attachment: String?
    let billableTo, billable: String?
    let totalPrice: String?
    let workmanship, manufacturer, status, workPerformed: String?
    let diagnosis: String?
    let dispatcher: Dispatcher?
    let serviceTech: ServiceTech?

    enum CodingKeys: String, CodingKey {
        case id
        case workOrderNumber = "work_order_number"
        case serviceDate = "service_date"
        case builder
        case dispatcherID = "dispatcher_id"
        case specialInstructions = "special_instructions"
        case reportedProblem = "reported_problem"
        case customerPo = "customer_po"
        case workAddress = "work_address"
        case supervisor, division, company
        case billTo = "bill_to"
        case coeDate = "coe_date"
        case newConstruction = "new_construction"
        case serviceTechID = "service_tech_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case attachment
        case billableTo = "billable_to"
        case billable
        case totalPrice = "total_price"
        case workmanship, manufacturer, status
        case workPerformed = "work_performed"
        case diagnosis, dispatcher
        case serviceTech = "service_tech"
    }
}

// MARK: - Dispatcher
struct Dispatcher: Codable {
    let id: Int?
    let name, email, status, createdAt: String?
    let apiUsername: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, status
        case createdAt = "created_at"
        case apiUsername = "api_username"
    }
}

// MARK: - ServiceTech
struct ServiceTech: Codable {
    let id: Int?
    let fname, lname, email, status: String?
    let apiToken: String?
    let uuid, refreshButton, leaveDate, entranceDate: String?
    let iosVersion, deviceModel, applicationVersion: String?
    let apiUsername: String?
    let jobEntry: String?
    let isOnline: Bool?

    enum CodingKeys: String, CodingKey {
        case id, fname, lname, email, status
        case apiToken = "api_token"
        case uuid
        case refreshButton = "refresh_button"
        case leaveDate = "leave_date"
        case entranceDate = "entrance_date"
        case iosVersion = "ios_version"
        case deviceModel = "device_model"
        case applicationVersion = "application_version"
        case apiUsername = "api_username"
        case jobEntry = "job_entry"
        case isOnline = "is_online"
    }
}
