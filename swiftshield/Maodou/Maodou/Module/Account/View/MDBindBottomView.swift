//
//  MDBindBottomView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDBindBottomViewProtocol: MDBaseAccountBottomViewProtocol {
    
}

class MDBindBottomView: MDBaseAccountBottomView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confirmBtn.setTitle("SETTING_ACCOUNT_SETPASSWORD_CONFIRM".localizable(), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        confirmBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.height.equalTo(42)
        }

        tipLab.snp.makeConstraints { make in
            make.top.equalTo(confirmBtn.snp_bottom).offset(18)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

}
