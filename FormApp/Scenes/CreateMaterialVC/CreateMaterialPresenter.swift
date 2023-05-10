//
//  CreateMaterialPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 07/05/2023.
//

import UIKit
import SVProgressHUD

protocol CreateMaterialPresenterDelegate{
    func successSubmtion()
    func updatePhasesUI()
    func updateBuildersUI()
    func updateCommunitiesUI()
}

typealias CreateMaterialDelegate = CreateMaterialPresenterDelegate & UIViewController

class CreateMaterialPresenter{
    weak var delegate:CreateMaterialDelegate?
    var builderSearchText = ""
    var communitySearchText = ""
    var phasesSearchText = ""
    var selectedBuilderIndex = 0
    var selectedCommunityIndex = 0
    var selectedPhasesIndex = 0

    private var phases:[String] = []
    private var searchedPhases:[String] = []
    private var builders:[String] = []
    private var searchedBuilders:[String] = []
    private var communities:[String] = []
    private var searchedCommunities:[String] = []
    
    func createMaterial(data:Material?,itemNo:String,name:String,
                        builder:String,community:String,
                        modelType:String,phase:String,
                        special:String,quantity:String){
        var body:[String:Any] = [
            "item_no":itemNo,
            "name":name,
            "builder":builder,
            "community":community,
            "model_type":modelType,
            "phase":phase,
            "special":special,
            "quantity":quantity
        ]
        
        if let data = data{
            body["id"] = data.id
        }
        
        SVProgressHUD.show()
        AppManager.shared.createHouseMaterial(isEdit:data != nil,houseMaterialData: body) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                Alert.showSuccessAlert(message: response.message ?? "")
                self.delegate?.successSubmtion()
            case .failure(let error):
                Alert.showErrorAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    func setPhases(phases:[String]){
        self.phases = phases
    }
    
    func getPhases()->[String]{
        return phases
    }
    
    
    func setBuilders(builders:[String]){
        self.builders = builders
    }
    
    func getBuilders()->[String]{
        return builders
    }
    
    func setCommunities(communities:[String]){
        self.communities = communities
    }
    
    func getCommunities()->[String]{
        return communities
    }
    
    func setSelectionData(selectionData:SpecialPhase?){
        self.phases = selectionData?.phase ?? []
        self.builders = selectionData?.builders ?? []
        self.communities = selectionData?.communities ?? []
        
    }
    
    func searchPhases(search:String){
        self.searchedPhases = phases.filter{$0.hasPrefix(search)}
        self.delegate?.updatePhasesUI()
    }
    
    func getPhase(at index:Int)->String{
        return phases[index]
    }
    
    func getSearchedPhases()->[String]{
        return searchedPhases
    }
    
    func getSearchedPhases(at index:Int)->String{
        return searchedPhases[index]
    }
    
    
    func searchBuilders(search:String){
        self.searchedBuilders = builders.filter{$0.hasPrefix(search)}
        self.delegate?.updateBuildersUI()
    }
    
    func getBuilders(at index:Int)->String{
        return builders[index]
    }
    
    func getSearchedBuilders()->[String]{
        return searchedBuilders
    }
    
    func getSearchedBuilders(at index:Int)->String{
        return searchedBuilders[index]
    }
    
    func searchCommunities(search:String){
        self.searchedCommunities = communities.filter{$0.hasPrefix(search)}
        self.delegate?.updateCommunitiesUI()
    }
    
    func getCommunities(at index:Int)->String{
        return communities[index]
    }
    
    func getSearchedCommunities()->[String]{
        return searchedCommunities
    }
    
    func getSearchedCommunities(at index:Int)->String{
        return searchedCommunities[index]
    }
    
    
    
}
