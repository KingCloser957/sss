//
//  MDPrivacyTipView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDPrivacyTipViewProtocol {
    func agreeAction(_ view: MDPrivacyTipView)
    func disagreeAction(_ view: MDPrivacyTipView)
}

class MDPrivacyTipView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 320, height: 540))
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        agreeBtn.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(27)
            make.height.equalTo(38)
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(disAgreeBtn)
        }
        disAgreeBtn.snp.makeConstraints { make in
            make.top.equalTo(agreeBtn)
            make.height.equalTo(38)
            make.right.equalToSuperview().offset(-12)
            make.left.equalTo(agreeBtn.snp.right).offset(20)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0xF7F8FA)
        view.layer.cornerRadius = 38
        addSubview(view)
        return view
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "PRIVACY_LOGIN_TITLE".localizable()
        lab.textColor = UIColor.hexColor(0x1F2329)
        lab.font = UIFont.regular(16)
        contentView.addSubview(lab)
        return lab
    }()
    
    lazy var webView: MDWebView = {
        let view = MDWebView()
        guard let url = Bundle.main.url(forResource: "terms", withExtension: "html") else {
            return view
        }
        let request = URLRequest(url: url)
        view.load(request)
        view.backgroundColor = .clear
        contentView.addSubview(view)
        return view
    }()
    
    lazy var agreeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("LOGIN_PRIVACY_BUTTON_AGREE".localizable(), for: .normal)
        btn.titleLabel?.font = UIFont.regular(12)
        btn.backgroundColor = UIColor.hexColor(0x46495A)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.layer.cornerRadius = 19
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(agreeAction(_:)), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()
    
    lazy var disAgreeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("LOGIN_PRIVACY_BUTTON_DISAGREE".localizable(), for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 19
        btn.clipsToBounds = true
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.titleLabel?.font = UIFont.regular(12)
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(UIColor.hexColor(0x1F2329), for: .normal)
        btn.addTarget(self, action: #selector(disagreeAction(_:)), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()
    
}

extension MDPrivacyTipView {
    
    @objc
    private func agreeAction(_ sender: UIButton) {
        guard let target = viewController() as? MDPrivacyTipViewProtocol else { return }
        target.agreeAction(self)
    }
    
    @objc
    private func disagreeAction(_ sender: UIButton) {
        guard let target = viewController() as? MDPrivacyTipViewProtocol else { return }
        target.disagreeAction(self)
    }
}
