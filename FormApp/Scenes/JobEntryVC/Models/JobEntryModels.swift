//
//  JobEntryModels.swift
//  FormApp
//
//  Created by Hany Alkahlout on 8/27/23.
//

import Foundation


struct ApiListsData: Codable {
    var division, company: [String]?
    var builders: [[String]]?
    var projectManagers: [[String]]?
    var businessManagers: [[String]]?
    var costCode, models, projects: [String]?
    var states: [State]?

    enum CodingKeys: String, CodingKey {
        case division, company, builders
        case projectManagers = "project_managers"
        case businessManagers = "business_managers"
        case costCode = "cost_code"
        case models, projects, states
    }
}

// MARK: - State
struct State: Codable {
    let stateName, state: String?

    enum CodingKeys: String, CodingKey {
        case stateName = "state_name"
        case state
    }
}



struct CitiesData: Codable {
    let cities: [String]?
}

// MARK: - DataClass
struct ZipData: Codable {
    let zip: [Int]?
}
                                


