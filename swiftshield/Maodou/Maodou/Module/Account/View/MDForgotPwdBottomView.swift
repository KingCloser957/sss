//
//  ForgotPwdBottomView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDForgotPwdBottomViewProtocol: MDBaseAccountBottomViewProtocol {
//    func confirmAction()
}

class MDForgotPwdBottomView: MDBaseAccountBottomView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confirmBtn.setTitle("FORGET_PAWWORD_RESET_AND_LOGIN".localizable(), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
        }
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(tipLab.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

}

extension MDForgotPwdBottomView {

   override func confirmAction(_ sender: UIButton) {
        guard let vc = viewController() as? MDForgotPwdBottomViewProtocol else { return }
        vc.confirmAction()
    }

}
