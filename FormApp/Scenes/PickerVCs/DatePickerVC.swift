//
//  DatePickerVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 07/04/2023.
//

import UIKit

class DatePickerVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var dateSelected: ((_ date:String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
   
    @IBAction func doneAction(_ sender: Any) {
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = .init(identifier: "en")
        let dateString = dateFormatter.string(from: date)
        dateSelected?(dateString)
        self.dismiss(animated: true)
    }
    
    
}

extension DatePickerVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
    
}
