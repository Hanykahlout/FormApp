//
//  MaterialsPrestner.swift
//  FormApp
//
//  Created by Hany Alkahlout on 03/05/2023.
//

import UIKit
import SVProgressHUD
protocol MaterialsPresetnerDelegate{
    func updateCompaniesUI()
    func updateJobsUI()
    func updatePhasesUI()
    func updateSpecialsUI()
    func updateMaterialsUI()
}

typealias MaterialsDelegate = MaterialsPresetnerDelegate & UIViewController

class MaterialsPresetner{
    weak var delegate: MaterialsDelegate?
    
    private var companies:[DataDetails]=[]
    private var jobs:[DataDetails]=[]
    var selectedjob:DataDetails?
    private var phases:[String] = []
    private var searchedPhases:[String] = []
    private var specials:[String] = []
    private var searchedSpecials:[String] = []
    private var materials:[Material] = []
    
    var selectedCompanyIndex = 0
    var selectedJobIndex = 0
    var selectedPhasesIndex = 0
    var selectedSpecialsIndex = 0
    
    var companySearchText = ""
    var jobSearchText = ""
    var phasesSearchText = ""
    var specialsSearchText = ""
    var companyID = -1
    var jobID = -1
    var phase = ""
    var special = ""
    var selectionData:PhasesBuilders?
    
    init(){
        getMaterialsFromAPI()
        companies = RealmController.shared.getFromDBModels(type: "companies",searchText: "")
    }
    
    
    func getCompanies()->[DataDetails]{
        return companies
    }
    
    func getCompanies()->[String]{
        return companies.map{$0.title ?? ""}
    }
    
    func getCompanies(at index:Int)->DataDetails{
        return companies[index]
    }
    
    func getJobs()->[DataDetails]{
        return jobs
    }
    
    func getJobs(at index:Int)->DataDetails{
        return jobs[index]
    }
    
    func getJobs()->[String]{
        return jobs.map{$0.title ?? ""}
    }
    
    func getPhases()->[String]{
        return phases
    }
    
    func searchPhases(search:String){
        self.searchedPhases = phases.filter{$0.lowercased().hasPrefix(search.lowercased())}
        self.delegate?.updatePhasesUI()
    }
    
    func getPhase(at index:Int)->String{
        return phases[index]
    }
    
    func getSpecials()->[String]{
        return specials
    }
    
    
    func searchSpecials(search:String){
        self.searchedSpecials = specials.filter{$0.lowercased().hasPrefix(search.lowercased())}
        self.delegate?.updateSpecialsUI()
    }
    
    
    func getSpecial(at index: Int)->String{
        return specials[index]
    }
    
    
    func getSearchedPhases()->[String]{
        return searchedPhases
    }
    
    
    func getSearchedPhases(at index:Int)->String{
        return searchedPhases[index]
    }
    
    
    func getSearchedSpecials()->[String]{
        return searchedSpecials
    }
    
    func getSearchedSpecials(at index:Int)->String{
        return searchedSpecials[index]
    }

    
    func getCompaniesFromDB(search:String){
        companies = RealmController.shared.getFromDBModels(type: "companies",searchText: search)
        delegate?.updateCompaniesUI()
    }
    
    
    func getJobsFromDB(companyID:String,search:String){
        jobs = RealmController.shared.getFromDBModels(type:"jobs",companyId: companyID,searchText: search)
        self.delegate?.updateJobsUI()
    }
    
    func getMaterials()->[Material]{
        return materials
    }
    
    func getPhaseSpecialFromAPI(){
        SVProgressHUD.show()
        AppManager.shared.getPhaseSpecial { result in
            SVProgressHUD.dismiss()
            switch result{
            case let .success(response):
                if response.status == true{
                    self.selectionData = response.data
                    self.phases = response.data?.phase ?? []
                    self.delegate?.updatePhasesUI()
                }else{
                    Alert.showErrorAlert(message: response.message ?? "")
                }
            case  .failure(let error):
                Alert.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func getMaterialsFromAPI(){
        SVProgressHUD.show()
        AppManager.shared.getHouseMaterials(company_id: companyID, job_id: jobID, phase: phase, special: special)  { result in
            SVProgressHUD.dismiss()
            switch result{
            case let .success(response):
                self.materials = response.data?.materials ?? []
                self.delegate?.updateMaterialsUI()
            case  .failure(let error):
                Alert.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func getSpecialFromAPI(){
        SVProgressHUD.show()
        AppManager.shared.getSpecialList(jobId: String(selectedjob?.id ?? 0),builder: "0") { result in
            SVProgressHUD.dismiss()
            switch result{
            case let .success(response):
                self.specials = response.data?.special ?? []
                self.delegate?.updateSpecialsUI()
            case  .failure(let error):
                Alert.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    
}
