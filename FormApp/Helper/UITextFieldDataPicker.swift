
import UIKit.UITextField
import UIKit.UIPickerView

@IBDesignable
final public class UITextFieldDataPicker: UITextField,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    
    
    
    private let picker = UIPickerView()
    private let toolbar = UIToolbar()
    private let textPadding: CGFloat = 23
    private var padding = UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 5)
    
    var dataSource:UITextFieldDataPickerDataSource!{didSet{
        DispatchQueue.main.async {self.picker.reloadAllComponents()}}}
    var pickerDelegate:UITextFieldDataPickerDelegate!
    
     
    
    @IBInspectable var withToolbar:Bool = true {
        didSet{
             
            addToolbar()
        }
    }
    
    @IBInspectable var hideInputViewOnSelect:Bool = false
    
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                return false
            }
            return super.canPerformAction(action, withSender: sender)
       }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            return CGRect(x: bounds.width - 30, y: 0, width: 20 , height: bounds.height)
        }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
       }
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
       }
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
       }
    
   

     


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    
    
    



 
    func reloadData(){
        DispatchQueue.main.async {self.picker.reloadAllComponents()}
        
    }
    
    
    
    private func setup() {
        addToolbar()
        self.inputView = self.picker
        picker.delegate = self
        picker.dataSource = self
        self.inputAccessoryView = self.toolbar
        self.showArrowshape()
        
 
    }
    
    
    
    
    private func showArrowshape(){
 
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(systemName: "chevron.down")
              rightView = imageView
            padding = UIEdgeInsets(top: 0, left: textPadding , bottom: 0, right: 35 )
    }
    
    
     func addToolbar() {
         if withToolbar{
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(removeToolBar))

        toolbar.setItems([space, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
             toolbar.sizeToFit()
             
         }else{
             self.inputAccessoryView = nil
         }
    }
     

    @objc func removeToolBar() {
        self.resignFirstResponder()
    }
    
    func  setTextFieldTitle(title:String){
        self.text = title
    }
        
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let dataSource = self.dataSource else {
            fatalError("please confirm the data source for \(self)")
        }
        return dataSource .numberOfComponents(in: self)
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let dataSource = self.dataSource else {
            fatalError("please confirm the data source for \(self)")
        }
        return dataSource.textFieldDataPicker(self, numberOfRowsInComponent: component)
    }
 
  
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let dataSource = self.dataSource else {
            fatalError("please confirm the data source for \(self)")
        }
        return dataSource.textFieldDataPicker(self, titleForRow: row, forComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let delegate = self.pickerDelegate else {
            fatalError("please confirm the delegate for \(self)")
        }
        
        delegate.textFieldDataPicker(self, didSelectRow: row, inComponent: component)
        if hideInputViewOnSelect{
            self.resignFirstResponder()
            
        }
    }
  
}





protocol UITextFieldDataPickerDataSource{
    
    func textFieldDataPicker(_ textField: UITextFieldDataPicker, numberOfRowsInComponent component: Int) -> Int
 
  
    func textFieldDataPicker(_ textField: UITextFieldDataPicker, titleForRow row: Int, forComponent component: Int) -> String?
    func numberOfComponents(in textField: UITextFieldDataPicker) -> Int
}


protocol UITextFieldDataPickerDelegate{
    func textFieldDataPicker(_ textField: UITextFieldDataPicker, didSelectRow row: Int, inComponent component: Int)
}

