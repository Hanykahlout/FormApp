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
    func datePickerAction(indexPath:IndexPath)
}

typealias FormTypeCellDelegate = FormTypeNoteCellDelegate & UIViewController


class FormTypeNoteCell: UITableViewCell,NibLoadableView {
    
    @IBOutlet weak var FormTypeSubtitle: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusWithoutSelectionView: UIView!
    @IBOutlet weak var statusWithoutSelectionTextField: UITextField!
    @IBOutlet weak var statusWithoutSelectionLabel: UILabel!
    
    @IBOutlet weak var formTypeStatus: UITextField!
    @IBOutlet weak var formTitleNote: UITextField!
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    var indexPath:IndexPath?
    weak var delegate:FormTypeCellDelegate?
    var status:[String] = []
    private var statusGesture:UITapGestureRecognizer?
    private var reasons:[FailReasonData]?
    override func awakeFromNib() {
        super.awakeFromNib()
        statusGesture = UITapGestureRecognizer(target: self, action: #selector(formTypeStatusAction))
        dateTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateSelectionAction)))
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
        priceLabel.text = "Price: $\(obj.price ?? "0")"
        priceLabel.isHidden = obj.show_price != "1"
        reasons = obj.fail_reasons
        FormTypeSubtitle.text = obj.title ?? ""
        formTitleNote.text = obj.note ?? ""
        reasonTextField.text = obj.reason ?? ""
        reasonTextField.isHidden = obj.status != "fail"
        switch system{
        case "NA/pass/fail":
            formTypeStatus.text = obj.status ?? ""
            defualtCellSystem(withArr:["N/A","pass","fail"])
        case "yes/no":
            formTypeStatus.text = obj.status ?? ""
            defualtCellSystem(withArr:["Yes","No"])
        case "quantity":
            statusView.isHidden = true
            statusWithoutSelectionView.isHidden = false
            dateView.isHidden = true
            
            statusWithoutSelectionTextField.text = obj.status ?? ""
            statusWithoutSelectionTextField.placeholder = "Quantity"
            statusWithoutSelectionTextField.keyboardType = .numberPad
            statusWithoutSelectionLabel.text = "Enter your Quantity"
        case "text":
            statusView.isHidden = true
            statusWithoutSelectionView.isHidden = false
            dateView.isHidden = true
            
            statusWithoutSelectionTextField.text = obj.status ?? ""
            statusWithoutSelectionTextField.placeholder = "Text"
            statusWithoutSelectionTextField.keyboardType = .default
            statusWithoutSelectionLabel.text = "Enter your text"

        case "date":
            dateTextField.text = obj.status ?? ""
            statusView.isHidden = true
            statusWithoutSelectionView.isHidden = true
            dateView.isHidden = false
        case "currency":
            statusView.isHidden = true
            statusWithoutSelectionView.isHidden = false
            dateView.isHidden = true
            
            statusWithoutSelectionTextField.text = obj.status ?? ""
            statusWithoutSelectionTextField.placeholder = "Currency"
            statusWithoutSelectionTextField.keyboardType = .decimalPad
            statusWithoutSelectionLabel.text = "Enter your currency"
        default:
            break
        }
        
        
    }
    
    
    private func defualtCellSystem(withArr arr:[String]){
        statusView.isHidden = false
        statusWithoutSelectionView.isHidden = true
        dateView.isHidden = true
        
        if statusGesture == nil{
            statusGesture = UITapGestureRecognizer(target: self, action: #selector(formTypeStatusAction))
            formTypeStatus.addGestureRecognizer(statusGesture!)
            formTypeStatus.placeholder = "Status"
            statusGesture = nil
        }
        status = arr
        statusTitleLabel.text = "Select your status"
    }
    
    @objc private func formTypeStatusAction(){
        guard let indexPath = indexPath else { return }
        delegate?.statusPickerAction(data:status,indexPath: indexPath)
    }
    
    
    @objc private func dateSelectionAction(){
        guard let indexPath = indexPath else { return }
        delegate?.datePickerAction(indexPath:indexPath)
    }
    
    
    
    @objc private func reasonAction(){
        guard let indexPath = indexPath else { return }
        delegate?.reasonPickerAction(reasons: reasons ?? [],indexPath: indexPath)
    }
    
    
}

