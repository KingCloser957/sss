//
//  MDEngnineViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDEngnineViewControllerDelegate:NSObjectProtocol {
    func didSelectEngnine(_ engnine:SearchEngine)
}


class MDEngnineViewController: MDBaseViewController {
    
    var datas:[[SearchEngine]] = []
    
    weak var delegate:MDEngnineViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "搜索设置"
        
        setupData()
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(kBottomH)
        }
    }
    
   func setupData() {
        datas = [MDSearchEngine.searchEngines.keys.sorted().map { SearchEngine(name: $0)},
                 MDSearchEngine.searchApps.keys.sorted().map { SearchEngine(name: $0)}
        ]
        
        if !tableView.groups.isEmpty {
            tableView.groups.removeAll()
        }
        for section in datas {
            let group = Group()
            group.headerViewHight = 42
            let headView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 42))
            let textLabel = UILabel(frame: CGRectMake(29, 15, 60, 16))
            textLabel.font = UIFont.regular(10)
            textLabel.textColor = UIColor.hexColor(hexColor: 0x2C2C2C, alpha: 1.0)
            textLabel.text = section.count > 3 ? "搜素引擎":"APP搜索"
            headView.addSubview(textLabel)
            group.headerView = headView
            for row in section {
                group.datas.append(row)
            }
            if !group.datas.isEmpty {
                tableView.groups.append(group)
            }
        }
        tableView.reloadData()
    }
    lazy var tableView: MDBaseTableView = {
        let tabView = MDBaseTableView(frame: view.bounds, style: .grouped)
        tabView.separatorStyle = .none
        tabView.backgroundColor = view.backgroundColor
        tabView.registerClassCell(any: [MDEngnineViewCell.self])
        tabView.cellForRow = { [weak self](tableView, indexPath) in
            let model = tabView.groups[indexPath.section].datas[indexPath.row] as? SearchEngine
            let cell = tableView.dequeueReusableCell(withIdentifier:"MDEngnineViewCell") as? MDEngnineViewCell
            cell?.refreshUI(with: model)
            return cell
        }
        tabView.cellWillDisplay = { [weak self](tabView, cell, indexPath) in
            self?.tableView(tabView, willDisplay: cell, forRowAt: indexPath)
        }
        tabView.didSelectRow = {(model, _) in
            if self.delegate != nil  {
                MDSearchEngine.searchEngine = SearchEngine(name: (model as! SearchEngine).name)
                self.delegate?.didSelectEngnine(model as! SearchEngine)
                self.navigationController?.popViewController(animated: true)
            }
        }
        tabView.showsVerticalScrollIndicator = false
        view.addSubview(tabView)
        return tabView
    }()
}

extension MDEngnineViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numbers = tableView.numberOfRows(inSection: indexPath.section)
        let bounds = CGRect(x: 0, y: 0, width: cell.width - 28, height: cell.height)
        guard let newCell = cell as? MDEngnineViewCell else {
            return
        }
        let cornerSize = CGSize(width: 15, height: 15)
        if indexPath.row == 0 {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: cornerSize)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            newCell.cornerView.layer.mask = mask
            newCell.lineView.isHidden = false
        } else if indexPath.row == (numbers-1) {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: cornerSize)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            newCell.cornerView.layer.mask = mask
            newCell.lineView.isHidden = true
        } else {
            let path = UIBezierPath(rect: bounds)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            newCell.cornerView.layer.mask = mask
            newCell.lineView.isHidden = false
        }
    }
}
