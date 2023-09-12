//
//  WarrantyFormVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/10/23.
//

import UIKit


class WarrantyFormVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var jobLabel: UILabel!
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
    
    // MARK: - Private Attributes
    
    private let presenter = WarrantyFormPresenter()
    private var warranties:[Warranty] = []
    private var selectedWorkOrderNumber = ""
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        binding()
        setUpCollectionView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavigation()
        presenter.getWarranties()
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
            vc.workOrderNumber = selectedWorkOrderNumber
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
}


// MARK: - Set Up Collection View

extension WarrantyFormVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    private func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "SelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectionCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return warranties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCollectionViewCell", for: indexPath) as! SelectionCollectionViewCell
        cell.setData(data: warranties[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<warranties.count{
            warranties[i].isSelected = i == indexPath.row
        }
        collectionView.reloadData()
        presenter.getWarrantyData(workOrderNumber: warranties[indexPath.row].workOrderNumber ?? "")
        selectedWorkOrderNumber = warranties[indexPath.row].workOrderNumber ?? ""
    }
    
}

// MARK: - Presenter Delegate

extension WarrantyFormVC:WarrantyFormPresenterDelegate{
    
    func setWarrantiesData(data: [Warranty]) {
        warranties = data
        if !warranties.isEmpty{
            warranties[0].isSelected = true
            selectedWorkOrderNumber = warranties[0].workOrderNumber ?? ""
            presenter.getWarrantyData(workOrderNumber: warranties[0].workOrderNumber ?? "")
        }
        collectionView.reloadData()
        
    }
    
    func setWarrantyDetails(data: WarrantyResponse) {
//        jobLabel.text = data.
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

