//
//  MDBrowserNavigtionViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDBrowserNavigtionViewController: MDBaseNavigationController {
    
    override func setupAppearance() {

        let dict = [NSAttributedString.Key.foregroundColor: UIColor.hexColor(0x000000),
                    NSAttributedString.Key.font: UIFont.medium(14)]
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.backgroundColor = .white
            barApp.titleTextAttributes = dict as [NSAttributedString.Key : Any]
            barApp.backgroundEffect = nil
            barApp.shadowImage = UIImage()
            barApp.shadowColor = nil
            navigationBar.scrollEdgeAppearance = barApp
            navigationBar.standardAppearance = barApp
        } else {
            navigationBar.titleTextAttributes = dict as [NSAttributedString.Key : Any]
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }

        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        guard presentedViewController == nil else { return }
        guard viewControllerToPresent.isBeingPresented == false else { return }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

}
