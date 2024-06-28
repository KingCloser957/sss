//
//  MDLoginViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDLoginViewController: MDBaseLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "LOGIN_ACCOUNT_TITLE".localizable()
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
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextFiled.snp_bottom)
            make.left.right.height.equalTo(emailTextFiled)
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(passwordTextField.snp_bottom).offset(25)
//            make.bottom.equalToSuperview().offset(-34)
        }
        privacyTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(42)
            make.right.equalToSuperview().offset(-42)
            make.top.greaterThanOrEqualTo(bottomView.snp.bottom).offset(20 )
            make.bottom.equalToSuperview().offset(-63)
        }

        let leftItem = UIBarButtonItem.init(customView: backBtn)
        navigationItem.leftBarButtonItem = leftItem

        switchView.setupDatas(["LOGIN_EMAIL_SWITCH_TITLE".localizable(), "LOGIN_PHONE_HEAD_TITLE".localizable()])
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

    lazy var passwordTextField: MDPasswordTextField = {
        let textView = MDPasswordTextField()
        textView.textField.placeholder = "LOGIN_PHONE_PWD_PLACE".localizable()
        contentView.addSubview(textView)
        return textView
    }()

    lazy var backBtn: UIButton = {
        let backBtn = UIButton.init(type: .custom)
        var imgName = "back"
        backBtn.setImage(UIImage(named: imgName), for: .normal)
        backBtn.size = CGSize.init(width: 44.0, height: 44.0)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return backBtn
    }()

    lazy var bottomView: MDLoginBottomView = {
        let view = MDLoginBottomView()
        view.confirmBtn.isEnabled = false
        contentView.addSubview(view)
        return view
    }()

    lazy var privacyTextView: MDPrivacyTextView = {
        let view = MDPrivacyTextView()
        contentView.addSubview(view)
        return view
    }()
}

extension MDLoginViewController {

    @objc
    private func backAction() {
        navigationController?.popViewController(animated: true)
    }

    func emailLoginAction() {
        let validateEmail = emailTextFiled.text!.validateEmail()
        let validatePassword = isValidatePassword(passwordTextField.text)
        if !validateEmail {
            Log.debug("邮箱格式不对")
            MBProgressHUD.showToast(text: "ENTER_PHONE_ACCOUNT_ERROR".localizable())
            return
        }
        if !validatePassword {
            Log.debug("密码格式不对")
            MBProgressHUD.showToast(text: "PLEASE_ENTER_CURRENT_PASSWORD".localizable())
            return
        }

        let params = ["signType": "4",
                      "emailAddress": emailTextFiled.text!,
                      "password": passwordTextField.text!
                    ]
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.login(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let response = response as? [String: Any] else {
                return
            }
            guard let data = response["data"] as? [String: Any], let success = response["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(text: response["message"] as? String)
                return
            }
            MDUserInfoManager.share.save(data)
            self?.loginSuccess()
        }
    }

    func phoneLoginAction() {
        if !isValidatePassword(passwordTextField.text) {
            Log.debug("密码格式不对")
            MBProgressHUD.showToast(text: "PLEASE_ENTER_CURRENT_PASSWORD".localizable())
            return
        }
        let params = ["signType":"3",
                      "phone": phoneTextFiled.text!,
                      "region_code": "+\(phoneTextFiled.regionCode)",
                      "password": passwordTextField.text!
                     ]
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.login(params) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let response = response as? [String: Any] else {
                return
            }
            guard let data = response["data"] as? [String: Any], let success = response["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(text: response["message"] as? String)
                return
            }
            MDUserInfoManager.share.save(data)
            self?.loginSuccess()
        }
    }

    private func loginSuccess() {
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

    private func isValidatePassword(_ text: String?) -> Bool {
        guard let text = text else { return  false}
        let validatePassword = text.validatePasswordRuler()
        return validatePassword
    }

    override func checkConfirmButtonIsEnabled() {
        if switchView.type == .email {
            let enable = (emailTextFiled.text?.isEmpty ?? true) || (passwordTextField.text?.isEmpty  ?? true)
            bottomView.confirmBtn.isEnabled = !enable
        } else {
            let enable = (phoneTextFiled.text?.isEmpty ?? true) || (passwordTextField.text?.isEmpty ?? true)
            bottomView.confirmBtn.isEnabled = !enable
        }
    }
}

extension MDLoginViewController: MDTitleSwitchViewProtocol {
    func didSelectAction(_ type: MDTitleSwitchViewType) {
        phoneTextFiled.isHidden = type == .email
        emailTextFiled.isHidden = type == .phone
        if type == .phone {
            phoneTextFiled.textField.becomeFirstResponder()
        } else {
            emailTextFiled.textField.becomeFirstResponder()
        }
        checkConfirmButtonIsEnabled()
    }
}

extension MDLoginViewController: MDLoginBottomViewProtocol {

    func confirmAction() {
        Log.debug("login")
        view.endEditing(true)
        switch switchView.type {
        case .email:
            emailLoginAction()
        default:
            phoneLoginAction()
        }
    }

    func leftAction() {
        Log.debug("register")
        let vc = MDRegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func rightAction() {
        Log.debug("forget password")
        let vc = MDForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
