//
//  AppDelegate.swift
//  FormApp
//
//  Created by Hany Alkahlout on 25/01/2023.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        setupFirebaseMessaging(application)
        Messaging.messaging().delegate = self
        
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


// MARK: - Notificaiton Handling

extension AppDelegate:UNUserNotificationCenterDelegate{
    private func setupFirebaseMessaging(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler([.list,.banner, .sound , .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        
        // Print full message.
        
        if let type = userInfo["gcm.notification.type"] as? String{
            let vc = HomeVC.instantiate()
            if type == "warranty"{
                if let id = userInfo["gcm.notification.model_id"] as? String{
                    vc.workOrderId = String(id)
                }
                
            }else if type == "form" {
                if let id = Int(userInfo["gcm.notification.model_id"] as? String ?? "0") {
                    vc.draftId = id
                }
                
            }
            window?.rootViewController = UINavigationController(rootViewController: vc)
        }
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        
        
        completionHandler()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        print("Reciving Push Notification 2",userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
}


// MARK: - Firebase Messaging
extension AppDelegate:MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // send fcmtoken to server
        if let fcmToken = fcmToken{
            print("FCMToken :: \(fcmToken)")
            try? KeychainWrapper.set(value: fcmToken, key: "FCMTOKEN")
        }
    }
    
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
}

