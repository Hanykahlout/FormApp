//
//  DatePickerVC.swift
//  FormApp
//
//  Created by Hany Alkahlout on 07/04/2023.
//

import UIKit

class DatePickerVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var dateSelected: ((_ stringDate:String,_ date:Date) -> Void)?
    var dateFormat = "yyyy/MM/dd"
    var selectedDate:Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let date = selectedDate{
            datePicker.date = date
        }
    }
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
   
    @IBAction func doneAction(_ sender: Any) {
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = .init(identifier: "en")
        let dateString = dateFormatter.string(from: date)
        dateSelected?(dateString,date)
        self.dismiss(animated: true)
    }
    
    
}

extension DatePickerVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
    
}
