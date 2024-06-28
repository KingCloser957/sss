//
//  MDDeviceViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDDeviceViewController: MDBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requesData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupUI() {
        title = "DEVICE_MANAGEMENT_TITLE".localizable()
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarH)
            make.left.right.equalToSuperview()
        }

        moreBtn.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.top.equalTo(tableView.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-28)
            make.left.equalToSuperview().offset(28)
            make.width.lessThanOrEqualTo(320)
            make.bottom.equalToSuperview().offset(-kTabBarH)
        }
    }

    private func requesData() {
        MDNetworkTool.devices { [weak self](response, error) in
            guard let result = response as? [String: Any] else { return }
            guard let dict = result["data"] as? [String: Any] else { return }
            let jsonDecode = JSONDecoder()
            guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                return
            }
            guard let model = try? jsonDecode.decode(MDDeviceInfoModel.self, from: data) else {
                return
            }
            self?.tableView.addGroup({ group in
                group.datas = model.list ?? []
            })
            self?.headerView.refreshUI(model.platforms)
            self?.tableView.reloadData()
        }
    }

    @objc
    private func moreAction(_ sender:UIButton) {
        let user = MDUserInfoManager.share.user()
        guard let website = user?.user?.website else { return }
        guard let url = URL(string: website) else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }

        }
    }

    lazy var tableView: MDBaseTableView = {
        let tabView = MDBaseTableView(frame: .zero, style: .plain)
        tabView.backgroundColor = kThemeColor
        tabView.registerClassCell(any: [MDDeviceTableViewCell.self])
        tabView.cellForRow = { (tabView, indexPath) in
            let cell = tabView.dequeueReusableCell(withIdentifier: "MDDeviceTableViewCell")
            return cell
        }
        tabView.tableHeaderView = headerView
        view.addSubview(tabView)
        return tabView
    }()

    lazy var headerView: MDDeviceHeaderView = {
        let headerView = MDDeviceHeaderView()
        let width = (view.width - 30 - 12) / 4.0
        headerView.size = CGSize(width: view.width, height: width + 57.0)
        return headerView
    }()

    lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isHidden = false
        btn.setTitle("获取更多客户端", for: .normal)
        btn.layer.cornerRadius = 21
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(moreAction(_:)), for: .touchUpInside)
        view.addSubview(btn)
        return btn
    }()

}
