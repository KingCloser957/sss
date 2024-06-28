//
//  MDHistoryViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WLEmptyState

class MDHistoryViewController: MDBaseViewController {
    
    var didSelectBlock: ((MDHistoryModel) -> ())?

    var models: [[MDHistoryModel]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    func setupUI() {
        view.backgroundColor = kThemeColor
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        toolView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(kBottomH+49)
        }
    }

   func setupData() {
        let list = MDHistoryTable().selectAll()
        var datas: [[MDHistoryModel]] = []
        var arr: [MDHistoryModel] = []
        var preModel: MDHistoryModel?
        var count = 0
        list.forEach { model in
            count += 1
            if (Int(model.timestamp ?? 0)/86400) == (Int(preModel?.timestamp ?? 0)/86400) {
                arr.append(model)
                if count == list.count {
                    datas.append(arr)
                }
            } else {
                if !arr.isEmpty {
                    datas.append(arr)
                    arr.removeAll()
                }
                arr.append(model)
                if count == list.count {
                    datas.append(arr)
                }
            }
            preModel = model
        }
        models = datas
        tableView.reloadData()
    }

    func showAlertView() {
        let alerView = MDHistoryAlertView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        alerView.addAction(title: "BROWER_SEARCH_MENU_BOOKMARKS_NO_HISTORY".localizable()) { [weak alerView, weak self] in
            let table = MDHistoryTable()
            table.clear()
            self?.setupData()
        }
        alerView.addAction(title: "SETTING_CONTACTUS_CANCEL".localizable()) { [weak alerView] in

        }
        UIApplication.shared.keyWindow?.addSubview(alerView)
        alerView.show()
    }

    lazy var tableView: UITableView = {
        let tView = UITableView(frame: .zero, style: .plain)
        tView.register(MDHistoryTableViewCell.self, forCellReuseIdentifier: "MDHistoryTableViewCell")
        tView.delegate = self
        tView.dataSource = self
        tView.rowHeight = 53
        tView.backgroundColor = UIColor.hexColor(0xF5F5F5)
        tView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            tView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tView.emptyStateDelegate = self
        tView.emptyStateDataSource = self
        view.addSubview(tView)
        return tView
    }()

    lazy var toolView: MDHistoryToolView = {
        let tView = MDHistoryToolView()
        tView.backgroundColor = .white
        tView.clearBlock = { [weak self] in
            self?.showAlertView()
        }
        view.addSubview(tView)
        return tView
    }()
}

extension MDHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDHistoryTableViewCell") as! MDHistoryTableViewCell
        cell.closeOtherSwipe = { [weak tableView] in
            guard let sTabView = tableView else {
                return
            }
            sTabView.visibleCells.forEach { cell in
                if let newCell = cell as? MDHistoryTableViewCell {
                    newCell.closeLeftSwipe()
                }
            }
        }
        cell.deleteBlock = { [weak self] (deleteCell) in
            guard let sSelf = self,
                  let indexPath = sSelf.tableView.indexPath(for: deleteCell) else {
                return
            }
            deleteCell.closeLeftSwipe()
            let table = MDHistoryTable()
            table.delete(sSelf.models[indexPath.section][indexPath.row])
            sSelf.models[indexPath.section].remove(at: indexPath.row)
            sSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        cell.refreshUI(models[indexPath.section][indexPath.row])
        return cell
    }
}

extension MDHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numbers = tableView.numberOfRows(inSection: indexPath.section)
        let bounds = CGRect(x: 0, y: 0, width: cell.width - 36, height: cell.height)
        guard let newCell = cell as? MDHistoryTableViewCell else {
            return
        }
        let cornerSize = CGSize(width: 19, height: 19)
        if numbers == 1 {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.allCorners], cornerRadii: cornerSize)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            newCell.cornerView.layer.mask = mask
        } else {
            if indexPath.row == 0 {
                let path = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: cornerSize)
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                newCell.cornerView.layer.mask = mask
            } else if indexPath.row == (numbers-1) {
                let path = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.bottomLeft, .bottomRight],
                                        cornerRadii: cornerSize)
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                newCell.cornerView.layer.mask = mask
            } else {
                let path = UIBezierPath(rect: bounds)
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                newCell.cornerView.layer.mask = mask
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = models[section].first
        let newTimestamp = Int(model?.timestamp ?? 0)
        if (newTimestamp/86400) == (Int(Date().timeIntervalSince1970)/86400) {
            return "BROWER_SEARCH_MENU_BOOKMARKS_TIME_TODAY".localizable()
        } else if (newTimestamp/86400) == (Int(Date().timeIntervalSince1970 - 86400)/86400) {
            return "BROWER_SEARCH_MENU_BOOKMARKS_TIME_YESTERDAY".localizable()
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM月dd日"
            let date = Date(timeIntervalSince1970: (model?.timestamp ?? 0))
            let dateStr = formatter.string(from: date)
            return dateStr
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.visibleCells.forEach { cell in
            if let newCell = cell as? MDHistoryTableViewCell {
                newCell.closeLeftSwipe()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) { [weak self] in
            guard let sSelf = self else {
                return
            }
            sSelf.navigationController?.popViewController(animated: true)
            if let didSelectBlock = sSelf.didSelectBlock {
                didSelectBlock(sSelf.models[indexPath.section][indexPath.row])
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.visibleCells.forEach { cell in
            if let newCell = cell as? MDHistoryTableViewCell {
                newCell.closeLeftSwipe()
            }
        }
    }
}

extension MDHistoryViewController: WLEmptyStateDelegate {
    func enableScrollForEmptyState() -> Bool {
        return true
    }
}

extension MDHistoryViewController: WLEmptyStateDataSource {

    func customViewForEmptyState() -> UIView? {
        let view = MDTableViewDefaultView()
        view.iconImgView.image = UIImage(named: "history_empty_icon")
        view.tipLab.text = "BROWER_SEARCH_MENU_BOOKMARKS_YOU_HANA_NO_HISTORY".localizable()
        view.bounds = tableView.bounds
        return view
    }
}

