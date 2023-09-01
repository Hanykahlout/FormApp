//
//  JobEntrySiginInPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/1/23.
//

import UIKit

protocol JobEntrySiginInPresenterDelegate{
    
}

typealias JobEntrySiginInVCDelegate = JobEntrySiginInPresenterDelegate & UIViewController

class JobEntrySiginInPresenter{
    
    weak var delegate:JobEntrySiginInVCDelegate?
    
    private func signInAction(){
        
    }
    
    
}
