//
//  MDMineInfoViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD

class MDMineInfoViewController: MDBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    lazy var tableView: MDBaseTableView = {
        let tabView = MDBaseTableView(frame: .zero, style: .plain)
        tabView.backgroundColor = view.backgroundColor
        tabView.registerClassCell(any: [MDMineCell.self])
        tabView.didSelectRow = { [weak self](model, indexPath) in
            self?.didSelect(model as! MDMineCellModel)
        }
        tabView.cellForRow = { [weak self](tableView, indexPath) in
            let cell = tableView.dequeueReusableCell(withIdentifier:"MDMineCell")
            return cell
        }
        tabView.tableFooterView = bottomView
        view.addSubview(tabView)
        return tabView
    }()

    lazy var bottomView: MDAccountInfoBottomView = {
        let btView = MDAccountInfoBottomView()
        btView.confirmClosure = { [weak self] in
            self?.showLogoutTipView()
        }
        btView.height = 180
        btView.width = view.width
        return btView
    }()

}

extension MDMineInfoViewController {
    
    func getUserName() -> String {
        let user = MDUserInfoManager.share.user()
        return user?.user?.username ?? ""
    }

    func getEmail() -> String {
        let user = MDUserInfoManager.share.user()
        return user?.getSafeEmail() ?? "未绑定"
    }

    func getPhone() -> String {
        let user = MDUserInfoManager.share.user()
        return user?.getSafePhone() ?? "未绑定"
    }

    private func setupUI() {
        title = "SETTING_ACCOUNT_TITLE".localizable()
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavBarH)
        }
    }

    private func setupData() {
        if !tableView.groups.isEmpty {
            tableView.groups.removeAll()
        }
        var json = [["title": "SETTING_ACCOUNT_TITLE".localizable(),
                     "icon": "icon_ant",
                     "info": getUserName(),
                     "type": 0,
                     "needArrowIcon": false],
                    ["title": "SETTING_ACCOUNT_PHONE".localizable(),
                     "icon": "icon_phonenonber",
                     "info": getPhone(),
                     "type": 1],
                    ["title": "SETTING_ACCOUNT_EMAIL".localizable(),
                     "icon": "icon_emial",
                     "info": getEmail(),
                     "type": 2],
                    ["title": "SETTING_CANCLE_ACCOUNT".localizable(),
                     "icon": "logout",
                     "info": "",
                     "type": 4],
                ]
        let user = MDUserInfoManager.share.user()
        let hadBind = user?.user?.emailAdress?.count != 0 || user?.user?.phone?.count != 0
        if  hadBind {
            let pWord = ["title": "SETTING_BINGACCOUNT_EMAIL_PWD".localizable(),
                         "icon": "icon_ps",
                         "info": "SETTING_ACCOUNT_CHANGE_PWD".localizable(),
                         "type": 3] as [String : Any]
            json.append(pWord)
        }
        var section: [MDMineCellModel] = []
        for dict in json {
            let jsonDecode = JSONDecoder()
            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                break
            }
            guard let model = try? jsonDecode.decode(MDMineCellModel.self, from: data) else {
                break
            }
            section.append(model)
        }
        tableView.addGroup { group in
            group.datas = section
        }
        tableView.reloadData()
    }

    private func showLogoutTipView() {
        let alert = MDAlertView()
        alert.contentView.backgroundColor = UIColor.hexColor(0x2D3343)
        alert.titleLab.text = "SETTING_ACCOUNT_LOGOUT_TIPS".localizable()
        alert.confirmBtn.setTitle("SETTING_ACCOUNT_LOGOUT_SURE_TIPS".localizable(), for: .normal)
        alert.cancelBtn.setTitle("SETTING_ACCOUNT_LOGOUT_CANCLE_TIPS".localizable(), for: .normal)
        alert.frame = view.bounds
        alert.confirmBlock = { [weak self] in               
            self?.clearCache()
            self?.resetDefautSetting()
            self?.toPrivacyLogin()
        }
        alert.cancelBlock = {
        
        }
        alert.show()
    }

    private func toPrivacyLogin() {
        guard let sceneDelegate = UIApplication.shared.sceneDelegate else { return }
        sceneDelegate.logout()
    }

    private func resetDefautSetting() {
        UserDefaults.standard.set(false, forKey: "kSecondLaunch")
        let userDefault = UserDefaults.standard
        for item in userDefault.dictionaryRepresentation() {
            userDefault.removeObject(forKey: item.key)
        }
        userDefault.synchronize()
    }

    private func clearCache() {
        MDUserInfoManager.share.clear()
    }

    private func didSelect(_ model: MDMineCellModel) {

        switch model.type {
        case 1:
            model.info == "SETTING_BINGACCOUNT_NOCK_MORE_FUNCTION".localizable() ? toBind(.phone) : toBindInfo(.phone)
        case 2:
            model.info == "SETTING_BINGACCOUNT_NOCK_MORE_FUNCTION".localizable() ? toBind(.email) : toBindInfo(.email)
        case 3:
            toChangePassword()
        case 4:
            toLogout()
        default:
            break
        }
    }

    private func toBind(_ type: MDTitleSwitchViewType) {
        let vc = MDBindViewController(type: type)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func toBindInfo(_ type: MDTitleSwitchViewType) {
        let vc = MDBindInfoViewController(type: type)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func toChangePassword() {
        let vc = MDChangePwdViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func toLogout() {
        let alert = MDAlertView()
        alert.contentView.backgroundColor = UIColor.hexColor(0x2D3343)
        alert.titleLab.text = "SETTING_CANCLE_ACCOUNT_TITLE".localizable()
        alert.tipLab.attributed.text = """
                          \("\("SETTING_CANCLE_ACCOUNT_ONE_TRIPS".localizable())", .foreground(UIColor.white))\(" \(MDUserInfoManager.share.user()?.user?.username ?? "aa8ea442cb") ", .foreground(UIColor.hexColor(0xd4237a)), .font(UIFont.regular(14)))\("\("SETTING_CANCLE_ACCOUNT_TWO_TRIPS".localizable())", .foreground(UIColor.white))
                          """
        alert.confirmBtn.setTitle("SETTING_ACCOUNT_LOGOUT_SURE_TIPS".localizable(), for: .normal)
        alert.cancelBtn.setTitle("SETTING_ACCOUNT_LOGOUT_CANCLE_TIPS".localizable(), for: .normal)
        alert.frame = view.bounds
        alert.confirmBlock = { [weak self] in
            self?.secureAction()
        }
        alert.cancelBlock = {
        
        }
        alert.show()
    }
}

extension MDMineInfoViewController {
    @objc private func secureAction() {
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.logout { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else {
                return
            }
            guard let success = result["success"] as? Int, success == 1 else {
                MBProgressHUD.showToast(self?.view, text: result["message"] as? String)
                return
            }
            MBProgressHUD.showToast(text: "LOGOUT_SUCCESS".localizable())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                MDUserInfoManager.share.clear()
                self?.resetDefautSetting()
//                HHUserKeyChainCacheHelper.clearUUid()
//                HHUserKeyChainCacheHelper.clearUserList()
                guard let window = UIApplication.shared.sceneDelegate?.window else { return }
                let vc = MDPrivacyLoginViewController()
                vc.enterAppBlock = { [weak self] in
                    let tabBarController = MDBaseTabBarController()
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()
                    return
                }
                let nav = MDBaseNavigationController(rootViewController: vc)
                window.rootViewController = nav
                window.makeKeyAndVisible()
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kExChangeLoginSuccessNotification), object: nil)
            }
        }
    }
}
