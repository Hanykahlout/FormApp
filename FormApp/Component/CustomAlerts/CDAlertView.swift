//
//  CDAlertView.swift
//  CDAlertView
//
//  Created by ziad on 16/08/2022.
//

import UIKit

public protocol CDAlertViewActionDelegate: AnyObject {
    func didTap(action: CDAlertViewAction)
}

open class CDAlertViewAction: NSObject {
    public var buttonTitle: String?
    public var buttonTextColor: UIColor?
    public var buttonFont: UIFont?
    public var buttonBackgroundColor: UIColor?

    public weak var delegate: CDAlertViewActionDelegate?

    private var handlerBlock: ((CDAlertViewAction) -> Swift.Bool)?

    public convenience init(title: String?,
                            font: UIFont? = UIFont.systemFont(ofSize: 17),
                            textColor: UIColor? = .black,
                            backgroundColor: UIColor? = nil,
                            handler: ((CDAlertViewAction) -> Swift.Bool)? = nil) {
        self.init()
        buttonTitle = title
        buttonTextColor = textColor
        buttonFont = font
        buttonBackgroundColor = backgroundColor
        handlerBlock = handler
    }

    @objc func didTap() {
        guard let handler = handlerBlock else {
            self.delegate?.didTap(action: self)
            return
        }
        if handler(self) == false {
            return
        }
        self.delegate?.didTap(action: self)
    }
}

open class CDAlertView: UIView {
    
    static let defaultComponentsColor: UIColor = UIColor(red: 50 / 255,
                                                    green: 51 / 255,
                                                    blue: 53 / 255,
                                                    alpha: 1)

    public var actionSeparatorColor: UIColor = defaultComponentsColor.withAlphaComponent(0.12)
    public var titleTextColor: UIColor = defaultComponentsColor
    public var messageTextColor: UIColor = defaultComponentsColor
    public var textFieldTextColor: UIColor = defaultComponentsColor

    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17) {
        didSet {
            titleLabel.font = titleFont
        }
    }

    public var messageFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            messageLabel.font = messageFont
        }
    }

    public var textFieldFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            textField.font = textFieldFont
        }
    }

    public var textFieldReturnKeyType: UIReturnKeyType = .default {
        didSet {
            textField.returnKeyType = textFieldReturnKeyType
        }
    }

    public var textFieldIsSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = textFieldIsSecureTextEntry
        }
    }

    public var textFieldTextAlignment: NSTextAlignment = .left {
        didSet {
            textField.textAlignment = textFieldTextAlignment
        }
    }

    public var textFieldPlaceholderText: String?  {
        didSet {
            textField.placeholder = textFieldPlaceholderText
        }
    }

    public var isTextFieldHidden: Bool = true {
        didSet {
            textField.isHidden = isTextFieldHidden

            if !isTextFieldHidden {
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            }
        }
    }

    public var textFieldKeyboardType: UIKeyboardType = .`default` {
        didSet {
            textField.keyboardType = textFieldKeyboardType
        }
    }

    public var textFieldAutocapitalizationType: UITextAutocapitalizationType = .none {
        didSet {
            textField.autocapitalizationType = textFieldAutocapitalizationType
        }
    }

    public var textFieldAutocorrectionType: UITextAutocorrectionType = .default {
        didSet {
            textField.autocorrectionType = textFieldAutocorrectionType
        }
    }

    public var textFieldBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.9) {
        didSet {
            textField.backgroundColor = textFieldBackgroundColor
        }
    }

    public var textFieldTintColor: UIColor = UIColor.white.withAlphaComponent(0.9) {
        didSet {
            textField.tintColor = textFieldTintColor
        }
    }

    public var textFieldText: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    public weak var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = textFieldDelegate
        }
    }

    public var hasRoundCorners = true

    public var customView: UIView?

    public var canHideWhenTapBack = false

    public var hideAnimations: CDAlertAnimationBlock?

    public var hideAnimationDuration: TimeInterval = 0.5

    public var autoHideTime: TimeInterval?
    
    public var textFieldHeight: CGFloat = 35.0

    public var isActionButtonsVertical: Bool = false

    public var hasShadow: Bool = true

    public var isHeaderIconFilled: Bool = false

    public var alertBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.9)

    public var circleFillColor: UIColor?

    public var popupWidth: CGFloat = 255.0

    public typealias CDAlertAnimationBlock = ((_ center: inout CGPoint, _ transform: inout CGAffineTransform, _ alpha: inout CGFloat) -> Void)?

    public var popupCenterYPositionBeforeKeyboard: CGFloat?

    public var popupView: UIView = UIView(frame: .zero)

    public var popupCenter: CGPoint {
        get {
            return popupView.center
        }
        set {
            popupView.center = newValue
        }
    }

    public var popupTransform: CGAffineTransform {
        get {
            return popupView.transform
        }
        set {
            popupView.transform = newValue
        }
    }

    public var popupAlpha: CGFloat {
        get {
            return popupView.alpha
        }
        set {
            popupView.alpha = newValue
        }
    }

    public struct CDAlertViewConstants {
        let headerHeight: CGFloat = 56
        let headerHeightWithoutCircle: CGFloat = 30
        let activeVelocity: CGFloat = 150
        let minVelocity: CGFloat = 300
        let separatorThickness: CGFloat = 1.0 / UIScreen.main.scale
    }

    public var buttonsHeight: CGFloat {
        
        return self.actions.count > 0 ? 44.0 : 0
        
    }

    public var popupViewInitialFrame: CGRect!
    public let constants = CDAlertViewConstants()
    public var backgroundView: UIView = UIView(frame: .zero)
    public var coverView: UIView = UIView(frame: .zero)
    public var completionBlock: ((CDAlertView) -> Swift.Void)?
    public var contentStackView: UIStackView = UIStackView(frame: .zero)
    public var buttonContainer: UIStackView = UIStackView(frame: .zero)
    public var headerView: CDAlertHeaderView!
    public var buttonView: UIView = UIView(frame: .zero)
    public var titleLabel: UILabel = UILabel(frame: .zero)
    public var messageLabel: UILabel = UILabel(frame: .zero)
    public var textField: UITextField = UITextField(frame: .zero)
    public var type: CDAlertViewType!
    public var isKeyboardVisible: Bool = false
    weak public var hideTimer: Timer!
    public var headerHeight: CGFloat = CDAlertViewConstants().headerHeight
    
    public lazy var actions: [CDAlertViewAction] = [CDAlertViewAction]()

    public convenience init(title: String?,
                            message: String?,
                            type: CDAlertViewType? = nil) {
        self.init(frame: .zero)
        
        self.backgroundColor = CDAlertView.defaultComponentsColor.withAlphaComponent(0.4)
        
        if let title = title {
            titleLabel.text = title
        }

        if let message = message {
            messageLabel.text = message
        }

        self.type = type
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if hasShadow {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: popupView.bounds.size.height))
            path.addLine(to: CGPoint(x: 0, y: headerHeight))
            path.addLine(to: CGPoint(x: popupView.bounds.size.width,
                                     y: CGFloat(headerHeight - 5)))
            path.addLine(to: CGPoint(x: popupView.bounds.size.width,
                                     y: popupView.bounds.size.height))
            path.close()
            
            popupView.setShadow(withPath: path)
        }
    }


}

extension CDAlertView: CDAlertViewActionDelegate {
    public func didTap(action: CDAlertViewAction) {
        self.hide(animations: self.hideAnimations, isPopupAnimated: true)
    }
}

extension CDAlertView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIView {
    public func setShadow(withPath path: UIBezierPath) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
        layer.shadowPath = path.cgPath
    }
}
