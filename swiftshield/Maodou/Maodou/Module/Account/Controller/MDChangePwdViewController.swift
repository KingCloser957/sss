//
//  MDChangePwdViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDChangePwdViewController: MDBaseLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func setupUI() {
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarH)
        }
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
            make.width.equalTo(kScreenW)
        }
        prePwdTextFiled.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(26)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(71)
        }
        newPwdTextFiled.snp.makeConstraints { make in
            make.top.equalTo(prePwdTextFiled.snp_bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(71)
        }
        confirmTextFiled.snp.makeConstraints { make in
            make.top.equalTo(newPwdTextFiled.snp_bottom)
            make.left.right.height.equalTo(newPwdTextFiled)
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(confirmTextFiled.snp_bottom)
            make.bottom.equalToSuperview().offset(-34)
        }

        title = "SETTING_ACCOUNT_CHANGE_PWD_TITLE".localizable()
    }

    lazy var prePwdTextFiled: MDPasswordTextField = {
        let textView = MDPasswordTextField()
        textView.textField.placeholder = "PLEASE_ENTER_OLD_PWD".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var newPwdTextFiled: MDPasswordTextField = {
        let textView = MDPasswordTextField()
        textView.textField.placeholder = "REGISTER_EMAIL_FOOT_TWO_TITLE".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var confirmTextFiled: MDPasswordTextField = {
        let textView = MDPasswordTextField()
        textView.textField.placeholder = "PLEASE_ENTER_NEW_PWD".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var bottomView: MDBindBottomView = {
        let view = MDBindBottomView()
        view.confirmBtn.isEnabled = false
        contentView.addSubview(view)
        return view
    }()

    lazy var successView: MDBindSuccessView = {
        let view = MDBindSuccessView()
        view.tipLab.text = "CHANGE_PWD_SUCCESS".localizable()
        view.layer.cornerRadius = 34
        view.layer.borderColor = UIColor.hexColor(0x2D3343).cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = kThemeColor
        contentView.addSubview(view)
        return view
    }()

}

extension MDChangePwdViewController {

    override func checkConfirmButtonIsEnabled() {
        if (prePwdTextFiled.text?.isEmpty ?? true) || (newPwdTextFiled.text?.isEmpty ?? true) || (confirmTextFiled.text?.isEmpty ?? true) {
            bottomView.confirmBtn.isEnabled = false
        } else {
            bottomView.confirmBtn.isEnabled = true
        }
    }

    private func changePassword() {
        let params = ["account": MDUserInfoManager.share.user()?.user?.username ?? "",
                      "old_password": prePwdTextFiled.text!,
                      "new_password": newPwdTextFiled.text!,
                      "new_password_again": confirmTextFiled.text!
        ]
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.changePassword(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let response = response as? [String: Any] else {
                return
            }
            guard let success = response["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(text: response["message"] as? String)
                return
            }
            self?.changePasswordSuccess()
        }

    }

    func changePasswordSuccess() {
        successView.snp.makeConstraints { make in
            make.right.left.equalTo(confirmTextFiled)
            make.bottom.equalTo(confirmTextFiled).offset(10)
            make.top.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let vc = self.navigationController?.viewControllers[1] else {
                return
            }
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
}

extension MDChangePwdViewController: MDChangePwdBottomViewPtotocol {
    func confirmAction() {
        changePassword()
    }
}


