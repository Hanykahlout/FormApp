//
//  TableViewHelper.swift
//  GoodLifeApplocation
//
//  Created by heba isaa on 27/07/2022.
//

import Foundation
import UIKit
 
 
extension UITableView {

    func register<T: UITableViewCell>(_ class: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: NibLoadableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
