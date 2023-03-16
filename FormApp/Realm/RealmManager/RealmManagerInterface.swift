//
//  RealmManagerInterface.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 21/10/2022.
//
//

import Foundation
import RealmSwift

// MARK: - Realm Manager Interface
protocol RealmManagerInterface{
    func saveObjects<T: Object>(_ objects: [T])
    func saveObject<T: Object>(_ object: T)
    func fetchObjects<T: Object>(_ type: T.Type) -> [T]?
    func fetchObjects<T: Object>(_ type: T.Type, predicate: NSPredicate) -> [T]?
    func removeObjects<T: Object>(_ objects: [T])
    func removeObject<T: Object>(_ object: T)
    func removeAllObjectsOfType<T: Object>(_ type: T.Type)
    func removeAll()
}
