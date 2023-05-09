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
    private  var phases:[String] = []
    private var searchedPhases:[String] = []
    func createMaterial(itemNo:String,name:String,
                        builder:String,community:String,
                        modelType:String,phase:String,
                        special:String,quantity:String){
        let body = [
            "item_no":itemNo,
            "name":name,
            "builder":builder,
            "community":community,
            "model_type":modelType,
            "phase":phase,
            "special":special,
            "quantity":quantity
        ]
        
        SVProgressHUD.show()
        AppManager.shared.createHouseMaterial(houseMaterialData: body) { result in
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
    
    
}
