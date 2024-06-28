//
//  MDFeedbackListToolView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDFeedbackListToolViewProtocol {
    func feedbackAction()
}

class MDFeedbackListToolView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moreBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(38)
            make.right.equalToSuperview().offset(-38)
            make.height.equalTo(42)
            make.centerY.equalToSuperview()
        }
    }

    @objc
    private func moreAction(_ sender: UIButton) {
        guard let target = viewController() as? MDFeedbackListToolViewProtocol else { return }
        target.feedbackAction()
    }

    lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("SETTING_CONTACTUS_TITLE".localizable(), for: .normal)
        btn.titleLabel?.font = UIFont.regular(16)
        btn.backgroundColor = UIColor.hexColor(0x46495A)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.layer.cornerRadius = 21
        btn.addTarget(self, action: #selector(moreAction(_:)), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()

}
