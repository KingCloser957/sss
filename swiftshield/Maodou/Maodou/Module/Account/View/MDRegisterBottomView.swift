//
//  MDRegisterBottomView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDRegisterBottomViewProtocol: MDBaseAccountBottomViewProtocol {
//    func confirmAction()
    func leftAction()
}

class MDRegisterBottomView: MDBaseAccountBottomView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confirmBtn.setTitle("REGISTER_AND_LOGIN".localizable(), for: .normal)
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
        }
        leftBtn.snp.makeConstraints { make in
            make.left.equalTo(confirmBtn).offset(10)
            make.top.equalTo(confirmBtn.snp_bottom).offset(24)
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    lazy var leftBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.regular(12)
        btn.setTitleColor(UIColor.hexColor(0x979DAD), for: .normal)
        let title = NSAttributedString(string: "REGISTER_PHONE_HAVE_ACCOUNT".localizable(), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        btn.setAttributedTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(leftAction(_:)) , for: .touchUpInside)
        addSubview(btn)
        return btn
    }()
}

extension MDRegisterBottomView {

    override func confirmAction(_ sender: UIButton) {
        guard let vc = viewController() as? MDRegisterViewController else { return }
        vc.confirmAction()
    }

    @objc
    private func leftAction(_ sender: UIButton) {
        guard let vc = viewController() as? MDRegisterViewController else { return }
        vc.leftAction()
    }

}
