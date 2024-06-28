//
//  MDVerificationBindViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDVerificationBindViewController: MDBaseLoginViewController {
    
    var type: MDTitleSwitchViewType?

    init(type: MDTitleSwitchViewType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(71)
        }
        codeTextFiled.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp_bottom)
            make.left.right.height.equalTo(infoView )
        }

        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(codeTextFiled.snp_bottom)
            make.bottom.equalToSuperview().offset(-34)
        }
        title = (type == .email) ? "CHANGE_BIND_EMAIL_TIPS".localizable() :  "CHANGE_BIND_PHONE_TIPS".localizable()
    }

    lazy var infoView: MDVerficationInfoView = {
        let info = MDVerficationInfoView()
        info.titleLab.text = (type == .email) ? "SETTING_ACCOUNT_BINDEMAIL_PHONE".localizable(): "SETTING_ACCOUNT_BINDPHONE_PHONE".localizable()
        let user = MDUserInfoManager.share.user()
        info.infoLab.text = (type == .email) ? user?.getSafeEmail() : user?.getSafePhone()
        contentView.addSubview(info)
        return info
    }()

    lazy var codeTextFiled: MDVerificationCodeTextFiled = {
        let textView = MDVerificationCodeTextFiled()
        textView.textField.placeholder = "REGISTER_ENYER_VERITYCODE_TIPS".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var bottomView: MDBindBottomView = {
        let view = MDBindBottomView()
        view.confirmBtn.isEnabled = false
        view.tipLab.text = getTipText()
        contentView.addSubview(view)
        return view
    }()

    private func getTipText() -> String {
        if type == .email {
            return "VerityCODE_BIND_EMAIL".localizable()
        } else {
            return "VerityCODE_BIND_PHONE".localizable()
        }
    }

}

extension MDVerificationBindViewController {
    override func checkConfirmButtonIsEnabled() {
        if (codeTextFiled.text?.isEmpty ?? true) {
            bottomView.confirmBtn.isEnabled = false
        } else {
            bottomView.confirmBtn.isEnabled = true
        }
    }

    private func sendValidateCode() {
        var params = ["register_type": 2,
                      "register_valid_code": codeTextFiled.text!
        ] as [String : Any]
        let user = MDUserInfoManager.share.user()
        if type == .email {
            params["boundAccount"] = user?.user?.emailAdress ?? ""
        } else {
            params["boundAccount"] = user?.user?.phone ?? ""
            params["region_code"] = user?.user?.regionCode ?? ""
        }
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.validateCode(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }

            guard let success = result["success"] as? Int else {
                return
            }
            if success == 1 {
                let vc = MDChangeBindViewController(type: self?.type ?? .email)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension MDVerificationBindViewController: MDBindBottomViewProtocol {
    func confirmAction() {
        view.endEditing(true)
        sendValidateCode()
    }
}

extension MDVerificationBindViewController: MDVerificationCodeTextFiledProtocol {
    func sendVerificationCodeAction(_ sender: MDVerficationCodeButton) {
        Log.info("发送验证码")
        switch type {
        case .email:
            sendEmailCode()
        default:
            sendPhoneCode()
        }
    }

    private func sendPhoneCode() {
        let user = MDUserInfoManager.share.user()
        if user?.user?.phone?.isEmpty ?? true  {
            Log.error("手机号不能为空")
            MBProgressHUD.showToast(text: "PLEASE_ENTER_ACCOUNT_NUMBER".localizable())
            return
        }
        let params = ["register_type": 2,
                      "region_code": "+\(user?.user?.regionCode ?? "")",
                      "phone": user?.user?.phone ?? "",
                     ] as [String : Any]
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.phoneValidateCode(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }
            guard let success = result["success"] as? Int else {
                return
            }
            if success == 1 {
                self?.codeTextFiled.codeBtn.isEnabled = false
            }
        }
    }

    private func sendEmailCode() {
        let user = MDUserInfoManager.share.user()
        if user?.user?.emailAdress?.isEmpty ?? true  {
            Log.error("邮箱地址不能为空")
            MBProgressHUD.showToast(text:"PLEASE_ENTER_EMAIL_ACCOUNT".localizable())
            return
        }

        if !(user?.user?.emailAdress?.validateEmail() ?? false) {
            Log.error("邮箱格式不正确")
            MBProgressHUD.showToast(text:"ENTER_PHONE_ACCOUNT_ERROR".localizable())
            return
        }

        let params = ["register_type": 2,
                      "emailAdress": user?.user?.emailAdress ?? "",
                     ] as [String : Any]
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.emailValidateCode(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }
            guard let success = result["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(text: result["message"] as? String)
                return
            }
            self?.codeTextFiled.codeBtn.isEnabled = false
        }
    }
}
