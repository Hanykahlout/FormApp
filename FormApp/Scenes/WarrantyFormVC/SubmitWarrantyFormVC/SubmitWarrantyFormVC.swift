//
//  SubmitWarrantyFormVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/11/23.
//

import UIKit

class SubmitWarrantyFormVC: UIViewController {
    
    @IBOutlet weak var diagnosisTextField: UITextField!
    
    @IBOutlet weak var workPerformedTextField: UITextField!
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var statusTextField: UITextField!
    
    @IBOutlet weak var manufacturerDefectButton: UIButton!
    @IBOutlet weak var manufacturerDefectTextField: UITextField!
    
    @IBOutlet weak var workmanshipIssueSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var totalPriceTextField: UITextField!
    
    @IBOutlet weak var billableSegmentedControl: UISegmentedControl!
    @IBOutlet weak var billableToButton: UIButton!
    @IBOutlet weak var billableToTextField: UITextField!
    @IBOutlet weak var billableToStackView: UIStackView!
    
    @IBOutlet weak var attachButton: UIButton!
    
    @IBOutlet weak var deleteAttchmentButton: UIButton!
    @IBOutlet weak var attachmentFileLabel: UILabel!
    @IBOutlet weak var attachStackView: UIStackView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    // MAKR: - Public  Attributes
    var workOrderNumber = ""
    var warrantyData:WarrantyResponse?
    // MAKR: - Private Attributes
    
    private var statusPickerVC:PickerVC!
    private var manufacturerDefectPickerVC:PickerVC!
    private var billableToPickerVC:PickerVC!
    
    private var documentPickerController: UIDocumentPickerViewController!
    
    private var selectedImageURL:URL?
    private var selectedFileURL:URL?
    
