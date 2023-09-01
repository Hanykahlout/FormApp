//
//  MulitselectionCollectionViewCell.swift
//  FormApp
//
//  Created by Hany Alkahlout on 8/31/23.
//

import UIKit

protocol MulitselectionCellDelegate{
    func deleteSelection(indexPath:IndexPath)
}

typealias MulitselectionVCCellDelegate = MulitselectionCellDelegate & UIViewController

class MulitselectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate:MulitselectionVCCellDelegate?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        binding()
    }
    
}

// MARK: - Binding

extension MulitselectionCollectionViewCell{
    
    private func binding(){
        deleteButton.addTarget(self, action: #selector(bindingAction), for: .touchUpInside)
    }
    
    @objc private func bindingAction(_ sender:UIButton){
        switch sender{
        case deleteButton:
            guard let indexPath = indexPath else { return }
            delegate?.deleteSelection(indexPath: indexPath)
        default:
            break
        }
    }
    
}
