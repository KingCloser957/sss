//
//  MDPrivacyLoginViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDPrivacyLoginViewController: MDBaseViewController {
    var enterAppBlock: (() -> Void)?
    var isTouvistorLogin:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        backImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(36)
            make.top.equalToSuperview().offset(kNavBarH)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(logImgView.snp.right).offset(8)
            make.centerY.equalTo(logImgView)
        }
        textLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
        }
        touristBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(36)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(45)
            make.bottom.equalTo(userBtn.snp_top).offset(-12)
        }
        userBtn.snp.makeConstraints { make in
            make.left.right.height.equalTo(touristBtn)
            make.bottom.equalTo(textView.snp_top).offset(-11)
        }
        textView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-43)
            make.bottom.equalToSuperview().offset(-26)
            make.left.equalToSuperview().offset(43)
        }
    }

    lazy var backImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "bg2")
        view.addSubview(imgView)
        return imgView
    }()
    
    lazy var textLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x2B2828)
        lab.text = "LOGIN_PRIVACY_MIDDLE_LOGIN_TIPS".localizable()
        lab.font = UIFont.light(28)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        backImgView.addSubview(lab)
        return lab
    }()

    lazy var logImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "pic_headv")
        backImgView.addSubview(imgView)
        return imgView
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x2B2828)
        lab.text = "Monkey Proxy"
        lab.font = UIFont.regular(14)
        lab.textAlignment = .center
        backImgView.addSubview(lab)
        return lab
    }()

    lazy var touristBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("LOGIN_PRIVACY_TOURISTOR_LOGIN".localizable(), for: .normal)
        btn.backgroundColor = UIColor.hexColor(hexColor: 0x000000, alpha: 0.05)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12.0)
        btn.layer.cornerRadius = 22.5
        btn.addTarget(self, action: #selector(touristAction), for: .touchUpInside)
        view.addSubview(btn)
        return btn
    }()

    lazy var userBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.hexColor(0x2D3343), for: .normal)
        btn.setTitle("LOGIN_PRIVACY_ACCOUNT_LOGIN".localizable(), for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12.0)
        btn.layer.cornerRadius = 22.5
        btn.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        view.addSubview(btn)
        return btn
    }()

    lazy var textView: UITextView = {
        let lab = UITextView()
        lab.textColor = UIColor.hexColor(0xa7a7a7)
        lab.backgroundColor = .clear
        lab.isEditable = false
        lab.isSelectable = false
        lab.isScrollEnabled = false
        lab.textContainer.lineBreakMode = .byCharWrapping
        lab.font = UIFont(name: "PingFangSC-Regular", size: 12.0)
        lab.contentInset = UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0)
        //清除link默认样式
        lab.linkTextAttributes = [:]
        lab.attributed.text = """
                          \("LOGIN_PRIVACY_FIRST_TIPS".localizable(), .foreground(UIColor.hexColor(0x78869B)))\(" \("LOGIN_PRIVACY_USER_TERS".localizable() )", .foreground(UIColor.hexColor(0x331D9A)), .link(termsUrl))\("LOGIN_PRIVACY_USER_AND".localizable() ,.foreground(UIColor.hexColor(0x78869B)))\("LOGIN_PRIVACY_USER_PRIVACY".localizable(), .foreground(UIColor.hexColor(0x331D9A)), .link(privacyUrl))\("，\("LOGIN_PRIVACY_USER_ALLOW_PRIVACY".localizable())", .foreground(UIColor.hexColor(0x78869B)))
                          """
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        lab.addGestureRecognizer(tap)
        view.addSubview(lab)
        return lab
    }()
}

extension MDPrivacyLoginViewController {

    @objc
    private func loginAction() {
        isTouvistorLogin = false
        let agreePrivacy = UserDefaults.standard.bool(forKey: "kAgreePrivacy")
        if agreePrivacy {
            let vc = MDLoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            showTipView()
        }
    }

    @objc
    private func touristAction() {
        isTouvistorLogin = true
        let agreePrivacy = UserDefaults.standard.bool(forKey: "kAgreePrivacy")
        if agreePrivacy {
            let params = ["signType":"1"]
            let hud = MBProgressHUD.showLoading(view)
            MDNetworkTool.login(params) { [weak self] (response, error) in
                hud.hide(animated: true)
                guard let response = response as? [String: Any] else {
                    return
                }
                Log.debug(response)
                guard let data = response["data"] as? [String: Any], let success = response["success"] as? Int, success == 1 else {
                    MBProgressHUD.showToast(text: response["message"] as? String)
                    return
                }
                MDUserInfoManager.share.save(data)
                guard let block = self?.enterAppBlock else {
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                    return
                }
                block()
            }
        } else {
            showTipView()
        }
    }

    @objc
    private func handleTap(_ tap: UITapGestureRecognizer) {
        guard let textView = tap.view as? UITextView else {
            return
        }
        let location = tap.location(in: textView)
        guard let position = textView.closestPosition(to: location) else {
            return
        }
        guard let att = textView.textStyling(at: position, in: .forward) else {
            return
        }
        if (att.keys.contains(.link)) {
            open(att[.link] as? URL)
        }
    }

    private func open(_ link: URL?) {
        guard let link = link else {
            return
        }
        if UIApplication.shared.canOpenURL(link) {
            let privacyVc = MDBaseWkWebViewController()
            privacyVc.urlString = link.absoluteString
            self.navigationController?.pushViewController(privacyVc, animated: true)
        }
    }

//    private func changeSecondLaunchState() {
//        UserDefaults.standard.set(true, forKey: "kSecondLaunch")
//        UserDefaults.standard.synchronize()
//    }

    private func showTipView() {
        let view = MDPrivacyTipView()
        view.backgroundColor = UIColor.hexColor(0x000000).withAlphaComponent(0.6)
        view.frame = self.view.bounds
        self.view.addSubview(view)
    }

    private func showAlerView() {
        let view = MDPrivacyAlertView()
        view.backgroundColor = UIColor.hexColor(0x000000).withAlphaComponent(0.6)
        view.frame = self.view.bounds
        self.view.addSubview(view)
    }
}

extension MDPrivacyLoginViewController: MDPrivacyTipViewProtocol {
    func agreeAction(_ view: MDPrivacyTipView) {
        UserDefaults.standard.setValue(true, forKey: "kAgreePrivacy")
        UserDefaults.standard.synchronize()
        if isTouvistorLogin {
            self.touristAction()
        } else {
            let vc = MDLoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        view.removeFromSuperview()
    }

    func disagreeAction(_ view: MDPrivacyTipView) {
        view.removeFromSuperview()
        showAlerView()
    }
}

extension MDPrivacyLoginViewController: MDPrivacyAlertViewProtocol {
    func comfireAction(_ view: MDPrivacyAlertView) {
        view.removeFromSuperview()
    }
}
