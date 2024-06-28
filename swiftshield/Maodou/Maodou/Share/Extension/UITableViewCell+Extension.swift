//
//  MKTableViewCell.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//

import UIKit

protocol UITableViewCellProtocol {
    func refreshData<T>(_ model:T)
}

//extension UITableViewCell: UITableViewCellProtocol {
//    func refreshData<T>(_ model: T) {
//
//    }
//}

extension UITableView {
    
    static func newTableViewGroupedWithTarget(target:Any) ->UITableView {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.delegate = target as? UITableViewDelegate;
        tableView.dataSource = target as? UITableViewDataSource
        tableView.separatorStyle = .none;
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            
        }
        return tableView
    }
    
    func removeCellLine() {
        self.separatorStyle = .none
    }
}