    private let presenter = SubmitWarrantyFormPresenter()
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        setUpPickerVCs()
        binding()
        setUpDocumentPicker()
        setUpSegmentedControl(workmanshipIssueSegmentedControl)
        setUpSegmentedControl(billableSegmentedControl)
        setWarrantyData()
        //        billableSegmentedControl.addTarget(self, action: #selector(billableAction), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
    }
    
    
    // MARK: - Private Functions
    
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.removeBackgroungNavBar()
        navigationItem.title = "Warranty Form"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.backgroundColor = .white
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
    }
    
    private func setUpSegmentedControl(_ segmentedControl:UISegmentedControl){
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white // Change this color to your desired text color
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        // Customize the text color for the selected state
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white // Change this color to your desired selected text color
        ]
        
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
    }
    
    
    private func setWarrantyData(){
        if let warrany = warrantyData{
            diagnosisTextField.text = warrany.diagnosis ?? ""
            workPerformedTextField.text = warrany.workPerformed ?? ""
            statusTextField.text = warrantyData?.status ?? ""
            manufacturerDefectTextField.text = warrantyData?.manufacturer ?? ""
            workmanshipIssueSegmentedControl.selectedSegmentIndex = warrantyData?.workmanship?.lowercased() == "yes" ? 1 : 0
            totalPriceTextField.text = warrantyData?.totalPrice ?? ""
            billableSegmentedControl.selectedSegmentIndex = warrantyData?.billable?.lowercased() == "yes" ? 1 : 0
            billableToTextField.text = warrantyData?.billableTo ?? ""
            if let attachment = warrany.attachment,
               let url = URL(string: attachment){
                attachStackView.isHidden = false
                attachmentFileLabel.text = url.lastPathComponent
                let path = url.pathExtension
                if path == "png" || path == "jpeg"{
                    selectedImageURL = url
                }else{
                    selectedFileURL = url
                }
            }
        }
    }
    
    private func setUpTextFieldDelegates(){
        
        diagnosisTextField.delegate = self
        workPerformedTextField.delegate = self
        statusTextField.delegate = self
        manufacturerDefectTextField.delegate = self
        totalPriceTextField.delegate = self
        billableToTextField.delegate = self
        
    }
    
    
    private func setUpDocumentPicker(){
        documentPickerController = UIDocumentPickerViewController(
            forOpeningContentTypes: [.pdf])
        
        documentPickerController.delegate = self
        
    }
    
    private func setUpPickerVCs(){
        
        
        setUpBillableToPicker()
        setUpStatusPicker()
        setUpManufacturerDefectPicker()
        
    }
    
    
    private func setUpBillableToPicker(){
        billableToPickerVC = PickerVC.instantiate()
        billableToPickerVC.arr_data = ["BUILDER","MANUFACTURER","SUBCONTRACTOR","HOMEOWNER"]
        
        billableToPickerVC!.searchBarHiddenStatus = true
        
        billableToPickerVC!.delegate = {name , index in
            self.billableToTextField.text = name
        }
        
        billableToPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func setUpStatusPicker(){
        statusPickerVC = PickerVC.instantiate()
        statusPickerVC.arr_data = ["Scheduled","Parts Ordered","Completed","Return Trip Needed","Cancelled","Assisted"]
        
        statusPickerVC!.searchBarHiddenStatus = true
        
        statusPickerVC!.delegate = {name , index in
            self.statusTextField.text = name
            
        }
        
        statusPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    private func setUpManufacturerDefectPicker(){
        manufacturerDefectPickerVC = PickerVC.instantiate()
        manufacturerDefectPickerVC.arr_data = ["YES","NO","TO BE DETERMINED ON SITE"]
        
        manufacturerDefectPickerVC!.searchBarHiddenStatus = true
        
        manufacturerDefectPickerVC!.delegate = {name , index in
            self.manufacturerDefectTextField.text = name
        }
        
        manufacturerDefectPickerVC!.modalPresentationStyle = .overCurrentContext
    }
    
    private func attachFileAction(){
        let vc = AttachTypeVC.instantiate()
        vc.selectAction = { isPhoto in
            
            if isPhoto{
                self.setImageBy(source: .photoLibrary)
            }else{
                self.present(self.documentPickerController, animated: true, completion: nil)
            }
            
        }
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
    
    private func getUIData()->[String:Any]{
        var data:[String:Any] = [:]
        
        data = [
            "work_order_number":workOrderNumber,
            "billable":billableSegmentedControl.selectedSegmentIndex == 1 ? "Yes" : "No",
            "billable_to":billableToTextField.text!,
            "workmanship": workmanshipIssueSegmentedControl.selectedSegmentIndex == 1 ? "Yes" : "No",
            "manufacturer":manufacturerDefectTextField.text!,
            "status":statusTextField.text!,
            "work_performed":workPerformedTextField.text!,
            "diagnosis":diagnosisTextField.text!,
            "total_price":totalPriceTextField.text!,
            
        ]
        
        if let selectedFileURL = selectedFileURL{
            data["attachment"] = selectedFileURL
            data["isPhoto"] = false
        }else if let selectedImageURL = selectedImageURL{
            data["attachment"] = selectedImageURL
            data["isPhoto"] = true
        }
        
        return data
    }
    
    private func validation()->Bool{
        let diagnosis = diagnosisTextField.text!
        let workPerformed = workPerformedTextField.text!
        let status = statusTextField.text!
        let manufacturerDefect = manufacturerDefectTextField.text!
        let billableTo = billableToTextField.text!
        
        var isError = false
        
        if diagnosis.isEmpty{
            isError = true
            showError(on: diagnosisTextField)
        }
        
        if workPerformed.isEmpty{
            isError = true
            showError(on: workPerformedTextField)
        }
        
        if status.isEmpty{
            isError = true
            showError(on: statusTextField)
        }
        
        if manufacturerDefect.isEmpty{
            isError = true
            showError(on: manufacturerDefectTextField)
        }
        
        if billableTo.isEmpty{
            isError = true
            showError(on: billableToTextField)
        }
        
        if isError{
            Alert.showErrorAlert(message: "Please fill in all fields before submitting.")
        }
        
        return !isError
    }
    
}


// MARK: - Binding

extension SubmitWarrantyFormVC{
    
    private func binding(){
        
        billableToButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        statusButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        manufacturerDefectButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        attachButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        deleteAttchmentButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        
        switch sender{
        case billableToButton:
            present(billableToPickerVC, animated: true)
        case statusButton:
            present(statusPickerVC, animated: true)
        case manufacturerDefectButton:
            present(manufacturerDefectPickerVC, animated: true)
        case attachButton:
            attachFileAction()
        case deleteAttchmentButton:
            selectedImageURL = nil
            selectedFileURL = nil
            attachStackView.isHidden = true
            attachmentFileLabel.text = ""
        case submitButton:
            if validation(){
                presenter.storeWarranty(data: getUIData())
            }
            
        default:
            break
        }
        
    }
    
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func billableAction(){
        billableToStackView.isHidden = billableSegmentedControl.selectedSegmentIndex == 0
    }
    
    
}

// MARK: - Text Field Delegate

extension SubmitWarrantyFormVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.rightViewMode = .never
    }
}


// MARK: - Handle Image Picker Controller
extension SubmitWarrantyFormVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func setImageBy(source:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        selectedImageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        attachStackView.isHidden = false
        attachmentFileLabel.text = selectedImageURL!.lastPathComponent
        dismiss(animated: true, completion: nil)
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
    
}

// MARK: - Document Picker Delegate
extension SubmitWarrantyFormVC:UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        
        attachStackView.isHidden = false
        attachmentFileLabel.text = url.lastPathComponent
        selectedFileURL = url
        
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true)
    }
    
}


// MARK: - Presenter Delegate

extension SubmitWarrantyFormVC:SubmitWarrantyFormPresenterDelegate{
    
    
}

// MARK: - Set Storyboard

extension SubmitWarrantyFormVC:Storyboarded{
    
    static var storyboardName: StoryboardName = .main
}
