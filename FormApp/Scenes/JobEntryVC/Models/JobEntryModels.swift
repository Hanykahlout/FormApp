//
//  JobEntryModels.swift
//  FormApp
//
//  Created by Hany Alkahlout on 8/27/23.
//

import Foundation


struct ApiListsData: Codable {
    let division, company: [String]?
    let builders: [[String]]?
    let projectManagers: [[String]]?
    let businessManagers: [[String]]?
    let costCode, models, projects: [String]?
    let states: [State]?

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
                                


