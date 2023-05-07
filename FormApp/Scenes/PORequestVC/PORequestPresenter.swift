//
//  PORequestPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 23/04/2023.
//

import UIKit

protocol PORequestPresenterDelegate{
    
    func clearFields()
    func getCompanyData(data: CompaniesData)
    func getJobData(data: JobData)
    func getDivition(data: DiviosnData)
    
}

typealias PORequestDelegate = PORequestPresenterDelegate & UIViewController


class PORequestPresenter{
    weak var delegate: PORequestDelegate?
    
    
    func getCompaniesFromDB(search:String){
        self.delegate?.getCompanyData(data: CompaniesData(companies: RealmController.shared.getFromDBModels(type: "companies",searchText: search)))
    }
    
    func getJobsFromDB(companyID:String,search:String){
        self.delegate?.getJobData(data: JobData(jobs: RealmController.shared.getFromDBModels(type:"jobs",companyId: companyID,searchText: search)))
    }
    
    func getDivisionFromDB(companyID:String,search:String){
        self.delegate?.getDivition(data: DiviosnData(divisions: RealmController.shared.getFromDBModels(type:"divisions",companyId: companyID,searchText: search)))
    }
    
    
}
