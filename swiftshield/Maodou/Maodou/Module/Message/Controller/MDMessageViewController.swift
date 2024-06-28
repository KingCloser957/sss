//
//  MDMessageViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import WLEmptyState

class MDMessageViewController: MDBaseViewController {
    
    private let pageSize = 10
    private var page = 1

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
        tabView.emptyStateDelegate = self
        tabView.emptyStateDataSource = self
        tabView.backgroundColor = view.backgroundColor
        tabView.registerClassCell(any: [MDMessageCell.self])
        tabView.didSelectRow = { [weak self](model, indexPath) in
            self?.didSelect(model as! MDMessageModel)
        }
        tabView.cellForRow = { [weak self](tableView, indexPath) in
            let cell = tableView.dequeueReusableCell(withIdentifier:"MDMessageCell")
            return cell
        }
        tabView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            self?.page += 1
            self?.requestDatas(self?.page ?? 1)
        })
        tabView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.page = 1
            self?.requestDatas(self?.page ?? 1)
        })
        tabView.mj_footer?.isHidden = true
        view.addSubview(tabView)
        return tabView
    }()

}

extension MDMessageViewController {

    private func setupUI() {
        title = "SETTING_MESSAGE_MY_TITLE".localizable()
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarH)
        }
    }

    private func setupData() {
        requestDatas(page)
    }

    private func requestDatas(_ page: Int) {
        let params = ["page": page,
                      "pageSize": pageSize
                    ]
        MDNetworkTool.messageList(params) { [weak self](response, error) in
            guard let result = response as? [String: Any] else {
                return
            }
            guard let data = result["data"] as? [String: Any] else {
                return
            }
            guard let list = data["page_datas"] as? [[String: Any]] else {
                return
            }
            if self?.page == 1 {
                if !(self?.tableView.groups.isEmpty ?? true) {
                    self?.tableView.groups.removeAll()
                }
                self?.tableView.mj_header?.endRefreshing()
            }
            var datas: [MDMessageModel] = []
            for dict in list {
                let jsonDecode = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                    break
                }
                guard let model = try? jsonDecode.decode(MDMessageModel.self, from: data) else {
                    break
                }
                datas.append(model)
            }
            if datas.count % 10 > 0 {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self?.tableView.mj_footer?.endRefreshing()
            }
            if self?.tableView.groups.count == 0 {
                self?.tableView.addGroup({ group in
                    group.datas = datas
                })
            } else {
                self?.tableView.groups.first?.datas += datas
            }
            if self?.tableView.groups.first?.datas.isEmpty ?? true {
                self?.tableView.mj_footer?.isHidden = true
            } else {
                self?.tableView.mj_footer?.isHidden = false
            }
            self?.tableView.reloadData()
        }
    }

    private func didSelect(_ model: MDMessageModel) {

        if model.isRead == 0 {
            readMessageAction(model.id)
            model.isRead = 1
            tableView.reloadData()
        }
        let vc = MDMessageDetailViewController(model)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func readMessageAction(_ id: Int?) {
        guard let newId = id else { return }
        let params = ["messageId": "\(newId)"]
        MDNetworkTool.readMessage(params) { response, error in

        }
    }
}

extension MDMessageViewController: WLEmptyStateDelegate {
    func enableScrollForEmptyState() -> Bool {
        return true
    }
}

extension MDMessageViewController: WLEmptyStateDataSource {

    func customViewForEmptyState() -> UIView? {
        let view = MDTableViewDefaultView()
        view.iconImgView.image = UIImage(named: "message_none")
        view.tipLab.text = "SETTING_MESSAGE_HAVA_NO_MESSAGE".localizable()
        view.bounds = tableView.bounds
        return view
    }
}
