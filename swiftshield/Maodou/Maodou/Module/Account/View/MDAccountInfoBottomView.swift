//
//  MDAccountInfoBottomView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDAccountInfoBottomView: UIView {
    
    var confirmClosure: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        confirmBtn.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }

    @objc
    private func confirmAction() {
        guard let block = confirmClosure else {
            return
        }
        block()
    }

    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("SETTING_ACCOUNT_LOGOUT_Quic_TIPS".localizable(), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.light(16)
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.layer.borderWidth = 1.0
        btn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()
}
