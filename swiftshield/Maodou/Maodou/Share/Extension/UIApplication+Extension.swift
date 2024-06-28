//
//  UIApplication+OOExtension.swift
//  OOExampleSwift
//
//  Created by huangrui on 2022/7/14.
//

import Foundation
import UIKit

extension UIApplication {
    
    // MARK: - 获取当前屏幕显示的Window
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
            if let window = windowScene
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            } else if let window = UIApplication.shared.delegate?.window{
                return window
            } else{
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
    
    var sceneDelegate: SceneDelegate? {
        var uiScreen: UIScene?
        UIApplication.shared.connectedScenes.forEach { (screen) in
            uiScreen = screen
        }
        return (uiScreen?.delegate as? SceneDelegate)
    }
}


extension UIViewController {
    var topViewController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topViewController
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController ?? navigationController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topViewController ?? tabBarController
        }
        return self
    }
}
