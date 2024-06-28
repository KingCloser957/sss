//
//  SceneDelegate.swift
//  Maodou
//
//  Created by huangrui on 2024/4/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        setupUI()
    }
    
    func setupUI() {
        let secondLaunch = UserDefaults.standard.bool(forKey: "kSecondLaunch")
        if !secondLaunch {
            UserDefaults.standard.setValue(true, forKey: "kSecondLaunch")
            UserDefaults.standard.synchronize()
        }
        guard let _ = MDUserInfoManager.share.user() else {
            let vc =  MDPrivacyLoginViewController()
            vc.enterAppBlock = { [weak self] in
                let tabBarController = MDBaseTabBarController()
                self?.window?.rootViewController = tabBarController
                self?.window?.makeKeyAndVisible()
            }
            let nav = MDBaseNavigationController(rootViewController: vc)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            return
        }
        let tabBarController = MDBaseTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func logout() {
        let vc =  MDPrivacyLoginViewController()
        vc.enterAppBlock = { [weak self] in
            let tabBarController = MDBaseTabBarController()
            self?.window?.rootViewController = tabBarController
        }
        let nav = MDBaseNavigationController(rootViewController: vc)
        window?.rootViewController = nav
    }
    
    func listeningNetConnectionState() {
        MDNetworkManager.observerNetConnectionState { [weak self] (state) in
            netConnectionState = state
            let notificationName = NSNotification.Name(rawValue: "kNetworkConnectionState")
            NotificationCenter.default.post(name: notificationName,
                                            object: nil,
                                            userInfo: ["state": state])
            if netConnectionState == .disconnect {
                debugPrint("网络断开了")
                self?.showNoNetworkPopupView()
            } else {
                self?.removeNoNetworkPopupView()
            }
        }
    }
    
    func showNoNetworkPopupView() {
        if isShowNoNetworkView {
            return
        }
        let view = MDNoNetworkPopupView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        view.tipView.tipLab.text = "没有找到网络，请检查您的网络是否可用"
        view.backgroundColor = UIColor.clear
        view.show()
    }

    func removeNoNetworkPopupView() {
        let window = UIApplication.shared.currentWindow
        guard let subviews = window?.subviews else {
            return
        }
        for view in subviews {
            if let nonetview = view as? MDNoNetworkPopupView {
                nonetview.dismiss()
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

//推送
extension AppDelegate {
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(.newData)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        guard let userInfo = userInfo as? [String: Any] else { return }
        notificationAction(userInfo)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                openSettingsFor notification: UNNotification?) {

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let linkUrl = response.notification.request.content.userInfo["linkUrl"] as? String else {
            return
        }
        guard let linkDict = linkUrl.description.convertToDictinary() else {
            return
        }
        notificationAction(linkDict)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

    }
}

extension AppDelegate {

    func notificationAction(_ userInfo: [String: Any]) {
        
    }
}
