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
        let composeViewController = MFMailComposeViewController()

        if email == ""{
           
        }else{
            
        

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients([email])
            mail.setMessageBody("<h1>Hello there", isHTML: true)
            present(mail, animated: true)
        } else {
//            showAlert(title: "Error", message: "Cannot send email")
            print("Cannot send email")
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    }
}
