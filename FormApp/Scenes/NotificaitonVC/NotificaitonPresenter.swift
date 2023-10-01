//
//  NotificaitonPresenter.swift
//  FormApp
//
//  Created by Hany Alkahlout on 9/23/23.
//

import UIKit
import SVProgressHUD
protocol NotificaitonPresenterDelegate{
    
    func setNotificaitons(data:[NotificationData])
}

typealias NotificaitonPresenterVCDelegate = NotificaitonPresenterDelegate & UIViewController

class NotificaitonPresenter{
    
    weak var delegate: NotificaitonPresenterVCDelegate?
    
    func getNotifications(){
        
        SVProgressHUD.show()
        
        AppManager.shared.getNotifications { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                if response.status ?? false{
                    self.delegate?.setNotificaitons(data: response.data?.notifications ?? [])
                }else{
                    Alert.showErrorAlert(message: response.message ?? "Unknown error from server")
                }
                
            case .failure(_):
                Alert.showErrorAlert(message: "Request Error: Faild to check the updates for the current version")
            }
        }
        
    }
    
}
