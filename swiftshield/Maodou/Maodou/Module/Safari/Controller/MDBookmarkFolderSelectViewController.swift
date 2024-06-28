//
//  MDBookmarkFolderSelectViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDBookmarkFolderSelectViewController: MDBookmarkViewController {
    var moveModel: MDBookmarkModel?
    init(preModel: MDBookmarkModel? = nil, moveModel: MDBookmarkModel?) {
        super.init(preModel: preModel)
        self.moveModel = moveModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        super.setupUI()

    }

    override func setupData() {
        if !tableView.groups.isEmpty {
            tableView.groups.removeAll()
        }
        let table = MDBookmarkTable()
        var parentId: String?
        if let model = preModel {
            parentId = model.id
        }
        models = table.select(parentId).filter{ $0.isFolder && $0.id != moveModel?.id}
        if models.count == 1 {
            models[0].cornerStyle = [.allCorners]
        } else {
            for (index, _) in models.enumerated()  {
                if index == 0 {
                    models[index].cornerStyle = [.topLeft, .topRight]
                } else if index == models.count - 1 {
                    models[index].cornerStyle = [.bottomLeft, .bottomRight]
                } else {
                    models[index].cornerStyle = []
                }
            }
        }

        if !models.isEmpty {
            tableView.addGroup { group in
                group.datas = models
            }
        }
        tableView.reloadData()
    }

    override func setupCustomUI() {
        title = "选择文件夹"
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: "nav_back_icon"), for: .normal)
        leftBtn.size = CGSize(width: 55, height: 44)
        leftBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.leftBarButtonItem = leftItem
    }

    override func setupToolView() -> MDBookmarkToolView {
        let tView = MDBookmarkToolView(isMove: true, frame: .zero)
        tView.backgroundColor = .white
        return tView
    }

    override func saveAction() {
        guard var moveModel = self.moveModel else { return }
        moveModel.parentId = preModel?.id
        moveModel.path = "\(preModel?.path ?? "")/\(moveModel.id)"
        let table = MDBookmarkTable()
        table.update(moveModel)
        navigationController?.dismiss(animated: true)
    }

    override func didSelected(_ indexPath: IndexPath) {
        let newModel = models[indexPath.row]
        let vc = Maodou.MDBookmarkFolderSelectViewController(preModel:newModel, moveModel: moveModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
