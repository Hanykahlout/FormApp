//
//  BudgetResponse.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/1/23.
//

import Foundation


// MARK: - DataClass
struct BudgetResponse: Codable {
    let budgets: Budgets?
}

// MARK: - Budgets
struct Budgets: Codable {
    let permitMaterial, sewerLabor, sewerMaterial, underslabLabor: String?
    let underslabMaterial, roughLabor, roughMaterial, trimLabor: String?
    let trimMaterial: String?

    enum CodingKeys: String, CodingKey {
        case permitMaterial = "permit_material"
        case sewerLabor = "sewer_labor"
        case sewerMaterial = "sewer_material"
        case underslabLabor = "underslab_labor"
        case underslabMaterial = "underslab_material"
        case roughLabor = "rough_labor"
        case roughMaterial = "rough_material"
        case trimLabor = "trim_labor"
        case trimMaterial = "trim_material"
    }
}
