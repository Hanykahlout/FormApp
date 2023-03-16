//
//  FormTypeNoteCell.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit

protocol FormTypeNoteCellDelegate{
    func statusPickerAction(data:[String],indexPath:IndexPath)
}

typealias FormTypeCellDelegate = FormTypeNoteCellDelegate & UIViewController


class FormTypeNoteCell: UITableViewCell,NibLoadableView {
    
    @IBOutlet weak var FormTypeSubtitle: UILabel!
    
    @IBOutlet weak var formTypeStatus: UITextField!
    @IBOutlet weak var formTitleNote: UITextField!
    
    var indexPath:IndexPath?
    weak var delegate:FormTypeCellDelegate?
    var status:[String] = ["N/A","pass","fail"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        formTypeStatus.pickerDelegate=self
        //        formTypeStatus.dataSource=self
        formTypeStatus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(formTypeStatusAction)))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        // invoke superclass implementation
        super.prepareForReuse()
    }
    
    func  configureCell(obj:DataDetails){
        FormTypeSubtitle.text = obj.title ?? ""
        formTypeStatus.text = obj.status ?? ""
        formTitleNote.text = obj.note ?? ""
    }
    
    @objc private func formTypeStatusAction(){
        guard let indexPath = indexPath else { return }
        delegate?.statusPickerAction(data:status,indexPath: indexPath)
    }
    
}


    //MARK: - confirm to DatePickerDelegate
//}
//extension FormTypeNoteCell:UITextFieldDataPickerDelegate,UITextFieldDataPickerDataSource{
//
//
//    func textFieldDataPicker(_ textField: UITextFieldDataPicker, numberOfRowsInComponent component: Int) -> Int {
//        status.count
//    }
//
//    func textFieldDataPicker(_ textField: UITextFieldDataPicker, titleForRow row: Int, forComponent component: Int) -> String? {
//        return status[row]
//    }
//
//    func numberOfComponents(in textField: UITextFieldDataPicker) -> Int {
//        1
//    }
//
//    func textFieldDataPicker(_ textField: UITextFieldDataPicker, didSelectRow row: Int, inComponent component: Int) {
//
//        formTypeStatus.setTextFieldTitle(title: status[row])
//
//    }
//
//}


