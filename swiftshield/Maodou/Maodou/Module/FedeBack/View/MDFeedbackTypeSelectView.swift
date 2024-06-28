//
//  MDFeedbackTypeSelectView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDFeedbackTypeSelectView: UIView {
    
    private var selectBtn: MDFeedbackTypeButton?
    var type: Int = 10
    func setupDatas() {
        let arr = ["SETTING_CONTACTUS_FEEDBACK_TYPE_SPEED".localizable(),
                   "SETTING_CONTACTUS_FEEDBACK_TYPE_LESS_GAMES".localizable(),
                   "SETTING_CONTACTUS_FEEDBACK_TYPE_CRASH".localizable(),
                   "SETTING_CONTACTUS_FEEDBACK_TYPE_OTHER".localizable()]
        var preBtn: MDFeedbackTypeButton?
        var preX = 27.0
        for (i, string) in arr.enumerated() {
            let btn = MDFeedbackTypeButton(type: .custom)
            btn.tag = 10 + i
            btn.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
            btn.setTitle(string, for: .normal)
            btn.sizeToFit()
            var width = btn.width + 30
            if width > kScreenW - 54 {
                width = kScreenW - 54
            }
            addSubview(btn)
            if preBtn == nil {
                btn.isSelected = true
                selectBtn = btn
                btn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(preX)
                    make.top.equalToSuperview().offset(0)
                    make.width.equalTo(width)
                    make.height.equalTo(38)
                }
                preX = preX + width
            } else {
                if preX + 9 + width > (kScreenW - 54) {
                    btn.snp.makeConstraints { make in
                        make.left.equalToSuperview().offset(27)
                        make.top.equalTo(preBtn!.snp.bottom).offset(8)
                        make.width.equalTo(width)
                        make.height.equalTo(38)
                    }
                    preX = 27
                } else {
                    btn.snp.makeConstraints { make in
                        make.left.equalTo(preBtn!.snp.right).offset(9)
                        make.top.equalTo(preBtn!.snp.top)
                        make.width.equalTo(width)
                        make.height.equalTo(38)
                    }
                    preX = preX + width
                }
            }
            preBtn = btn
        }
        preBtn!.snp.makeConstraints({ make in
            make.bottom.equalToSuperview()
        })
    }
}

extension MDFeedbackTypeSelectView {
    @objc
    private func selectAction(_ sender: MDFeedbackTypeButton) {
        if selectBtn == sender {
            return
        }
        if sender.isSelected {
            return
        }
        type = sender.tag
        selectBtn?.isSelected = false
        sender.isSelected = !sender.isSelected
        selectBtn = sender
    }
}

class MDFeedbackTypeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let selectImg = UIImage.image(color: UIColor.hexColor(0x46495A))
        setBackgroundImage(selectImg, for: .selected)
        let normalImg = UIImage.image(color: UIColor.clear)
        setBackgroundImage(normalImg, for: .normal)
        titleLabel?.font = UIFont.regular(14)
        layer.cornerRadius = 19
        layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
