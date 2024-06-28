//
//  MDBaseTabBarController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
//        tabBar.isTranslucent = true

        if #available(iOS 13.0, *) {
            let tabbar = UITabBar.appearance()
            tabbar.tintColor = UIColor.hexColor(0xFFFFFF)
            tabbar.unselectedItemTintColor = UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.6)
        } else {
            let appearance = UITabBarItem.appearance()
            appearance.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.6) as Any,
                                                  .font: UIFont.medium(10)],
                                                 for: .normal)
            appearance.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0xFFFFFF) as Any,
                                                  .font: UIFont.medium(10)],
                                                 for: .selected)
        }

//        if #available(iOS 13.0, *) {
//            let apperance = tabBar.standardAppearance
//            apperance.configureWithTransparentBackground()
//            tabBar.standardAppearance = apperance
//        } else {
//            let image = UIImage.image(color: UIColor.clear)
//            tabBar.backgroundImage = image
//            tabBar.shadowImage = image
//            tabBar.isTranslucent = true
//        }


        let homeVC = MDHomeViewController()
        setupItem(vc: homeVC, title: "HOME_TITTLE".localizable(), imageName: "tabbar_home",isWebBrower: false)

        let upgradeVC = MDSafariViewController()
        setupItem(vc: upgradeVC, title: "BROWER_TITTLE".localizable(), imageName: "tabbar_vpay_1",isWebBrower: true)

        let mineVC = MDMineViewController()
        setupItem(vc: mineVC, title: "SETTINGS_TITLE".localizable(), imageName: "tabbar_my",isWebBrower: false)
    }

    private func setupItem(vc: MDBaseViewController, title: String, imageName: String,isWebBrower:Bool) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")

        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.6) as Any,
                                              .font: UIFont.medium(10)],
                                             for: .normal)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0xFFFFFF) as Any,
                                              .font: UIFont.medium(10)],
                                             for: .selected)
        var nav:MDBaseNavigationController?
        if !isWebBrower {
            nav = MDBaseNavigationController(rootViewController: vc)
        } else {
            nav = MDBrowserNavigtionViewController(rootViewController: vc)
        }
        addChild(nav!)
    }

    override var selectedIndex: Int {
        didSet {
            
        }
    }

    deinit {
        Log.debug(String(describing: object_getClass(self)))
    }

}

extension MDBaseTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.firstIndex(of: item)
        Log.info("\(index)")
//        if index == 1 {
//            tabBar.isHidden = true
//        } else {
//            tabBar.isHidden = false
//        }
//        if let index = tabBar.items?.firstIndex(of: item) {
//            let imgList = getImageList()
//            for idx in 0..<3 {
//                let obj = tabBar.items![idx]
//                if index == 0 {
//                    let imgName = "\(imgList[idx])_1"
//                    obj.image = UIImage(named: imgName)
//                    obj.selectedImage = UIImage(named: "\(imgName)_selected")
//                    obj.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x000000) as Any,
//                                                          .font: UIFont.medium(10)],
//                                                         for: .normal)
//                    obj.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0xFFFFFF) as Any,
//                                                          .font: UIFont.medium(10)],
//                                                         for: .selected)
//                } else {
//                    let imgName = "\(imgList[idx])_2"
//                    obj.image = UIImage(named: imgName)
//                    obj.selectedImage = UIImage(named: "\(imgName)_selected")
//                    obj.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0xC6CBCF) as Any,
//                                                    .font: UIFont.medium(10)],
//                                                         for: .normal)
//                    obj.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x03E0CF) as Any,
//                                                          .font: UIFont.medium(10)],
//                                                         for: .selected)
//                }
//            }
//        }
    }

    func getImageList() -> [String] {
        return ["tabbar_home",
                "tabbar_vpay",
                "tabbar_my"]
    }
}
