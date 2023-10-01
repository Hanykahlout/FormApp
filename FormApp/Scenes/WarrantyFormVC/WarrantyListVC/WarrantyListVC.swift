//
//  WarrantyListVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/17/23.
//

import UIKit

class WarrantyListVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var formStatusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Attributes
    
    private var presenter = WarrantyListPresenter()
    private var warrantiesData:WarrantiesResponse? {
        didSet{
            self.tableView.reloadData()
        }
    }
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        setUpSegmentedControl()
        setUpTableView()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        presenter.getWarranties()
    }
    
    // MARK: - Private Functions
    
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.removeBackgroungNavBar()
        navigationItem.title = "Warranty Forms"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.backgroundColor = .white
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
    }
    
    private func setUpSegmentedControl(){
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Urbanist-Regular", size: 16)!
        ]
        
        formStatusSegmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Urbanist-Medium", size: 16)!
        ]
        
        formStatusSegmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
    }
    
    
}

// MARK: - Binding

extension WarrantyListVC{
    
    private func binding(){
        formStatusSegmentedControl.addTarget(self, action: #selector(bindingAction), for: .valueChanged)
    }
    
    @objc private func bindingAction(_ sender:UIView){
        switch sender{
        case formStatusSegmentedControl:
            tableView.reloadData()
        default:
            break
        }
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: - Set Up Table View

extension WarrantyListVC:UITableViewDelegate,UITableViewDataSource{
    
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "WarrantyListTableViewCell", bundle: nil), forCellReuseIdentifier: "WarrantyListTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if formStatusSegmentedControl.selectedSegmentIndex == 0{
            return warrantiesData?.pending?.count ?? 0
        }
        return warrantiesData?.submitted?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WarrantyListTableViewCell", for: indexPath) as! WarrantyListTableViewCell
        if formStatusSegmentedControl.selectedSegmentIndex == 0{
            if let data = warrantiesData?.pending?[indexPath.row] {
                cell.setData(data: data)
            }
        }else{
            if let data = warrantiesData?.submitted?[indexPath.row] {
                cell.setData(data: data)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = WarrantyFormVC.instantiate()
        if formStatusSegmentedControl.selectedSegmentIndex == 0{
            if let data = warrantiesData?.pending?[indexPath.row] {
                vc.workOrderNumber = data.workOrderNumber ?? ""
            }
        }else{
            if let data = warrantiesData?.submitted?[indexPath.row] {
                vc.workOrderNumber = data.workOrderNumber ?? ""
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

// MARK: - Presenter Delegate

extension WarrantyListVC:WarrantyListPresenterDelegate{
    func setWarrantiesData(data: WarrantiesResponse) {
        self.warrantiesData = data
    }
    
}

// MARK: - Set Storyboard

extension WarrantyListVC:Storyboarded{
    
    static var storyboardName: StoryboardName = .main
    
    
}
