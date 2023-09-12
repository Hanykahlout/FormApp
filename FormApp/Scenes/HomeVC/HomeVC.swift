//
//  HomeVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 25/01/2023.
//

import UIKit
import SVProgressHUD

class HomeVC: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    let presenter = HomePresenter()
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        presenter.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { timer in
            self.presenter.checkDatabase()
        }
        presenter.checkDatabase()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Home"
    }
    
    private func setUpRefreshButton(){
        let refreshButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        navigationItem.rightBarButtonItem = refreshButtonItem
        
    }
    
}

// MARK: - Binding
extension HomeVC{
    @objc private func refreshAction(){
        presenter.checkDatabase(refresh: true)
    }
}


// MARK: - Collection View Delegate And DataSource

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private func setUpCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.setData(data:presenter.data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = presenter.data[indexPath.row]
        
        switch data{
            
        case .Forms:
            
            let vc = SubmittedFormsVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
            
        case .PORequest:
            
            let alertVC = UIAlertController(title: "Have you checked the dashboard/WIP to make sure the job is open?", message: "", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Yes", style: .default,handler: { alert in
                let vc = PORequestVC.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            alertVC.addAction(UIAlertAction(title: "No", style: .default,handler: { alert in
                let alertVC2 = UIAlertController(title: "please check that and come back if it's open", message: "", preferredStyle: .alert)
                alertVC2.addAction(.init(title: "Cancel", style: .cancel))
                self.present(alertVC2, animated: true)
            }))
            self.present(alertVC, animated: true)
            
        case .Materials:
            let vc = MaterialsVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
            
        case .jobEntry:
            let vc = JobEntryVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
            
        case .warrantyForm:
            let vc = WarrantyFormVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.bounds.width / 2) - 10, height: 100)
    }
    
    
}

extension HomeVC:HomePresenterDelegate{
    
    func handleCheckDatabaseData(data: RequestsStatus) {
        presenter.data = [.Forms,.Materials]
        
        // Check if Job Entry is Available or not
        if data.is_job_entry_available == 1,!presenter.data.contains(where: { data in
            return data == .jobEntry
        }){
            
            presenter.data.append(.jobEntry)
            
        }else if data.is_job_entry_available != 1{
            presenter.data.removeAll(where: {$0 == .jobEntry})
        }
        
        // Check if Warranty is Available or not
        if data.is_warranty_available == 1,!presenter.data.contains(where: { data in
            return data == .warrantyForm
        }){
            
            presenter.data.append(.warrantyForm)
            
        }else if data.is_warranty_available != 1{
            presenter.data.removeAll(where: {$0 == .warrantyForm})
        }
        
        collectionView.reloadData()
        
        // Check if refresh button is Available or not
        if data.refreshButton ?? "" == "active"{
            setUpRefreshButton()
        }else{
            navigationItem.rightBarButtonItem = nil
        }
        
        
    }
    
}



// MARK: - Set Storyboard

extension HomeVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}


