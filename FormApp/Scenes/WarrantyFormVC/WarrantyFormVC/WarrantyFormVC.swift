//
//  WarrantyFormVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/10/23.
//

import UIKit


class WarrantyFormVC: UIViewController {
    
    
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var workOrderNumberLabel: UILabel!
    @IBOutlet weak var dispatcherLabel: UILabel!
    @IBOutlet weak var serviceTechLabel: UILabel!
    @IBOutlet weak var newConstructionUserLabel: UILabel!
    @IBOutlet weak var coeDateLabel: UILabel!
    @IBOutlet weak var billToLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var divisonLabel: UILabel!
    @IBOutlet weak var supervisorLabel: UILabel!
    @IBOutlet weak var workAddressLabel: UILabel!
    @IBOutlet weak var customerPOLabel: UILabel!
    @IBOutlet weak var reportedProblemLabel: UILabel!
    @IBOutlet weak var specialLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var serviceTimeFromLabel: UILabel!
    @IBOutlet weak var serviceTimeToLabel: UILabel!
    
    // MARK: - Public Attributes
    var workOrderNumber = ""
    
    // MARK: - Private Attributes
    
    private let presenter = WarrantyFormPresenter()
    private var warranties:[Warranty] = []
    private var selectedWorkOrderNumber = ""
    private var warrantyData:WarrantyResponse?
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        binding()
        presenter.getWarrantyData(workOrderNumber: workOrderNumber)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavigation()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
    
}

// MARK: - Binding

extension WarrantyFormVC{
    
    private func binding(){
        continueButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case continueButton:
            let vc = SubmitWarrantyFormVC.instantiate()
            vc.workOrderNumber = workOrderNumber
            vc.warrantyData = warrantyData
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: - Presenter Delegate

extension WarrantyFormVC:WarrantyFormPresenterDelegate{
   
    
    func setWarrantyDetails(data: WarrantyResponse) {
        warrantyData = data
        serviceDateLabel.text = data.serviceDate ?? "-----"
        customerLabel.text = data.builder ?? "-----"
        workOrderNumberLabel.text = data.workOrderNumber ?? "-----"
        dispatcherLabel.text = data.dispatcher?.name ?? "-----"
        serviceTechLabel.text = "\(data.serviceTech?.fname ?? "") \(data.serviceTech?.lname ?? "")"
        newConstructionUserLabel.text = data.newConstruction ?? "-----"
        coeDateLabel.text = data.coeDate ?? "-----"
        billToLabel.text = data.billTo ?? "-----"
        companyLabel.text = "\(data.company ?? -1)"
        divisonLabel.text = data.division ?? "-----"
        supervisorLabel.text = data.supervisor ?? "-----"
        workAddressLabel.text = data.workAddress ?? "-----"
        customerPOLabel.text = data.customerPo ?? "-----"
        reportedProblemLabel.text = data.reportedProblem ?? "-----"
        specialLabel.text = data.specialInstructions ?? "-----"
    }
    
    
}



// MARK: - Set Storyboard

extension WarrantyFormVC:Storyboarded{
    
    static var storyboardName: StoryboardName = .main
    
}


