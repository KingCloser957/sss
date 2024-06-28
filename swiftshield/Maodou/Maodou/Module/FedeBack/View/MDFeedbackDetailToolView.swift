//
//  MDFeedbackDetailToolView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDFeedbackDetailToolView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(14)
            make.height.equalTo(40)
            make.right.equalTo(photoBtn.snp_left).offset(-13)
        }
        photoBtn.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.right.equalToSuperview().offset(-22)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }

    @objc
    func photoAction() {
        guard let vc = viewController() as? MDFeedbackToolDelegate else {
            return
        }
        vc.selectImage()
    }

    lazy var textField: UITextField = {
        let tField = UITextField()
        tField.textColor = UIColor.white
        tField.font = UIFont.light(14)
        tField.backgroundColor = UIColor.hexColor(0x4A5564)
        tField.layer.cornerRadius = 10
        tField.attributedPlaceholder = NSMutableAttributedString(string: "SETTING_CONTACTUS_ONE_HEADER".localizable(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.3)]);
        tField.delegate = self
        tField.returnKeyType = .send
        tField.leftView=UIView.init(frame:CGRect(x: 0, y: 0, width: 15, height: 15))
        tField.leftViewMode = .always
        addSubview(tField)
        return tField
    }()

    lazy var photoBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "photo_icon"), for: .normal)
        btn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()
}

extension MDFeedbackDetailToolView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let vc = viewController() as? MDFeedbackToolDelegate else {
            return true
        }
        let text = textField.text
        if text?.isEmpty ?? true {
            MBProgressHUD.showToast(text: "FEEDBACK_DETAIL_MESSAGE_TIP".localizable())
            return false
        }
        textField.text = nil
        vc.sendTextMessage(text)
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isNineKeyBoard() {
            return true
        } else {
            if string.hasEmoji() || string.containsEmoji() {
                return false
            }
        }
        return true

    }

}
