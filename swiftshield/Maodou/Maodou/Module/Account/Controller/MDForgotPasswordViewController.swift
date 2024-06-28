//
//  MDForgetPasswordViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDForgotPasswordViewController: MDBaseLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func setupUI() {
        super.setupUI()
        switchView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(kNavBarH+20)
        }
        emailTextFiled.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(71)
        }
        phoneTextFiled.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(emailTextFiled)
        }
        emailCodeTextFiled.snp.makeConstraints { make in
            make.top.equalTo(emailTextFiled.snp_bottom)
            make.left.right.height.equalTo(emailTextFiled)
        }
        phoneCodeTextFiled.snp.makeConstraints { make in
            make.top.equalTo(emailTextFiled.snp_bottom)
            make.left.right.height.equalTo(emailTextFiled)
        }
        newPwdTextField.snp.makeConstraints { make in
            make.top.equalTo(emailCodeTextFiled.snp_bottom)
            make.left.right.height.equalTo(emailTextFiled)
        }
        confirmPwdTextField.snp.makeConstraints { make in
            make.top.equalTo(newPwdTextField.snp_bottom)
            make.left.right.height.equalTo(emailTextFiled)
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(confirmPwdTextField.snp.bottom)
            make.bottom.equalToSuperview().offset(-34)
        }

        title = "FORGET_ACCOUN_PASSWORD_TIPS".localizable()
        switchView.setupDatas(["LOGIN_EMAIL_SWITCH_TITLE".localizable(),
                               "LOGIN_PHONE_HEAD_TITLE".localizable()])
    }

    lazy var emailTextFiled: MDEmailTextField = {
        let textView = MDEmailTextField()
        textView.textField.placeholder = "LOGIN_EMAIL_HEAD_NEW".localizable()
        textView.textField.becomeFirstResponder()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var phoneTextFiled: MDPhoneTextField = {
        let textView = MDPhoneTextField()
        textView.textField.placeholder = "LOGIN_PHONE_HEAD_NEW".localizable()
        textView.isHidden = true
        contentView.addSubview(textView)
        return textView
    }()

    lazy var emailCodeTextFiled: MDVerificationCodeTextFiled = {
        let textView = MDVerificationCodeTextFiled()
        textView.textField.placeholder = "REGISTER_ENYER_VERITYCODE_TIPS".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var phoneCodeTextFiled: MDVerificationCodeTextFiled = {
        let textView = MDVerificationCodeTextFiled()
        textView.textField.placeholder = "REGISTER_ENYER_VERITYCODE_TIPS".localizable()
        textView.isHidden = true
        contentView.addSubview(textView)
        return textView
    }()

    lazy var newPwdTextField: MDPasswordTextField = {
        let textView = MDPasswordTextField()
        textView.textField.placeholder = "REGISTER_EMAIL_FOOT_TWO_TITLE".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var confirmPwdTextField: MDPasswordTextField = {
        let textView = MDPasswordTextField()
        textView.textField.placeholder = "REGISTER_EMAIL_FOOT_SURE_TITLE".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var bottomView: MDForgotPwdBottomView = {
        let view = MDForgotPwdBottomView()
        view.confirmBtn.isEnabled = false
        view.tipLab.text = "FORGET_PAWWORD_BY_EMAIL_WITH_VERITY".localizable()
        contentView.addSubview(view)
        return view
    }()

}

extension MDForgotPasswordViewController {

    private func emailModifierPasswordAction() {
        let params = ["register_valid_code": emailCodeTextFiled.text!,
                      "account": emailTextFiled.text!,
                      "new_password": newPwdTextField.text!,
                      "new_password_again": confirmPwdTextField.text!,
                      "register_type": 1
                     ] as [String : Any]
        getBackPasswordRequest(params)
    }

    private func phoneModifierPasswordAction() {
        let params = ["register_valid_code": phoneCodeTextFiled.text!,
                      "region_code": "+\(phoneTextFiled.regionCode)",
                      "account": phoneTextFiled.text!,
                      "new_password": newPwdTextField.text!,
                      "new_password_again": confirmPwdTextField.text!,
                      "register_type": 1
                     ] as [String : Any]

        getBackPasswordRequest(params)
    }

    private func getBackPasswordRequest(_ params: [String: Any]) {
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.getBackPassword(params) { [weak self](response, error) in
            Log.debug(response)
            guard let response = response as? [String: Any] else {
                hud.hide(animated: true)
                return
            }
            guard let success = response["success"] as? Int, success == 1 else {
                hud.hide(animated: true)
                MBProgressHUD.showToast(text: response["message"] as? String)
                return
            }
            if self?.switchView.type == .email {
                self?.emailLogin()
            } else {
                self?.phoneLogin()
            }
        }
    }

    private func emailLogin() {
        let params = ["signType": "4",
                      "emailAddress": emailTextFiled.text!,
                      "password": newPwdTextField.text!
                     ]
        loginAction(params: params)
    }

    private func phoneLogin() {
        let params = ["signType":"3",
                      "phone": phoneTextFiled.text!,
                      "region_code": "+\(phoneTextFiled.regionCode)",
                      "password": newPwdTextField.text!
                     ]
        loginAction(params: params)
    }

    private func loginAction(params: [String: Any]) {
        MDNetworkTool.login(params) { [weak self](response, error) in
            guard let response = response as? [String: Any] ,let data = response["data"] as? [String: Any],
            let success = response["success"] as? Int else {
                MBProgressHUD.hide(self?.view, animated: true)
                return
            }
            if success != 1 {
                MBProgressHUD.hide(self?.view, animated: true)
                MBProgressHUD.showToast(text: response["message"] as? String)
                return
            }
            MBProgressHUD.hide(self?.view, animated: true)
            MDUserInfoManager.share.save(data)
            self?.loginSuccess()
        }
    }

    private func loginSuccess() {
        MBProgressHUD.hide(for: view, animated: true)
        guard let window = UIApplication.shared.currentWindow as? UIWindow else {
            return
        }
        if window.rootViewController?.isKind(of: MDBaseTabBarController.self) ?? false {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            let tabbar = MDBaseTabBarController()
            window.rootViewController = tabbar
        }
    }

    private func getBackPasswordSuccess() {
        navigationController?.popViewController(animated: true)
    }

    override func checkConfirmButtonIsEnabled() {
        super.checkConfirmButtonIsEnabled()
        if switchView.type == .email {
            let enable = (emailTextFiled.text?.isEmpty ?? true) || (emailCodeTextFiled.text?.isEmpty  ?? true) || (newPwdTextField.text?.isEmpty  ?? true) || (confirmPwdTextField.text?.isEmpty  ?? true)
            bottomView.confirmBtn.isEnabled = !enable
        } else {
            let enable = (phoneTextFiled.text?.isEmpty ?? true) || (phoneCodeTextFiled.text?.isEmpty  ?? true) || (newPwdTextField.text?.isEmpty  ?? true) || (confirmPwdTextField.text?.isEmpty  ?? true)
            bottomView.confirmBtn.isEnabled = !enable
        }
    }
}

extension MDForgotPasswordViewController: MDVerificationCodeTextFiledProtocol {
    func sendVerificationCodeAction(_ sender: MDVerficationCodeButton) {
        Log.info("发送验证码")
        switch switchView.type {
        case .email:
            sendEmailCode()
        default:
            sendPhoneCode()
        }
    }

    private func sendPhoneCode() {

        if phoneTextFiled.textField.text?.isEmpty ?? true  {
            Log.error("手机号不能为空")

            return
        }
        let params = ["register_type": 1,
                      "region_code": "+\(phoneTextFiled.regionCode)",
                      "phone": phoneTextFiled.text!,
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
                self?.phoneCodeTextFiled.codeBtn.isEnabled = false
            }
        }
    }

    private func sendEmailCode() {
        if emailTextFiled.text?.isEmpty ?? true  {
            Log.error("邮箱地址不能为空")
            return
        }

        if !(emailTextFiled.text?.validateEmail() ?? false) {
            Log.error("邮箱格式不正确")
            return
        }

        let params = ["register_type": 1,
                      "emailAdress": emailTextFiled.text!,
                     ] as [String : Any]
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.emailValidateCode(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }

            guard let success = result["success"] as? Int else {
                return
            }
            if success == 1 {
                self?.emailCodeTextFiled.codeBtn.isEnabled = false
            }
        }
    }
}

extension MDForgotPasswordViewController: MDTitleSwitchViewProtocol {

    func didSelectAction(_ type: MDTitleSwitchViewType) {
        phoneTextFiled.isHidden = type == .email
        phoneCodeTextFiled.isHidden = phoneTextFiled.isHidden
        emailTextFiled.isHidden = (type == .phone)
        emailCodeTextFiled.isHidden = emailTextFiled.isHidden
        bottomView.tipLab.text = type == .email ? "电子邮箱通过验证后将完成注册并登录" : "手机号通过验证后将完成注册并登录"
        checkConfirmButtonIsEnabled()
    }
}

extension MDForgotPasswordViewController: MDForgotPwdBottomViewProtocol {
    func confirmAction() {
        switch switchView.type {
        case .email:
            emailModifierPasswordAction()
        default:
            phoneModifierPasswordAction()
        }
    }
}
