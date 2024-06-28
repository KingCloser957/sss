//
//  MDAboutViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDAboutViewController: MDBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupUI() {
        title = "SETTINGS_ABOUT_US".localizable()
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(194)
            make.centerX.equalToSuperview()
        }
        infoLab.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        privacyBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.width.lessThanOrEqualTo(320)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().offset(-135)
        }
        agreementBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.width.lessThanOrEqualTo(320)
            make.height.equalTo(42)
            make.bottom.equalTo(privacyBtn.snp.top).offset(-16)
        }
    }

    private func getBundleVersion() -> String {
        let info = Bundle.main.infoDictionary
        let majorVersion = info?["CFBundleShortVersionString"] as? String
        let minorVersion = info?["CFBundleVersion"] as? String
        return "\(majorVersion ?? "")( build \(minorVersion ?? "")) "
    }

    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0xFFFFFF)
        lab.text = "Monkey Proxy"
        lab.font = UIFont.regular(16)
        view.addSubview(lab)
        return lab
    }()

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x7A7D89)
        lab.font = UIFont.regular(12)
        let version = getBundleVersion()
        lab.text = version
        view.addSubview(lab)
        return lab
    }()

    lazy var agreementBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("LOGIN_PRIVACY_USER_TERS".localizable(), for: .normal)
        btn.layer.cornerRadius = 21
        btn.titleLabel?.font = UIFont.regular(14)
        btn.backgroundColor = .clear
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitleColor(UIColor.hexColor(0xFFFFFF), for: .normal)
        btn.addTarget(self, action: #selector(agreementAction), for: .touchUpInside)
        view.addSubview(btn)
        return btn
    }()

    lazy var privacyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("LOGIN_PRIVACY_USER_PRIVACY".localizable(), for: .normal)
        btn.titleLabel?.font = UIFont.regular(14)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 21
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitleColor(UIColor.hexColor(0xFFFFFF), for: .normal)
        btn.addTarget(self, action: #selector(privacyAction), for: .touchUpInside)
        view.addSubview(btn)
        return btn
    }()

}

extension MDAboutViewController {
    @objc private func agreementAction() {
        let privacyVc = MDBaseWkWebViewController()
        privacyVc.urlString = termsUrl
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
    
    @objc private func privacyAction() {
        let privacyVc = MDBaseWkWebViewController()
        privacyVc.urlString = privacyUrl
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
}
