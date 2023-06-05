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
    func showPickerVC(type: String,parentIndex:Int,childIndex:Int)
    func updateNewBoxData(text:String,parentIndex:Int,childIndex:Int)
}

typealias FormTypeCellDelegate = FormTypeNoteCellDelegate & UIViewController


class FormTypeNoteCell: UITableViewCell,NibLoadableView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainStackView: UIStackView!
    
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
    
    
    weak var delegate:FormTypeCellDelegate?
    var indexPath:IndexPath?
    var status:[String] = []
    private var statusGesture:UITapGestureRecognizer?
    private var reasons:[FailReasonData]?
    private var newBoxs:[NewBoxData] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusGesture = UITapGestureRecognizer(target: self, action: #selector(formTypeStatusAction))
        dateTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateSelectionAction)))
        formTypeStatus.addGestureRecognizer(statusGesture!)
        reasonTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reasonAction)))
        setUpTableView()
    }
    
    
    func configureCell(obj:DataDetails){
        
        let system = obj.system
        priceLabel.text = "Price: $\(obj.price ?? "0")"
        priceLabel.isHidden = obj.show_price != "1"
        reasons = obj.fail_reasons
        FormTypeSubtitle.text = obj.title ?? ""
        formTitleNote.text = obj.note ?? ""
        reasonTextField.text = obj.reason ?? ""
        reasonTextField.isHidden = obj.status != "fail"
        newBoxs = obj.new_boxes ?? []
        tableViewHeight.constant = CGFloat(newBoxs.count) * 90
        if !newBoxs.isEmpty{
            tableView.reloadData()
        }
        
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


extension FormTypeNoteCell:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "NewBoxTableViewCell", bundle: nil),forCellReuseIdentifier: "NewBoxTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newBoxs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewBoxTableViewCell", for: indexPath) as! NewBoxTableViewCell
        cell.setData(data: newBoxs[indexPath.row],index: indexPath.row)
        cell.boxTextField.addTarget(self, action: #selector(boxTextFieldAction), for: .editingDidEnd)
        cell.boxTextField.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @objc private func boxTextFieldAction(_ textField:UITextField){
        delegate?.updateNewBoxData(text: textField.text!, parentIndex: indexPath?.row ?? 0, childIndex: textField.tag)
    }
    
}


// MARK: - Table View Cell Delegate
extension FormTypeNoteCell:NewBoxCellDelegate{
    func showPickerVC(type: String,index:Int) {
        delegate?.showPickerVC(type: type,parentIndex: indexPath?.row ?? 0,childIndex: index)
    }
}
