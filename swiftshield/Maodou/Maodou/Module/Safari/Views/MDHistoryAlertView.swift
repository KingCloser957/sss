//
//  MDHistoryAlertView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDHistoryAlertItem: UIButton {
    var handle: (() -> Void)?
}

class MDHistoryAlertView: MDBasePopupView {
    var buttonList: [MDHistoryAlertItem] = []
    func addAction(title: String, handle: @escaping () -> Void ) {
        let btn = MDHistoryAlertItem(type: .custom)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.setTitleColor(UIColor.hexColor(0x0055FF), for: UIControl.State.normal)
        btn.setTitle(title, for: .normal)
        btn.handle = handle
        btn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        buttonList.append(btn)
    }

    @objc
    func buttonAction(_ sender: MDHistoryAlertItem) {
        dismiss()
        if let handle = sender.handle {
            handle()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }

    override func show() {
        var pre: MDHistoryAlertItem?
        buttonList.forEach { item in
            self.addSubview(item)
            if pre == nil {
                item.snp.makeConstraints { make in
                    make.top.equalTo(self.snp.bottom)
                    make.centerX.equalToSuperview()
                    make.width.lessThanOrEqualTo(375)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                    make.height.equalTo(45)
                }

            } else {
                item.snp.makeConstraints { make in
                    make.top.equalTo(pre!.snp.bottom).offset(10)
                    make.centerX.equalToSuperview()
                    make.width.lessThanOrEqualTo(375)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                    make.height.equalTo(45)
                }
            }
            pre = item
        }
        guard let btn = buttonList.first else {
            return
        }

        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            btn.snp.updateConstraints { make in
                make.top.equalTo(self.snp.bottom).offset(-(CGFloat(self.buttonList.count * 55) + kBottomH))
            }
        }
    }

    override func dismiss() {
        guard let btn = buttonList.first else {
            return
        }
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            btn.snp.updateConstraints { make in
                make.top.equalTo(self.snp.bottom)
            }
        } completion: { finished in
            self.removeFromSuperview()
        }
    }

}
