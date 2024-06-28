//
//  MDLoginBottomView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDLoginBottomViewProtocol: MDBaseAccountBottomViewProtocol {
    func leftAction()
    func rightAction()
}

class MDLoginBottomView: MDBaseAccountBottomView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        confirmBtn.setTitle("LOGIN_ACCOUNT_TITLE".localizable(), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        confirmBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
        rightBtn.snp.makeConstraints { make in
            make.right.equalTo(confirmBtn).offset(-10)
            make.centerY.equalTo(leftBtn)
        }
    }

    lazy var leftBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.regular(12)
        btn.setTitleColor(UIColor.hexColor(0x979DAD), for: .normal)
        let title = NSAttributedString(string: "REGISTER_ACCOUNT_TITLE_TIP".localizable(), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        btn.setAttributedTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(leftAction(_:)), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()

    lazy var rightBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.regular(12)
        btn.setTitleColor(UIColor.hexColor(0x979DAD), for: .normal)
        let title = NSAttributedString(string: "FORGET_ACCOUN_PASSWORD_TIPS".localizable(), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        btn.setAttributedTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()

}

extension MDLoginBottomView {
    
    override func confirmAction(_ sender: UIButton) {
        guard let vc = viewController() as? MDLoginBottomViewProtocol else { return }
        vc.confirmAction()
    }

    @objc
    private func leftAction(_ sender: UIButton) {
        guard let vc = viewController() as? MDLoginBottomViewProtocol else { return }
        vc.leftAction()
    }

    @objc
    private func rightAction(_ sender: UIButton) {
        guard let vc = viewController() as? MDLoginBottomViewProtocol else { return }
        vc.rightAction()
    }

}

