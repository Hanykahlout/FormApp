//
//  AlertController.swift
//  MiraApp
//
//  Created by ziad on 16/08/2022.
//


import UIKit

struct AlertProperties {
    var title: String?
    var message: String?
    var preferredStyle: UIAlertController.Style = .alert
}

struct AlertActionProperties {
    var title: String?
    var alertActionStyle: UIAlertAction.Style = .default
}

/// Builder Pattern to show Alert
///
public final class AlertBuilder {
    private let viewController: UIViewController
    private var alertProperties = AlertProperties()
    private var alertActionSuccessProperties = AlertActionProperties()
    private var alertActionCancelProperties = AlertActionProperties()
    private var onSuccess: ((UIAlertAction) -> Void)?
    private var onCancel: ((UIAlertAction) -> Void)?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func withTitle(_ title: String) -> AlertBuilder {
        alertProperties.title = title
        return self
    }

    public func andMessage(_ message: String) -> AlertBuilder {
        alertProperties.message = message
        return self
    }

    public func preferredStyle(_ style: UIAlertController.Style) -> AlertBuilder {
        alertProperties.preferredStyle = style
        return self
    }

    public func onSuccessAction(title: String, _ onSuccess: @escaping ((UIAlertAction) -> Void)) -> AlertBuilder {
        alertActionSuccessProperties.title = title
        self.onSuccess = onSuccess
        return self
    }

    public func onCancelAction(title: String, _ onCancel: @escaping ((UIAlertAction) -> Void)) -> AlertBuilder {
        alertActionCancelProperties.title = title
        self.onCancel = onCancel
        return self
    }

    @discardableResult
    public func show() -> UIAlertController {
        let alert = UIAlertController(title: alertProperties.title, message: alertProperties.message, preferredStyle: alertProperties.preferredStyle)
        let successAction = UIAlertAction(title: alertActionSuccessProperties.title, style: alertActionSuccessProperties.alertActionStyle, handler: onSuccess)
//        successAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(successAction)
        
        let cancelAction = UIAlertAction(title: alertActionCancelProperties.title, style: alertActionCancelProperties.alertActionStyle, handler: onCancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        alert.addAction(cancelAction)

        viewController.present(alert, animated: true, completion: nil)
        return alert
    }
}

/// Factor Pattern to show Alert
///

public enum Alert {

    public static func showAlert(viewController: UIViewController, title: String , message: String, completion: @escaping (_ success: Bool) -> Void) {
        AlertBuilder(viewController: viewController)
            .preferredStyle(.alert)
            .withTitle(title)
            .andMessage(message)
            .onSuccessAction(title: "Ok") { _ in
                completion(true)
            }
            .onCancelAction(title: "Cancel") { _ in
                completion(false)
            }
            .show()
    }

    public static func showAlertToEnableGps(viewController: UIViewController) {
        AlertBuilder(viewController: viewController)
            .preferredStyle(.alert)
            .withTitle("MIRA")
            .andMessage("Your GPS seems to be disabled, do you want to enable it? \n Open Settings > Privacy > Location")
            .onSuccessAction(title: "Go") { _ in
                if let url = URL(string: "App-prefs:root=Privacy&path=LOCATION") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            .onCancelAction(title: "Cancel") { _ in
                UIAlertController().dismiss(animated: true)
            }
            .show()
    }
    
    public static func showErrorAlert(message: String) {
        let alert = CDAlertView(title: "We are Sorry for this Error",
                                message: message,
                                type: .error)
        alert.hasShadow = false
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 1, y: 1)
            alpha = 0
        }
        alert.autoHideTime = 5
        alert.hideAnimationDuration = 0.88
        let doneAction = CDAlertViewAction(title: "Ok")
        alert.add(action: doneAction)
        alert.show()
    }
    
    public static func showSuccessAlert (title:String = "Success",message: String ) {
        let alert = CDAlertView(title: title,
                                message: message,
                                type: .success)
        alert.hasShadow = false
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 1, y: 1)
            alpha = 0
        }
        alert.autoHideTime = 5
        alert.hideAnimationDuration = 0.88
        let doneAction = CDAlertViewAction(title: "Ok")
        alert.add(action: doneAction)
        alert.show()
    }
    
    public static func showError(title:String,message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { action in
            alert.dismiss(animated: true)
        }))
        viewController.present(alert, animated: true)
    }
    
}

