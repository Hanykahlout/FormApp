//
//  Extensions.swift
//  FormApp
//
//  Created by heba isaa on 21/02/2023.
//

import Foundation
import MessageUI
extension UIViewController{
    
    var sceneDelegate:SceneDelegate?{
        return self.view.window?.windowScene?.delegate as? SceneDelegate
    }
    
    func sendEmail(email:String){
        if email != ""{
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
                mail.setToRecipients([email])
                mail.setMessageBody("<h1>Hello there", isHTML: true)
                present(mail, animated: true)
            } else {
                let alertVC = UIAlertController(title: "Error", message: "Cannot send email", preferredStyle: .alert)
                alertVC.addAction(.init(title: "Cancel", style: .cancel))
                present(alertVC, animated: true)
                print("Cannot send email")
            }
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                controller.dismiss(animated: true)
            }
        }
    }
    
}



