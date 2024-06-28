//
//  MDBindViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDBindViewController: MDBaseLoginViewController {
    
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
        if type == .email {
            emailTextFiled.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(26)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(71)
            }
            codeTextFiled.snp.makeConstraints { make in
                make.top.equalTo(emailTextFiled.snp_bottom)
                make.left.right.height.equalTo(emailTextFiled)
            }
        } else {
            phoneTextFiled.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(26)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(71)
            }
            codeTextFiled.snp.makeConstraints { make in
                make.top.equalTo(phoneTextFiled.snp_bottom)
                make.left.right.height.equalTo(phoneTextFiled)
            }
        }


        if hadBind() {
            bottomView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(codeTextFiled.snp_bottom)
                make.bottom.equalToSuperview().offset(-34)
            }
        } else {
            newPwdTextFiled.snp.makeConstraints { make in
                make.top.equalTo(codeTextFiled.snp_bottom)
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
        }

        title = (type == .email) ? "SETTING_BINGACCOUNT_EMAIL_TITLE".localizable() :  "SETTING_BINGACCOUNT_PHONE_TITLE".localizable()
    }

    lazy var emailTextFiled: MDEmailTextField = {
        let textView = MDEmailTextField()
        textView.textField.placeholder = "SETTING_BINGACCOUNT_EMAIL_Email_ENTER".localizable()
        textView.textField.becomeFirstResponder()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var phoneTextFiled: MDPhoneTextField = {
        let textView = MDPhoneTextField()
        textView.textField.placeholder = "SETTING_BINGACCOUNT_PHONE_Email_ENTER".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var codeTextFiled: MDVerificationCodeTextFiled = {
        let textView = MDVerificationCodeTextFiled()
        textView.textField.placeholder = "REGISTER_ENYER_VERITYCODE_TIPS".localizable()
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
        textView.textField.placeholder = "REGISTER_EMAIL_FOOT_SURE_TITLE".localizable()
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

    lazy var successView: MDBindSuccessView = {
        let view = MDBindSuccessView()
        view.tipLab.text = "REGISTER_BAIND_ACCOUNT_SAFTTY".localizable()
        view.layer.cornerRadius = 34
        view.layer.borderColor = UIColor.hexColor(0x2D3343).cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = kThemeColor
        contentView.addSubview(view)
        return view
    }()

    func getTipText() -> String {
        if type == .email {
            return "REGISTER_EMAIL_BAIND_SAFATY_TITLE".localizable()
        } else {
            return "REGISTER_PHONE_BAIND_SAFATY_TITLE".localizable()
        }
    }

    func bindSuccess() {
        refreshUserInfo()
        successView.snp.makeConstraints { make in
            make.right.left.equalTo(codeTextFiled)
            make.bottom.equalTo(codeTextFiled.snp.bottom)
            make.top.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let vc = self.navigationController?.viewControllers[1] else {
                return
            }
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }

    private func refreshUserInfo() {
        let user = MDUserInfoManager.share.user()
        if  type == .email {
            user?.user?.emailAdress = emailTextFiled.text!
        } else {
            user?.user?.phone = phoneTextFiled.text!
            user?.user?.regionCode = "+\(phoneTextFiled.regionCode)"
        }

//        let jsonEncoder = JSONEncoder()
//        guard let jsonData = try? jsonEncoder.encode(user) else {
//            return
//        }
//        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] else {
//            return
//        }
        guard let json = MDCoderTool.toDict(user) else {
            return
        }
        Log.debug(json)
        MDUserInfoManager.share.save(json)
    }
}

extension MDBindViewController {

    override func checkConfirmButtonIsEnabled() {
        if type == .email {
            if hadBind() {
                if (emailTextFiled.text?.isEmpty ?? true) || (codeTextFiled.text?.isEmpty ?? true) {
                    bottomView.confirmBtn.isEnabled = false
                } else {
                    bottomView.confirmBtn.isEnabled = true
                }
            } else {
                if (emailTextFiled.text?.isEmpty ?? true) || (codeTextFiled.text?.isEmpty ?? true) || (newPwdTextFiled.text?.isEmpty ?? true) || (confirmTextFiled.text?.isEmpty ?? true) {
                    bottomView.confirmBtn.isEnabled = false
                } else {
                    bottomView.confirmBtn.isEnabled = true
                }
            }
        } else {
            if hadBind() {
                if (phoneTextFiled.text?.isEmpty ?? true) || (codeTextFiled.text?.isEmpty ?? true) {
                    bottomView.confirmBtn.isEnabled = false
                } else {
                    bottomView.confirmBtn.isEnabled = true
                }
            } else {
                if (phoneTextFiled.text?.isEmpty ?? true) || (codeTextFiled.text?.isEmpty ?? true) || (newPwdTextFiled.text?.isEmpty ?? true) || (confirmTextFiled.text?.isEmpty ?? true) {
                    bottomView.confirmBtn.isEnabled = false
                } else {
                    bottomView.confirmBtn.isEnabled = true
                }
            }
        }
    }

    private func hadBind() -> Bool {
        let user = MDUserInfoManager.share.user()
        return !(user?.user?.emailAdress?.isEmpty ?? true) || !(user?.user?.phone?.isEmpty ?? true)
    }

}

extension MDBindViewController: MDBindBottomViewProtocol {
    func confirmAction() {
        view.endEditing(true)
        boundAccount()
    }
}

extension MDBindViewController: MDVerificationCodeTextFiledProtocol {

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

        if phoneTextFiled.text?.isEmpty ?? true  {
            Log.error("手机号不能为空")
            MBProgressHUD.showToast(text: "PLEASE_ENTER_PHONE_ACCOUNT".localizable())
            return
        }
        let params = ["register_type": 7,
                      "region_code": "+\(phoneTextFiled.regionCode)",
                      "phone": phoneTextFiled.text!,
                     ] as [String : Any]
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.phoneValidateCode(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }
            guard let success = result["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(self?.view, text: result["message"] as? String)
                return
            }
            self?.codeTextFiled.codeBtn.isEnabled = false
        }
    }

    private func sendEmailCode() {
        if emailTextFiled.text?.isEmpty ?? true  {
            Log.error("邮箱地址不能为空")
            MBProgressHUD.showToast(text: "PLEASE_ENTER_EMAIL_ACCOUNT".localizable())
            return
        }
        if !(emailTextFiled.text?.validateEmail() ?? false) {
            Log.error("邮箱格式不正确")
            MBProgressHUD.showToast(text: "ENTER_PHONE_ACCOUNT_ERROR".localizable())
            return
        }
        let params = ["register_type": 7,
                      "emailAdress": emailTextFiled.text!,
                     ] as [String : Any]
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.emailValidateCode(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }
            guard let success = result["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(self?.view, text: result["message"] as? String)
                return
            }
            self?.codeTextFiled.codeBtn.isEnabled = false
        }
    }

    private func boundAccount() {
        var params = [
                      "register_valid_code": codeTextFiled.text!
                     ] as [String: Any]
        if type == .email {
            params["boundAccount"] = emailTextFiled.text!
        } else {
            params["boundAccount"] = phoneTextFiled.text!
            params["region_code"] = "+\(phoneTextFiled.regionCode)"
        }

        if !hadBind() {
            if newPwdTextFiled.text != confirmTextFiled.text {
                MBProgressHUD.showToast(text: "TWICE_AGAIN_NOT_SAME".localizable())
                return
            } else {
                if !newPwdTextFiled.text!.validatePasswordRuler() {
                    MBProgressHUD.showToast(text: "PLEASE_ENTER_CURRENT_PASSWORD".localizable())
                    return
                }
                params["new_password"] = newPwdTextFiled.text!
            }
        }
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.boundAccount(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }
            guard let success = result["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(self?.view, text: result["message"] as? String)
                return
            }
            self?.bindSuccess()
        }
    }

}
