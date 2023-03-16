//
//  PickerVC.swift
//  Almnabr
//
//  Created by MacBook on 20/04/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import SVProgressHUD
class PickerVC: UIViewController {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var searchBar: SearchView!
    
    var arr_data:[String] = []
    var name:String = ""
    var index : Int = 0
    var companyId=0
    var delegate : ((_ name: String ,_ index:Int) -> Void)?
    var searchResults : ((_ jobs: [DataDetails]) -> Void)?
    var searchOffline: ((_ text:String) -> [DataDetails])?
    
    var searchBarHiddenStatus:Bool=false
    let presenter = AppPresenter()
    
    //pickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGUI()
        searchBar.isHidden = searchBarHiddenStatus
        searchBarStatus()
        presenter.delegate=self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !arr_data.isEmpty{
            self.index = 0
        }
    }
    
    
    func searchBarStatus(){
        if searchBarHiddenStatus == false{
            setupSearchProperties()
        }
    }
    
    
    func  setupSearchProperties(){
        searchBar.btnSearch.addTarget(self, action: #selector(searchActioon), for: .touchUpInside)
    }

    @objc func searchActioon(_ sender : UIButton ) {
        self.searchBar.text = self.searchBar.text?.trimmingCharacters(in: .whitespaces)
//        if UserDefaults.standard.bool(forKey: "internet_connection"){
//            SVProgressHUD.setBackgroundColor(.white)
//            SVProgressHUD.show(withStatus: "please wait")
//            self.presenter.getJobs(companyID: "\(self.companyId)", search: self.searchBar.text!)
//        }else{
            let jobs = self.searchOffline?(self.searchBar.text ?? "") ?? []
            self.arr_data = jobs.map({$0.title ?? ""})
            self.picker.delegate=self
            self.picker.dataSource=self
//        }
    }

    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        self.picker.delegate = self
        self.btnNext.setTitle("Done", for: .normal)
        self.btnCancel.setTitle("Cancel", for: .normal)
        
        
        if arr_data.count > 0 {
            self.name = arr_data[0]
            self.index = 0
        }else{
            //            self.arr_data.append("No items found")
        }
        
    }
    
    //MARK: - Button Action
    //------------------------------------------------------
    
    @IBAction func btnSubmit_Click(_ sender: UIButton) {
        //        if arr_data.contains("No items found") && arr_data.count == 1 {
        
        if  arr_data.count == 0 {
            self.dismiss(animated: true, completion: nil)
        }else{
            delegate!(name, index)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancel_Click(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension PickerVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr_data.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr_data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        let item = arr_data[row]
        attributedString = NSAttributedString(string: item, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        
        return attributedString
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = arr_data[row]
        
        
        return pickerLabel!
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 35.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arr_data.count != 0 {
            if pickerView.tag == 0 {
                
                print(arr_data[row])
                self.name = (arr_data[row])
                self.index = row
                
            }
        }
        
    }
}


extension PickerVC:FormDelegate{
    func showAlerts(title: String, message: String) {}
    
    func getUserData(user: User) {}
    
    func getCompanyData(data: CompaniesData) {}
    
    func getJobData(data: JobData) {
        arr_data = data.jobs.map({$0.title ?? ""})
        searchResults?(data.jobs)
        SVProgressHUD.dismiss()
        picker.delegate=self
        picker.dataSource=self
    }
    
    func getFormsData(data: FormsData) { }
    
    func getDivition(data: DiviosnData) {}
    
    func getFormItemsData(data: FormItemData) { }
    
}

extension PickerVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
    
}
