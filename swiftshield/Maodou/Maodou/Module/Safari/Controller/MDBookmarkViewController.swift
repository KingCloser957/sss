//
//  MDBookmarkViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WLEmptyState
import MBProgressHUD

class MDBookmarkViewController: MDBaseViewController {
    
    var preModel: MDBookmarkModel?
    var models: [MDBookmarkModel] = []
    var selectedModels: [MDBookmarkModel] = []
    var textField: UITextField?
//    var isMove: Bool = false
    init(preModel: MDBookmarkModel? = nil) {
        self.preModel = preModel
//        self.isMove = isMove
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = preModel?.title
        setupData()
    }

    func setupUI() {
        setupCustomUI()

        tableView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.bottom.equalTo(toolView.snp.top)
        }
        toolView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(59+kBottomH)
        }
    }

    func setupCustomUI() {

//        textField = UITextField(frame: CGRect(x: 0, y: 0, width: kScreenW - 102, height: 34))
//        textField!.layer.cornerRadius = 17
//        textField!.backgroundColor = UIColor.hexColor(0xDEDEDE)
//        navigationItem.titleView = textField!
//        let rightBtn = UIButton(type: .custom)
//        rightBtn.setTitle("完成", for: .normal)
//        rightBtn.titleLabel?.font = UIFont.regular(14)
//        rightBtn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
//        rightBtn.size = CGSize(width: 55, height: 44)
//        let rightItem = UIBarButtonItem(customView: rightBtn)
//        navigationItem.rightBarButtonItem = rightItem
    }

    func setupData() {
        if !tableView.groups.isEmpty {
            tableView.groups.removeAll()
        }
        let table = MDBookmarkTable()
        var parentId: String?
        if let model = preModel {
            parentId = model.id
        }
        models = table.select(parentId)
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
                group.cellHight = 53
                group.datas = models
            }
        }
        tableView.reloadData()
    }

    //MARK: - MDBookmarkToolViewProtocol
    func newAction() {
        tableView.isEditing = false
        let editView = MDFolderTitleEditView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        editView.backgroundColor = UIColor.hexColor(hexColor: 0x000000, alpha: 0.5)
        editView.contentView.backgroundColor = UIColor.white
        editView.confirmBlock = { [weak self](text) in
            Log.debug(text)
            guard let sSelf = self else { return }
            let id = UUID().uuidString
            var model = MDBookmarkModel()
            model.id = id
            model.isFolder = true
            model.title = text
            model.parentId = sSelf.preModel?.id
            model.path = "\(sSelf.preModel?.path ?? "")/\(id)"
            let table = MDBookmarkTable()
            do {
                try table.insert(model)
                sSelf.setupData()
            }
            catch {
                MBProgressHUD.showToast(text: error.localizedDescription)
            }
        }
        editView.show()
    }

    func moveAction() {
        guard let moveModel = selectedModels.first else { return }
        tableView.isEditing = false
        toolView.cancelAction()
        let vc = MDBookmarkFolderSelectViewController(moveModel: moveModel)
        let nav = MDBrowserNavigtionViewController(rootViewController: vc)
        navigationController?.present(nav, animated: true)
    }

    func deleteAction() {
        tableView.isEditing = false
        let table = MDBookmarkTable()
        selectedModels.forEach { model in
            table.delete(model)
            self.setupData()
            self.toolView.cancelAction()
        }
    }

    func modifyAction() {
        self.toolView.cancelAction()
        if let model = selectedModels.first {
            let modifyVc = MDBookmarkModifyViewController(model: model)
            navigationController?.pushViewController(modifyVc, animated: true)
        }
    }

    func editAction() {
        tableView.isEditing = true
        if !selectedModels.isEmpty {
            selectedModels.removeAll()
        }
    }

    func cancelAction() {
        tableView.isEditing = false
    }

    func saveAction() {

    }

    //MARK: - lazy method

    lazy var tableView: MDBaseTableView = {
        let tView = MDBaseTableView(frame: .zero, style: .plain)
        tView.allowsMultipleSelectionDuringEditing = true
        tView.contentInset = UIEdgeInsets(top: 28, left: 0, bottom: 28, right: 0)
        tView.backgroundColor = UIColor.hexColor(0xF5F5F5)
        tView.rowHeight = 66
        tView.separatorStyle = .none
        tView.registerClassCell(any: [MDBookmarkCell.self])
        tView.cellForRow = { [weak self](tableView, indexPath) in
            let cell = tableView.dequeueReusableCell(withIdentifier:"MDBookmarkCell")
            if let selectedItems = tableView.indexPathsForSelectedRows {
                let contain = selectedItems.contains { $0 == indexPath }
                if contain {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
            cell!.selectedBackgroundView = UIView(frame: cell!.frame)
            cell!.selectedBackgroundView?.backgroundColor = UIColor.clear
            return cell
        }
        tView.didSelectRow = { [weak self](_, indexPath) in
            self?.didSelected(indexPath)
        }
        tView.didDeselectRow = { [weak self](_, indexPath) in
            self?.didDeselected(indexPath)
        }
        tView.scrollViewWillBeginDragging = { [weak self] in
//            if let sSelf = self, let textField = sSelf.textField {
//                textField.endEditing(true)
//            }
        }
        tView.emptyStateDelegate = self
        tView.emptyStateDataSource = self
        view.addSubview(tView)
        return tView
    }()

    func setupToolView() -> MDBookmarkToolView {
        let tView = MDBookmarkToolView(isMove: false, frame: .zero)
        tView.backgroundColor = .white
        return tView
    }

    lazy var toolView: MDBookmarkToolView = {
        let tView =  setupToolView()
        view.addSubview(tView)
        return tView
    }()
}

extension MDBookmarkViewController {

    @objc
    func backAction() {
        navigationController?.dismiss(animated: true)
    }

    @objc
    func didSelected(_ indexPath: IndexPath) {
        let newModel = models[indexPath.row]
        if tableView.isEditing {
            selectedModels.append(newModel)
            toolView.modifyBtn.isEnabled = selectedModels.count == 1
            toolView.deleteBtn.isEnabled = !selectedModels.isEmpty
            toolView.moveBtn.isEnabled = !selectedModels.isEmpty
            return
        }
        if newModel.isFolder {
            let vc = Maodou.MDBookmarkViewController(preModel:newModel)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if let vc = navigationController?.children.first as? MDSearchViewController,
               let urlStr = newModel.url,
               let url = URL(string: urlStr)
            {
                navigationController?.popToRootViewController(animated: true)
                vc.tabManager.selectedTab?.loadRequest(URLRequest(url: url))
            }
        }
    }

    func didDeselected(_ indexPath: IndexPath) {
        let newModel = models[indexPath.row]
        selectedModels = selectedModels.filter{$0.id != newModel.id }
        toolView.modifyBtn.isEnabled = selectedModels.count == 1
        toolView.deleteBtn.isEnabled = !selectedModels.isEmpty
        toolView.moveBtn.isEnabled = !selectedModels.isEmpty
        Log.debug(selectedModels)
    }


}

extension MDBookmarkViewController: WLEmptyStateDelegate {
    func enableScrollForEmptyState() -> Bool {
        return true
    }
}

extension MDBookmarkViewController: WLEmptyStateDataSource {

    func customViewForEmptyState() -> UIView? {
        let view = MDTableViewDefaultView()
        view.iconImgView.image = UIImage(named: "bookmark_empty_icon")
        view.tipLab.text = "BROWER_SEARCH_MENU_BOOKMARKS_NO_TIPS".localizable()
        view.bounds = tableView.bounds
        return view
    }
}
