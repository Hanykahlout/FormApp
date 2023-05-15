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
    func updateSpecialsUI()
    func updateSuppliersUI()
}

typealias CreateMaterialDelegate = CreateMaterialPresenterDelegate & UIViewController

class CreateMaterialPresenter{
    weak var delegate:CreateMaterialDelegate?
    var builderSearchText = ""
    var communitySearchText = ""
    var phasesSearchText = ""
    var specialSearchText = ""
    var supplierSearchText = ""
    var selectedBuilderIndex = 0
    var selectedCommunityIndex = 0
    var selectedPhasesIndex = 0
    var selectedSpecialIndex = 0
    var selectedSupplierIndex = 0
    var material:Material?
    var selectedSupplier:Supplier?
    
    private var specials:[String] = []
    private var searchedSpecials:[String] = []
    
    private var phases:[String] = []
    private var searchedPhases:[String] = []
    
    private var builders:[String] = []
    private var searchedBuilders:[String] = []
    
    private var communities:[String] = []
    private var searchedCommunities:[String] = []
    
    private var suppliers:[Supplier] = []
    private var searchedSuppliers:[Supplier] = []
    
    
    // MARK: - Phases Setter And Getters
    func createMaterial(data:Material?,itemNo:String,name:String,
                        builder:String,community:String,
                        modelType:String,phase:String,
                        special:String,quantity:String,supplier_id:String){
        var body:[String:Any] = [
            "item_no":itemNo,
            "name":name,
            "builder":builder,
            "community":community,
            "model_type":modelType,
            "phase":phase,
            "special":special,
            "supplier_id":supplier_id,
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
                if response.status ?? false{
                    Alert.showSuccessAlert(message: response.message ?? "")
                    self.delegate?.successSubmtion()
                }else{
                    Alert.showErrorAlert(message: response.message ?? "")
                }
            case .failure(let error):
                Alert.showErrorAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    func getSpecialFromAPI(){
        SVProgressHUD.show()
        AppManager.shared.getSpecialList(jobId: "0",builder: builderSearchText == "" ?builders[selectedBuilderIndex]:searchedBuilders[selectedBuilderIndex]) { result in
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
    
    // MARK: - Phases Setter And Getters
    func setPhases(phases:[String]){
        self.phases = phases
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
    
    func getSearchedPhases()->[String]{
        return searchedPhases
    }
    
    func getSearchedPhases(at index:Int)->String{
        return searchedPhases[index]
    }
    
    // MARK: - Builders Setter And Getters
    
    func setBuilders(builders:[String]){
        self.builders = builders
    }
    
    func getBuilders()->[String]{
        return builders
    }
    
    func searchBuilders(search:String){
        self.searchedBuilders = builders.filter{$0.lowercased().hasPrefix(search.lowercased())}
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
    
    // MARK: - Communities Setter And Getters
    func setCommunities(communities:[String]){
        self.communities = communities
    }
    
    func getCommunities()->[String]{
        return communities
    }
    
    func searchCommunities(search:String){
        self.searchedCommunities = communities.filter{$0.lowercased().hasPrefix(search.lowercased())}
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
    
    // MARK: - Material Setter And Getters
    
    func setMaterial(material:Material){
        self.material = material
    }
    
    func getMaterial()-> Material?{
        return material
    }
    
    // MARK: - Getting Selected Filter From MaterialsVC
    
    func setSelectionData(selectionData:PhasesBuilders?){
        self.phases = selectionData?.phase ?? []
        self.builders = selectionData?.builders ?? []
        self.communities = selectionData?.communities ?? []
        self.suppliers = selectionData?.suppliers ?? []
    }
    
    
    
    // MARK: - Specials Setter And Getters
    
    func setSpecials(specials:[String]){
        self.specials = specials
    }
    
    func getSpecials()->[String]{
        return specials
    }
    
    func getSpecials(at index:Int)->String{
        return specials[index]
    }
    
    func searchSpecials(search:String){
        self.searchedSpecials = specials.filter{$0.lowercased().hasPrefix(search.lowercased())}
        self.delegate?.updateSpecialsUI()
    }
    
    func getSearchedSpecials()->[String]{
        return searchedSpecials
    }
    
    func getSearchedSpecials(at index:Int)->String{
        return searchedSpecials[index]
    }
    
    // MARK: - Suppliers Setter And Getters
    
    func setSuppliers(suppliers:[Supplier]){
        self.suppliers = suppliers
    }
    
    func getSuppliers()->[Supplier]{
        return suppliers
    }
    
    func getSuppliers(at index:Int)->Supplier{
        return suppliers[index]
    }
    
    func searchSuppliers(search:String){
        self.searchedSuppliers = suppliers.filter{$0.name?.lowercased().hasPrefix(search.lowercased()) ?? false}
        self.delegate?.updateSuppliersUI()
    }
    
    func getSearchedSuppliers()->[Supplier]{
        return searchedSuppliers
    }
    
    func getSearchedSuppliers(at index:Int)->Supplier{
        return searchedSuppliers[index]
    }
    
}
