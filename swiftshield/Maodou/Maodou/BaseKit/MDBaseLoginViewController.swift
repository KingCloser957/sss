//
//  MDBaseLoginViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//


import UIKit
import SnapKit

class MDBaseLoginViewController: MDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }

    func setupUI() {
        switchView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarH)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(switchView.snp_bottom).offset(14)
        }
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
            make.width.equalTo(kScreenW)
            make.height.greaterThanOrEqualTo(scrollView.snp.height)
        }
    }

    func addObserver() {
        let name = UITextField.textDidChangeNotification.rawValue
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChange(_:)),
                                               name: Notification.Name.init(name),
                                               object: nil)
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    lazy var switchView: MDTitleSwitchView = {
        let view = MDTitleSwitchView()
        self.view.addSubview(view)
        return view
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        return scrollView
    }()

    lazy var contentView: UIView = {
        let contentView = UIView()
        scrollView.addSubview(contentView)
        return contentView
    }()

}

extension MDBaseLoginViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc
    func textFieldDidChange(_ notification: Notification) {
        checkConfirmButtonIsEnabled()
    }

    @objc
    func checkConfirmButtonIsEnabled() {

    }

}

extension MDBaseLoginViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

}

