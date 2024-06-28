//
//  MDRegisterViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDRegisterViewController: MDBaseLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "REGISTER_TITLE".localizable()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func setupUI() {
        super.setupUI()
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
//            make.bottom.equalToSuperview().offset(-34)
        }

        privacyTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(42)
            make.right.equalToSuperview().offset(-42)
            make.top.greaterThanOrEqualTo(bottomView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-63)
        }
        switchView.setupDatas(["REGISTER_EMAIL_HEAD_TITLE".localizable(), "REGISTER_PHONE_HEAD_TITLE".localizable()])
    }

    lazy var emailTextFiled: MDEmailTextField = {
        let textView = MDEmailTextField()
        textView.textField.placeholder = "PLEASE_ENTER_EMAIL_ACCOUNT".localizable()
        textView.textField.becomeFirstResponder()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var phoneTextFiled: MDPhoneTextField = {
        let textView = MDPhoneTextField()
        textView.textField.placeholder = "PLEASE_ENTER_PHONE_ACCOUNT".localizable()
        textView.isHidden = true
        contentView.addSubview(textView)
        return textView
    }()

    lazy var emailCodeTextFiled: MDVerificationCodeTextFiled = {
        let textView = MDVerificationCodeTextFiled()
        textView.textField.placeholder = "PLEASE_ENTER_CURRENT_PWD".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var phoneCodeTextFiled: MDVerificationCodeTextFiled = {
        let textView = MDVerificationCodeTextFiled()
        textView.textField.placeholder = "PLEASEURE_ENTER_SIX_CODE".localizable()
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

    lazy var bottomView: MDRegisterBottomView = {
        let view = MDRegisterBottomView()
        view.confirmBtn.isEnabled = false
        view.tipLab.text = "REGISTER_EMAIL_FOOT_FINISH_BY_EAMIL".localizable()
        contentView.addSubview(view)
        return view
    }()

    lazy var privacyTextView: MDPrivacyTextView = {
        let view = MDPrivacyTextView()
        contentView.addSubview(view)
        return view
    }()
}

extension MDRegisterViewController {

    private func emailRegisterAction() {
        let params = ["register_valid_code": emailCodeTextFiled.text!,
                      "emailAddress": emailTextFiled.text!,
                      "password": newPwdTextField.text!
                     ] as [String : Any]
        resiterRequest(params)
    }

    private func phoneRegisterAction() {
        let params = ["register_valid_code": phoneCodeTextFiled.text!,
                      "region_code": "+\(phoneTextFiled.regionCode)",
                      "phone": phoneTextFiled.text!,
                      "password": newPwdTextField.text!,
                     ] as [String : Any]
        resiterRequest(params)
    }

    private func resiterRequest(_ params: [String: Any]) {
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.register(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let response = response as? [String: Any] else {
                return
            }
            guard let data = response["data"] as? [String: Any], let success = response["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(text: response["message"] as? String)
                return
            }
            MDUserInfoManager.share.save(data)
            self?.registerSuccess()
        }
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

    private func registerSuccess() {
        guard let window = UIApplication.shared.currentWindow else {
            return
        }
        if window.rootViewController?.isKind(of: MDBaseTabBarController.self) ?? false {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            let tabbar = MDBaseTabBarController()
            window.rootViewController = tabbar
        }
    }
}

extension MDRegisterViewController: MDVerificationCodeTextFiledProtocol {
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

        if phoneTextFiled.text?.isEmpty ?? true  {
            MBProgressHUD.showToast(text: "PLEASE_ENTER_PHONE_ACCOUNT".localizable())
            return
        }
        let params = ["register_type": 0,
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
                MBProgressHUD.showToast(text: result["message"] as? String)
                return
            }
            self?.phoneCodeTextFiled.codeBtn.isEnabled = false
        }
    }

    private func sendEmailCode() {
        if emailTextFiled.text?.isEmpty ?? true  {
            MBProgressHUD.showToast(text: "PLEASE_ENTER_EMAIL_ACCOUNT".localizable())
            return
        }

        if !(emailTextFiled.text?.validateEmail() ?? false) {
            MBProgressHUD.showToast(text: "ENTER_PHONE_ACCOUNT_ERROR".localizable())
            return
        }

        let params = ["register_type": 0,
                      "emailAdress": emailTextFiled.text!,
                     ] as [String : Any]
        let hud = MBProgressHUD.showLoading()
        MDNetworkTool.emailValidateCode(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }
            guard let success = result["success"] as? Int else {
                MBProgressHUD.showToast(text: result["message"] as? String)
                return
            }
            if success == 1 {
                self?.emailCodeTextFiled.codeBtn.isEnabled = false
            }
        }
    }
}

extension MDRegisterViewController: MDTitleSwitchViewProtocol {
    func didSelectAction(_ type: MDTitleSwitchViewType) {
        phoneTextFiled.isHidden = type == .email
        phoneCodeTextFiled.isHidden = phoneTextFiled.isHidden
        emailTextFiled.isHidden = (type == .phone)
        emailCodeTextFiled.isHidden = emailTextFiled.isHidden
        bottomView.tipLab.text = type == .email ? "REGISTER_EMAIL_FOOT_FINISH_BY_EAMIL".localizable() : "REGISTER_PHONE_FOOT_FINISH_BY_PHONE".localizable()
        checkConfirmButtonIsEnabled()
    }
}

extension MDRegisterViewController: MDRegisterBottomViewProtocol {

    func confirmAction() {
        Log.debug("注册")
        switch switchView.type {
        case .email:
            emailRegisterAction()
        default:
            phoneRegisterAction()
        }
    }

    func leftAction() {
        Log.debug("had account")
        navigationController?.popViewController(animated: true)
    }
}
