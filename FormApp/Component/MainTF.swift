//  MainTF.swift
//  Rakwa
//  Created by macbook on 9/9/21.

import UIKit
 class MainTF:UIViewFromNib{
    
    @IBOutlet   weak var valueTxt: UITextField!
    @IBOutlet  weak var titleTxt: UILabel!
    @IBOutlet  weak var img: UIImageView!
    
    @IBInspectable var image: UIImage? {
         didSet {
             updateView()
         }
     }
    
    @IBInspectable var text:String?{
        didSet {
        textViewEdit()
      }
    }
     
     @IBInspectable var placeholderTxt:String?{
         didSet {
             placeholderTextViewEdit()
       }
     }

    func updateView() {
         img.image = self.image
             
         
     }
    func textViewEdit() {
        titleTxt.text = self.text
             
         
     }
     func placeholderTextViewEdit() {
         valueTxt.placeholder = self.placeholderTxt
              
          
      }
}
