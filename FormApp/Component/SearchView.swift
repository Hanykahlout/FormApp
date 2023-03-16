//
//  SearchView.swift
//  GoodLifeApplocation
//
//  Created by heba isaa on 05/08/2022.
//

import UIKit

class SearchView: UIView {


    typealias EditingHanlder = ()->Void
           open var endEditingHandler:EditingHanlder?
           open var editingChangeHandler:EditingHanlder?
           open var searchHandler:EditingHanlder?
           open var startHandler : EditingHanlder?
    open var autoCompleteHandler : EditingHanlder?
    
    
           open func startHandler(_ startHandler:@escaping EditingHanlder)->Self{
           self.startHandler=startHandler;
           return self;
           }
           open func autoCompleteHandler(_ autoCompleteHandler:@escaping EditingHanlder)->Self{                           self.autoCompleteHandler=autoCompleteHandler;
                           return self;
           }
           open func endEditingHandler(_ endEditingHandler:@escaping EditingHanlder)->Self{
               self.endEditingHandler=endEditingHandler;
               return self;
           }
           open func editingChangeHandler(_ editingChangeHandler:@escaping EditingHanlder)->Self{
               self.editingChangeHandler=editingChangeHandler;
               return self;
           }
      open var contentView : UIView?
      @IBOutlet weak var txtSearch: UITextField!
      @IBOutlet weak var btnSearch: UIButton!
        
           @IBInspectable var searchIcon: UIImage? {
               get {
                   return self.btnSearch?.image(for: .normal);
               }
               set {
                   self.btnSearch?.setImage(newValue, for: .normal);
               }
           }
           @IBInspectable var text: String? {
               get {
                   return self.txtSearch.text;
               }
               set {
                   self.txtSearch.text = newValue;
               }
           }
           @IBInspectable var placeHolder: String? {
               get {
                   return self.txtSearch.placeholder;
               }
               set {
                   self.txtSearch.placeholder = newValue;
               }
           }
       
             override init(frame: CGRect) {
                 super.init(frame: frame)
                 xibSetup()
             }
    
  
             required init?(coder aDecoder: NSCoder) {
                 super.init(coder: aDecoder)
                 xibSetup()
             }

        func  xibSetup(){
            contentView = loadViewFromNib()
            contentView?.frame = bounds
            addSubview(contentView!)
            self.contentView!.translatesAutoresizingMaskIntoConstraints = false
                 addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["childView": contentView]))
                 addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["childView": contentView]))
                 
            self.setupData()
                 
        }
        open func loadViewFromNib() -> UIView!{
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            return view
        }
        open func setupData(){
            self.txtSearch.textColor = UIColor(named: "button")
            self.txtSearch.addTarget(self, action:#selector(self.editingChange), for: .editingChanged);
            self.txtSearch.addTarget(self, action:#selector(self.endChange), for: .editingDidEnd);
            self.txtSearch.delegate=self;
        }
            @objc private func endChange(){
             self.endEditingHandler?()
                if self.txtSearch.text?.count == 0 {
            }
            }
            @objc private func editingChange(){
                editingChangeHandler?();
//                if  self.txtSearch.text?.count == 3{
//                    self.startHandler?()
//
//                }
//                else if self.txtSearch.text!.count > 3{
//                    autoCompleteHandler?()
//                }else{
//                    self.endEditingHandler?()
//                    print("reweddfdf")
//                }
                
    }
    }
    extension SearchView:UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField.returnKeyType == .search {
                textField.resignFirstResponder();
            }
            return true;
        }
    }
