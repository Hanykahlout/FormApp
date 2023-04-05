//
//  FormTypeNoteCell.swift
//  FormApp
//
//  Created by heba isaa on 25/01/2023.
//

import UIKit

protocol FormTypeNoteCellDelegate{
    func statusPickerAction(data:[String],indexPath:IndexPath)
    func reasonPickerAction(reasons:[FailReasonData],indexPath:IndexPath)
}

typealias FormTypeCellDelegate = FormTypeNoteCellDelegate & UIViewController


class FormTypeNoteCell: UITableViewCell,NibLoadableView {
    
    @IBOutlet weak var FormTypeSubtitle: UILabel!
    
    @IBOutlet weak var formTypeStatus: UITextField!
    @IBOutlet weak var formTitleNote: UITextField!
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var reasonTextField: UITextField!
    
    
    var indexPath:IndexPath?
    weak var delegate:FormTypeCellDelegate?
    var status:[String] = []
    private var statusGesture:UITapGestureRecognizer?
    private var reasons:[FailReasonData]?
    override func awakeFromNib() {
        super.awakeFromNib()
        statusGesture = UITapGestureRecognizer(target: self, action: #selector(formTypeStatusAction))
        formTypeStatus.addGestureRecognizer(statusGesture!)
        reasonTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reasonAction)))
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
        let system = obj.system
        reasons = obj.fail_reasons
        FormTypeSubtitle.text = obj.title ?? ""
        formTypeStatus.text = obj.status ?? ""
        formTitleNote.text = obj.note ?? ""
        reasonTextField.text = obj.reason ?? ""
        reasonTextField.isHidden = obj.status != "fail"
        switch system{
        case "NA/pass/fail":
            status = ["N/A","pass","fail"]
            statusTitleLabel.text = "Select your status"
        case "yes/no":
            status = ["Yes","No"]
            statusTitleLabel.text = "Select your status"
        case "quantity":
            if let statusGesture = statusGesture{
                formTypeStatus.removeGestureRecognizer(statusGesture)
            }
            formTypeStatus.placeholder = "Quantity"
            formTypeStatus.keyboardType = .numberPad
            statusTitleLabel.text = "Enter your Quantity"
        default:
            break
        }
    }
    
    @objc private func formTypeStatusAction(){
        guard let indexPath = indexPath else { return }
        delegate?.statusPickerAction(data:status,indexPath: indexPath)
    }
    
    @objc private func reasonAction(){
        guard let indexPath = indexPath else { return }
        delegate?.reasonPickerAction(reasons: reasons ?? [],indexPath: indexPath)
    }
    
    
}

