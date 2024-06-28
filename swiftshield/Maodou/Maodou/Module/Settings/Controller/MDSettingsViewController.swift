//
//  MDSettingsViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/11.
//

import UIKit

class MDSettingsViewController: MDBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    lazy var tableView: MDBaseTableView = {
        let tabView = MDBaseTableView(frame: .zero, style: .plain)
        tabView.backgroundColor = view.backgroundColor
        tabView.registerClassCell(any: [MDSetNormalTableViewCell.self, MDSetSwitchTableViewCell.self])
        tabView.didSelectRow = { [weak self](model, indexPath) in
            self?.didSelect(model as! MDSetModel)
        }
        tabView.cellForRow = { [weak self](tableView, indexPath) in
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier:"MDSetNormalTableViewCell")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:"MDSetSwitchTableViewCell")
                return cell
            }
        }
        view.addSubview(tabView)
        return tabView
    }()

}

extension MDSettingsViewController {
    
    private func setupUI() {
        title = "SETTINGS_TABLE_MESSAGE_SETTINGS".localizable()
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarH)
        }
    }

    private func setupData() {
        var pushEnable = false
        checkPushNotification { enable in
            print(enable)
            pushEnable = enable
        }
        let json = [["title":  "SETTINGS_NOTIFICATIONS".localizable(),
//                     "info": "已开启",
                     "type": 0,
                     "state": pushEnable,
                     "needSwitch": true
                    ],
//                    ["title": "Kill Switch",
////                     "info": UserDefaults.standard.bool(forKey: "kKillSwitchState") ? "已开启" : "已关闭",
//                     "type": 1,
//                     "state": UserDefaults.standard.bool(forKey: "kKillSwitchState"),
//                     "needSwitch": true
//                    ],
                    ["title": "SETTINGS_ABOUT_US".localizable(),
                     "needArrow": true,
                     "type": 2
                    ]
                    ]
        var datas: [MDSetModel] = []
        for dict in json {
            let jsonDecode = JSONDecoder()
            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                break
            }
            guard let model = try? jsonDecode.decode(MDSetModel.self, from: data) else {
                break
            }
            datas.append(model)
        }

        tableView.addGroup { group in
            group.datas = datas
        }
        tableView.reloadData()
    }

    private func checkPushNotification(checkNotificationStatus isEnable : ((Bool)->())? = nil){

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
                switch setttings.authorizationStatus{
                case .authorized:
                    isEnable?(true)
                default:
                    isEnable?(false)
                }
            }
        } else {

            let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
            if isNotificationEnabled == true{
                isEnable?(true)
            }else{
                isEnable?(false)
            }
        }
    }

    private func didSelect(_ model: MDSetModel) {
        if model.type == 2 {
            let vc = MDAboutViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MDSettingsViewController: MDSetSwitchTableViewCellProtocol {

    func switchAction(_ sender: UIButton, model: MDSetModel?) {
        if model?.type == 0 {
            if model?.state ?? false {
                if #available(iOS 10.0, *) {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    guard let url = URL(string: "prefs:root=NOTIFICATIONS_ID&path=\(String(describing: MDAppinfoHelper().getIdentifier))") else { return
                    }
                    UIApplication.shared.openURL(url)
                }
            }
        } else {
            sender.isSelected = !sender.isSelected
            model?.state = sender.isSelected
            UserDefaults.standard.setValue(sender.isSelected, forKey: "kKillSwitchState")
            UserDefaults.standard.synchronize()
        }
    }
}
