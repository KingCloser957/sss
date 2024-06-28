//
//  MDPasswordTextField.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDPasswordTextField: MDAccountTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        textField.keyboardType = .namePhonePad
        textField.isSecureTextEntry = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func secureAction(_ sender: UIButton) {
        textField.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textField.snp.remakeConstraints({ make in
            make.left.equalToSuperview().offset(17)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
        })
        secureBtn.snp.makeConstraints { make in
            make.left.equalTo(textField.snp.right).offset(5)
            make.top.bottom.equalTo(textField)
            make.width.equalTo(30)
            make.right.equalToSuperview().offset(-17)
        }
    }

    lazy var secureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "xs_on"), for: .selected)
        btn.setImage(UIImage(named: "xs_off"), for: .normal)
        btn.addTarget(self, action: #selector(secureAction(_:)), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()
}
