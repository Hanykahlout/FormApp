
import UIKit
import SVProgressHUD


class PickerVC: UIViewController {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var searchBar: SearchView!
    @IBOutlet weak var searchBarMainView: UIView!
    
    
    var arr_data:[String] = [] {
        didSet{
            index = 0
            if !arr_data.isEmpty{
                name = arr_data.first!
                picker?.selectRow(0, inComponent: 0, animated: false)
            }
        }
    }

    var name:String = ""
    var index : Int = 0
    var delegate : ((_ name: String ,_ index:Int) -> Void)?
    var searchAction: ((_ searchText:String) -> Void)?
    var newPageAction: ((_ currentPage:Int,_ search:String) -> Void)?
    var searchBarHiddenStatus:Bool=false
    var searchText = ""
    
    var withPagination = false
    var currentPage = 1
    var totalPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.txtSearch.clearButtonMode = .always
        configGUI()
        searchBarMainView.isHidden = searchBarHiddenStatus
        searchBarStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !arr_data.isEmpty{
            name = arr_data[index]
            picker.selectRow(index, inComponent: 0, animated: false)
        }
        searchBar.text = searchText
        
    }
    
    
    func searchBarStatus(){
        if searchBarHiddenStatus == false{
            searchBar.btnSearch.addTarget(self, action: #selector(searchActioon), for: .touchUpInside)
        }
    }
    
    @objc func searchActioon(_ sender : UIButton ) {
        searchBar.text = searchBar.text?.trimmingCharacters(in: .whitespaces)
        searchText = searchBar.text!
        currentPage = 1
        searchAction?(searchBar.text!)
    }
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        self.picker.delegate = self
        self.btnNext.setTitle("Done", for: .normal)
        self.btnCancel.setTitle("Cancel", for: .normal)
        
    }
    
    //MARK: - Button Action
    //------------------------------------------------------
    
    @IBAction func btnSubmit_Click(_ sender: UIButton) {
        //        if arr_data.contains("No items found") && arr_data.count == 1 {
        
        if  arr_data.count == 0 {
            self.dismiss(animated: true, completion: nil)
        }else{
            delegate!(name, index)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancel_Click(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension PickerVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr_data.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr_data[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        let item = arr_data[row]
        attributedString = NSAttributedString(string: item, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        
        return attributedString
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = arr_data[row]
        
        if withPagination && arr_data.count - 1 == row && currentPage < totalPages{
            currentPage += 1
            newPageAction?(currentPage,searchBar.text!)
        }

        
        return pickerLabel!
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 35.0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arr_data.count != 0 {
            if pickerView.tag == 0 {
                
                print(arr_data[row])
                self.name = (arr_data[row])
                self.index = row
                
            }
        }
    }
    
}

extension PickerVC:Storyboarded{
    static var storyboardName: StoryboardName = .main
}
