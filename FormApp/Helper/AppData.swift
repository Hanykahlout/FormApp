//
//  AppData.swift
//  GoodLifeApplocation
//
//  Created by heba isaa on 27/08/2022.
//

import Foundation
@propertyWrapper
struct Storage<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}


struct AppData {
    
    @Storage(key: "email", defaultValue: "")
    static var email: String
   
    

}
