//
//  AppDelegate.swift
//  Maodou
//
//  Created by huangrui on 2024/4/15.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import WLEmptyState

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppCenter.logLevel = .verbose
        
        AppCenter.start(withAppSecret: "3e548afc-1840-42ea-946e-af248d6527ab", services:[
          Analytics.self,
          Crashes.self
        ])
        
        MDLocalized.shareInstance().initLanguage()
        MDLocalized.shareInstance().setLanguage("en")
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: { _, _ in }
            )
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        application.registerForRemoteNotifications()
        
        let notification = UserDefaults.standard.value(forKey: kNotificationState)
        if notification == nil {
            UserDefaults.standard.setValue(true, forKey: kNotificationState)
            UserDefaults.standard.synchronize()
        }
        
        WLEmptyState.configure()
        
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

extension AppDelegate {
    
}
