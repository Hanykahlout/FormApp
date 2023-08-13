//
//  VerificationCodeVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 02/08/2023.
//

import UIKit
import OTPFieldView
import IQKeyboardManagerSwift

class VerificationCodeVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var otpCodeTextField: OTPFieldView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    // MARK: - Private Properties
    private var counter = 59
    private let presenter = VerificationCodePresenter()
    private var code = ""
    
    // MARK: - Public Properties
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        verifyButton.isHidden = true
        setupOtpView()
        setUpCodeTimer()
        binding()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        setUpNavigation()
        titleLabel.attributedText = makeEmailAttributedString(email: email)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private Functions
    private func setUpNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)

        navigationItem.title = "Forget Password"
        
        let backButton = UIButton()
        backButton.corner_radius = 10
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "Back")!, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
    }
    
    private func setupOtpView(){
        otpCodeTextField.backgroundColor = .clear
        otpCodeTextField.defaultBackgroundColor = .clear
        otpCodeTextField.filledBackgroundColor = UIColor(hex: "#FD841F",alpha: 0.5)
        otpCodeTextField.fieldsCount = 4
        otpCodeTextField.fieldBorderWidth = 2
        otpCodeTextField.defaultBorderColor =  UIColor(hex: "#EEEEEE")
        otpCodeTextField.filledBorderColor =  UIColor(hex: "#FD841F")
        otpCodeTextField.requireCursor = false
        otpCodeTextField.displayType = .roundedCorner
        otpCodeTextField.fieldSize = 60
        otpCodeTextField.separatorSpace = 16
        otpCodeTextField.otpInputType = .numeric
        otpCodeTextField.shouldAllowIntermediateEditing = false
        otpCodeTextField.delegate = self
        otpCodeTextField.initializeUI()
        
    }
    
    private func makeAttributedString() -> NSAttributedString {
        let defaultFont = UIFont(name: "Urbanist-Regular", size: 16)!
        
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font:defaultFont,
            .foregroundColor: UIColor.white
        ]
        
        let counterAttributes: [NSAttributedString.Key: Any] = [
            .font:defaultFont,
            .foregroundColor: UIColor(hex: "#FD841F")
        ]
        
        let defaultString1 = NSMutableAttributedString(string: "Resend code in", attributes: defaultAttributes)
        
        let counterString = NSAttributedString(string: " \(counter) ", attributes: counterAttributes)
        
        let defaultString2 = NSMutableAttributedString(string: "s", attributes: defaultAttributes)
        
        defaultString1.append(counterString)
        defaultString1.append(defaultString2)
        return defaultString1
    }
    
    private func makeEmailAttributedString(email:String) -> NSAttributedString {
        let defaultFont = UIFont(name: "Urbanist-Regular", size: 16)!
        let emailFont = UIFont(name: "Urbanist-Bold", size: 16)!
        
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font:defaultFont,
            .foregroundColor: UIColor.white
        ]
        
        let emailAttributes: [NSAttributedString.Key: Any] = [
            .font:emailFont,
            .foregroundColor: UIColor(hex: "#FD841F")
        ]
        
        let defaultString = NSMutableAttributedString(string: "Code has been send to ", attributes: defaultAttributes)
        
        let emailString = NSAttributedString(string: email, attributes: emailAttributes)
        
        
        defaultString.append(emailString)
        
        return defaultString
    }
    
    
    private func setUpCodeTimer(){
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.counter > 0{
                self.counter -= 1
                self.counterLabel.attributedText = self.makeAttributedString()
            }else{
                self.counterLabel.isHidden = true
                self.resendButton.isHidden = false
                timer.invalidate()
            }
        }
    }
    
}
// MARK: - Binding
extension VerificationCodeVC{
    private func binding(){
        verifyButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case verifyButton:
            presenter.codeCheck(email: email, code: code)
        case resendButton:
            presenter.restPassword(email: email)
        default:
            break
        }
    }
    
    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - OTP Text Field Delegate
extension VerificationCodeVC:OTPFieldViewDelegate{
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        
        return true
    }
    
    func enteredOTP(otp: String) {
        code = otp
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        verifyButton.isHidden = !hasEnteredAll
        return hasEnteredAll
    }
    
}


// MARK: - Presenter Delegate
extension VerificationCodeVC:VerificationCodePresenterDelegate{
    
}

// MARK: - Set Storyboard
extension VerificationCodeVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}

