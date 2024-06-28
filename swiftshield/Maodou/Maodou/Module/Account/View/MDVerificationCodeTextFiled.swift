//
//  MDVerificationCodeTextFiled.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDVerificationCodeTextFiledProtocol {
    func sendVerificationCodeAction(_ sender: MDVerficationCodeButton)
}

class MDVerificationCodeTextFiled: MDAccountTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.keyboardType = .numberPad
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textField.snp.remakeConstraints({ make in
            make.left.equalToSuperview().offset(17)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.right.equalToSuperview().offset(-40)
        })
        
        codeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func codeAction(_ sender: MDVerficationCodeButton) {
        guard let target = viewController() as? MDVerificationCodeTextFiledProtocol else {
            return
        }
        target.sendVerificationCodeAction(sender)
    }

    lazy var codeBtn: MDVerficationCodeButton = {
        let btn = MDVerficationCodeButton(type: .custom)
        btn.setTitle("REGISTER_PHONE_SEND_CODE".localizable(), for: .normal)
        btn.addTarget(self, action: #selector(codeAction(_:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.hexColor(0xC6CBCF), for: .normal)
        btn.titleLabel?.font = UIFont.regular(13)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 0.6
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.layer.masksToBounds = true
        addSubview(btn)
        return btn
    }()
}

class MDVerficationCodeButton: UIButton {

    deinit {
        timer.invalidate()
    }

    private var downCount: Int = 60
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                timer.fireDate = .distantFuture
            } else {
                timer.fireDate = .distantPast
            }
        }
    }

    @objc
    private func timerAction() {
        downCount -= 1
        if downCount == 0 {
            downCount = 60
            timer.fireDate = .distantFuture
            isEnabled = true
            return
        }
        setTitle("\(downCount)s", for: .disabled)
    }

    lazy var timer: Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
}
