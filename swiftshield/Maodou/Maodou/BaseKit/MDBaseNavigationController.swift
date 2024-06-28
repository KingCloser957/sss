//
//  MDBaseNavigationController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = self
        }
    }

    func setupAppearance() {

        let dict = [NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.font: UIFont.medium(20)]
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.backgroundColor = .clear
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

        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backBtn = UIButton.init(type: .custom)
            backBtn.setImage(UIImage.init(named: "back"), for: .normal)
            backBtn.size = CGSize.init(width: 44.0, height: 44.0)
            backBtn.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
            let leftItem = UIBarButtonItem.init(customView: backBtn)
            viewController.navigationItem.leftBarButtonItem = leftItem
        }
        super.pushViewController(viewController, animated: animated)
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        guard presentedViewController == nil else { return }
        guard viewControllerToPresent.isBeingPresented == false else { return }
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    @objc
    func navBackAction() {
        popViewController(animated: true)
    }

    @objc
    func dismissAction() {
        dismiss(animated: true)
    }

    deinit {
        Log.debug(String(describing: object_getClass(self)))
    }

}

extension MDBaseNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if viewControllers.count < 2 || visibleViewController == viewControllers.first {
                return false
            }
        }
        return true
    }

}
