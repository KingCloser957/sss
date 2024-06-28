//
//  MDBindInfoViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDBindInfoViewController: MDBaseViewController {
    
    private var type: MDTitleSwitchViewType?

    init(type: MDTitleSwitchViewType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
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
        view.addSubview(tabView)
        return tabView
    }()

}

extension MDBindInfoViewController {

    private func setupUI() {
        title = (type  == .email) ? "SETTING_ACCOUNT_BINDEMAIL_PHONE".localizable() :  "SETTING_ACCOUNT_BINDPHONE_PHONE".localizable()
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavBarH)
        }
    }

    private func setupData() {
        let json = [["title": getTitle(),
                     "info": getAccount(),
                     "type": 0,
                     "needArrowIcon": false],
                    ["title": "NEW_ACCOUNT_EXCHANGE_BIND".localizable(),
                     "type": 1],
                    ]
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

    private func getTitle() -> String {
        if type == .email {
            return "SETTING_ACCOUNT_BINDEMAIL_PHONE".localizable()
        } else {
            return "SETTING_ACCOUNT_BINDPHONE_PHONE".localizable()
        }
    }

    private func getAccount() -> String {
        let user = MDUserInfoManager.share.user()
        if type == .email {
            return user?.getSafeEmail() ?? ""
        } else {
            return user?.getSafePhone() ?? ""
        }
    }

    private func didSelect(_ model: MDMineCellModel) {
        switch model.type {
        case 1:
            toChangeBind()
        default:
            break
        }
    }

    private func toChangeBind() {
        guard let type = type else { return }
        let vc = MDVerificationBindViewController(type: type)
        navigationController?.pushViewController(vc, animated: true)
    }

}
