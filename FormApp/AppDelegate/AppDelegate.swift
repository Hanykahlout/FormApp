//
//  AppDelegate.swift
//  FormApp
//
//  Created by Hany Alkahlout on 25/01/2023.
//

import UIKit
import IQKeyboardManagerSwift



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let barAppearance = UINavigationBar.appearance()
        barAppearance.barTintColor = UIColor.blue
        barAppearance.tintColor = UIColor.white
        barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in}
        
        AppManager.shared.monitorNetwork {
            UserDefaults.standard.set(true, forKey: "internet_connection")
        } notConectedAction: {
            UserDefaults.standard.set(false, forKey: "internet_connection")
        }
        IQKeyboardManager.shared.enable = true
        
        RealmManager.sharedInstance.checkMigration()
        
        AppManager.shared.updateOnline(startDate: Date(), endDate: nil) { result in }
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
