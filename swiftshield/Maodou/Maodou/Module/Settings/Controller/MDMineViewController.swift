//
//  MDMineViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDMineViewController: MDBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestUserInfo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupUI() {
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarH)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp_bottom)
            make.bottom.equalToSuperview().offset(-kTabBarH)
        }
        headerView.refreshUI()
    }

    private func setupData() {
        var section: [MDMineCellModel] = []
        for dict in MDMineViewController.json {
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
        requeDeviceData()
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
        tabView.tableHeaderView = adView
        view.addSubview(tabView)
        return tabView
    }()

    lazy var adView: MDMineAdView = {
        let view = MDMineAdView()
        view.width = self.view.width
        view.height = view.width/375.0 * 65 + 30
        return view
    }()

    lazy var headerView: MDMineHeaderView = {
        let header = MDMineHeaderView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(accountAction))
        header.addGestureRecognizer(tap)
        view.addSubview(header)
        return header
    }()
}

extension MDMineViewController {
    static let json = [["title":  "SETTINGS_TABLE_MESSAGE_CENTER".localizable(), "icon": "icon_mess", "type": 0],
//                       ["title": "购买会员", "icon": "icon_pay", "type": 5],
//                       ["title": "购买记录", "icon": "icon_pay", "type": 1],
                       ["title": "SETTINGS_TABLE_MESSAGE_FEEDBACK".localizable(), "icon": "icon_fank", "type": 2],
                       ["title":  "SETTINGS_TABLE_MESSAGE_SET_MANAGER".localizable(), "icon": "icon_sb", "info": "", "type": 3],
                       ["title":  "SETTINGS_TABLE_MESSAGE_SETTINGS".localizable(), "icon": "icon_set", "type": 4]
                    ]

    private func didSelect(_ model: MDMineCellModel) {
        switch model.type {
        case 0:
            let vc = MDMessageViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = MDOrderViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = MDFeedbackListViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = MDDeviceViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = MDSettingsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = MDUpgradeViewController()
            let nav = MDBaseNavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        default:
            break
        }
    }

    private func requestUserInfo() {
        MDNetworkTool.userInfo { [weak self](response, error) in
            Log.debug(response)
            guard let result = response as? [String: Any], let success = result["success"] as? Int, success != 0 else { return }
            guard let data = result["data"] as? [String: Any] else { return }
            MDUserInfoManager.share.save(data)
            self?.headerView.refreshUI()
            let exitMessage = (MDUserInfoManager.share.user()?.existNewMessage ?? 0) > 0
            guard var model = self?.tableView.groups[0].datas[0] as? MDMineCellModel else { return }
            model.needRedDot = exitMessage
            self?.tableView.groups[0].datas[0] = model
            self?.tableView.reloadData()
        }
    }

    @objc
    private func accountAction() {
        let vc = MDMineInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func requeDeviceData() {

        MDNetworkTool.devices { [weak self](response, error) in
            guard let result = response as? [String: Any] else { return }
            guard let dict = result["data"] as? [String: Any] else { return }
            let jsonDecode = JSONDecoder()
            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                return
            }
            guard let deviceInfo = try? jsonDecode.decode(MDDeviceInfoModel.self, from: data) else {
                return
            }
            guard let model = self?.tableView.groups[0].datas[2] as? MDMineCellModel else {
                return
            }
            model.info = "\(deviceInfo.platforms?.count ?? 0)/4\("DEVICE_MANAGEMENT_INFO".localizable())"
            self?.tableView.groups[0].datas[2] = model
            self?.tableView.reloadData()
        }
    }
}
