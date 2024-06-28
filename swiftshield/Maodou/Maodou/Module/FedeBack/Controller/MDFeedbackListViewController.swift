//
//  MDFeedbackListViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import WLEmptyState

class MDFeedbackListViewController: MDBaseViewController {
    
    private let pageSize = 10
    private var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    lazy var tableView: MDBaseTableView = {
        let tabView = MDBaseTableView(frame: .zero, style: .plain)
        tabView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 81, right: 0)
        tabView.emptyStateDelegate = self
        tabView.emptyStateDataSource = self
        tabView.backgroundColor = view.backgroundColor
        tabView.registerClassCell(any: [MDFeedbackListCell.self])
        tabView.didSelectRow = { [weak self](model, indexPath) in
            self?.didSelect(model as! MDFeedbackListModel)
        }
        tabView.cellForRow = { [weak self](tableView, indexPath) in
            let cell = tableView.dequeueReusableCell(withIdentifier:"MDFeedbackListCell")
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

    lazy var toolView: MDFeedbackListToolView = {
        let toolView = MDFeedbackListToolView()
        toolView.backgroundColor = UIColor.hexColor(0x2F3544)
        view.addSubview(toolView)
        return toolView
    }()
}

extension MDFeedbackListViewController {

    private func setupUI() {
        title = "意见反馈"
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarH)
            make.bottom.equalToSuperview()
        }
        toolView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(81)
            make.bottom.equalToSuperview()
        }
    }

    private func setupData() {
        requestDatas(page)
    }

    private func requestDatas(_ page: Int) {
        let params = ["page": page,
                      "pageSize": pageSize
                    ]
        MDNetworkTool.feedbackList(params) { [weak self](response, error) in
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
            var datas: [MDFeedbackListModel] = []
            for dict in list {
                let jsonDecode = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                    break
                }
                guard let model = try? jsonDecode.decode(MDFeedbackListModel.self, from: data) else {
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

    private func didSelect(_ model: MDFeedbackListModel) {
        guard let id = model.id else {
            return
        }
        let vc = MDFeedbackDetailViewController("\(id)")
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MDFeedbackListViewController: WLEmptyStateDelegate {
    func enableScrollForEmptyState() -> Bool {
        return true
    }
}

extension MDFeedbackListViewController: WLEmptyStateDataSource {

    func customViewForEmptyState() -> UIView? {
        let view = MDTableViewDefaultView()
        view.iconImgView.image = UIImage(named: "message_none")
//        view.tipLab.text = "您还没有消息"
        view.bounds = tableView.bounds
//        view.moreBtn.setTitle("反馈问题", for: .normal)
//        view.moreBtn.isHidden = false
//        view.moreBtn.addTarget(self, action: #selector(moreAction(_:)), for: .touchUpInside)
        return view
    }
}

extension MDFeedbackListViewController: MDFeedbackListToolViewProtocol {
    func feedbackAction() {
        let vc = MDFeedbackViewController()
        vc.feedbackBlock = { [weak self] in
            self?.tableView.mj_header?.beginRefreshing()
        }
        let nav = MDBaseNavigationController(rootViewController: vc)
        navigationController?.present(nav, animated: true, completion: nil)
    }
}

