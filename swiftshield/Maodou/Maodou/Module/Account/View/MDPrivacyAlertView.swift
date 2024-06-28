//
//  MDPrivacyAlertView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDPrivacyAlertViewProtocol {
    func comfireAction(_ view: MDPrivacyAlertView)
}

class MDPrivacyAlertView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }
        infoLab.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        agreeBtn.snp.makeConstraints { make in
            make.top.equalTo(infoLab.snp.bottom).offset(22)
            make.height.equalTo(38)
            make.right.equalToSuperview().offset(-34)
            make.left.equalToSuperview().offset(34)
            make.bottom.equalToSuperview().offset(-27)
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

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.text = "PRIVACY_LOGIN_REFUSE_TIPS".localizable()
        lab.textAlignment = .center
        lab.textColor = UIColor.hexColor(0x1F2329)
        lab.font = UIFont.regular(12)
        contentView.addSubview(lab)
        return lab
    }()

    lazy var agreeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("PRIVACY_LOGIN_IKNOW_TIPS".localizable(), for: .normal)
        btn.titleLabel?.font = UIFont.regular(12)
        btn.backgroundColor = UIColor.hexColor(0x46495A)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.layer.cornerRadius = 19
        btn.addTarget(self, action: #selector(agreeAction(_:)), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()

}

extension MDPrivacyAlertView {

    @objc
    private func agreeAction(_ sender: UIButton) {
        guard let target = viewController() as? MDPrivacyAlertViewProtocol else { return }
        target.comfireAction(self)
    }

}
