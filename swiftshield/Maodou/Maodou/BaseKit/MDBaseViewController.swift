//
//  MDBaseViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDBaseViewController: UIViewController {

    open var hideNavBar: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kThemeColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hideNavBar, animated: true)
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    deinit {
        Log.debug(String(describing: object_getClass(self)))
    }
}
