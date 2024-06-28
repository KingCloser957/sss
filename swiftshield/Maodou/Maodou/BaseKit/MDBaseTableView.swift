//
//  MDBaseTableView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class Group {
    var datas: [Any] = []
    var cellHight: CGFloat = UITableView.automaticDimension
    var headerView: UITableViewHeaderFooterView?
    var footerView: UITableViewHeaderFooterView?
    var headerViewHight: CGFloat = 0
    var footerViewHight: CGFloat = 0
}

class MDBaseTableView: UITableView {

    var cellForRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell?)?
    var didSelectRow: ((_ model: Any, _ indexPath: IndexPath) -> Void)?
    var didDeselectRow: ((_ model: Any, _ indexPath: IndexPath) -> Void)?
    var scrollViewWillBeginDragging: (() -> Void)?
    var cellWillDisplay: ((_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?
    var groups: [Group] = []
    public typealias AddGroupBlock = (_ group:Group) -> Void

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }

    private func initView() {
        dataSource = self
        delegate = self
        tableHeaderView = UIView()
        tableFooterView = UIView()
        separatorColor = UIColor.hexColor(0x2D3343)
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        } else {
            
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MRK: 注册cell
    public func registerClassCell(any: [AnyClass]) {
        for cell in any {
            register(cell.self, forCellReuseIdentifier: String(describing: cell.self))
        }
    }

    //
    public func addGroup(_ block:AddGroupBlock) {
        let group = Group()
        groups.append(group)
        block(group)
    }

}

extension MDBaseTableView: UITableViewDataSource {


    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groups.isEmpty {
            return 0
        }
        return groups[section].datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellForRow = cellForRow, let cell = cellForRow(tableView, indexPath) else {
            let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "kDefaultCell")
            return defaultCell
        }
        let model = groups[indexPath.section].datas[indexPath.row]
        if let target = cell as? UITableViewCellProtocol {
            target.refreshData(model)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let block = cellWillDisplay else { return }
        block(tableView, cell, indexPath)
    }
}

extension MDBaseTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        guard let block = didSelectRow else { return }
        block(groups[indexPath.section].datas[indexPath.row], indexPath)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        guard let block = didDeselectRow else { return }
        block(groups[indexPath.section].datas[indexPath.row], indexPath)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let block = scrollViewWillBeginDragging else { return }
        block()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return groups[indexPath.section].cellHight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return groups[section].headerViewHight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return groups[section].headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return groups[section].footerViewHight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return groups[section].footerView
    }

//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if tableView.isEditing {
//            return .insert
//        } else {
//            return .none
//        }
//    }
}
