//
//  MDBookmarkToolView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDBookmarkToolViewProtocol {
    func newAction()
    func moveAction()
    func deleteAction()
    func modifyAction()
    func editAction()
    func cancelAction()
    func saveAction()
}

class MDBookmarkToolView: UIView {
    
    var isMove: Bool = false
    init(isMove: Bool = false, frame: CGRect) {
        self.isMove = isMove
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(49)
        }
    }

    lazy var stackView: UIStackView = {
        var arranges = [newBtn, moveBtn, deleteBtn, modifyBtn, editBtn]
        if isMove {
            arranges = [newBtn, saveBtn]
        }
        let sView = UIStackView(arrangedSubviews: arranges)
        sView.axis = .horizontal
        sView.distribution = .fillEqually
        addSubview(sView)
        return sView
    }()

    lazy var newBtn: MDBookmarkToolItem = {
        let btn = MDBookmarkToolItem(type: .custom)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.regular(10)
        btn.setTitle("BROWER_SEARCH_MENU_BOOKMARKS_ADD".localizable(), for: .normal)
        btn.setImage(UIImage(named: "bookmark_add_icon"), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        btn.addTarget(self, action: #selector(newAction), for: .touchUpInside)
        return btn
    }()

    lazy var saveBtn: MDBookmarkToolItem = {
        let btn = MDBookmarkToolItem(type: .custom)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.regular(10)
        btn.setTitle("BROWER_SEARCH_MENU_BOOKMARKS_SAVA".localizable(), for: .normal)
        btn.setImage(UIImage(named: "bookmark_save_icon"), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return btn
    }()

    lazy var moveBtn: MDBookmarkToolItem = {
        let btn = MDBookmarkToolItem(type: .custom)
        btn.isEnabled = false
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.regular(10)
        btn.setTitle("BROWER_SEARCH_MENU_BOOKMARKS_NOVE".localizable(), for: .normal)
        btn.setImage(UIImage(named: "bookmark_move_icon"), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x9C9C9C), for: .disabled)
        btn.addTarget(self, action: #selector(moveAction), for: .touchUpInside)
        return btn
    }()

    lazy var deleteBtn: MDBookmarkToolItem = {
        let btn = MDBookmarkToolItem(type: .custom)
        btn.isEnabled = false
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.regular(10)
        btn.setTitle("BROWER_SEARCH_MENU_BOOKMARKS_DELETE".localizable(), for: .normal)
        btn.setImage(UIImage(named: "bookmark_delete_icon"), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x9C9C9C), for: .disabled)
        btn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return btn
    }()

    lazy var modifyBtn: MDBookmarkToolItem = {
        let btn = MDBookmarkToolItem(type: .custom)
        btn.isEnabled = false
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.regular(10)
        btn.setTitle("BROWER_SEARCH_MENU_BOOKMARKS_CHANGE".localizable(), for: .normal)
        btn.setImage(UIImage(named: "bookmark_modify_icon"), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x9C9C9C), for: .disabled)
        btn.addTarget(self, action: #selector(modifyAction), for: .touchUpInside)
        return btn
    }()

    lazy var editBtn: MDBookmarkToolItem = {
        let btn = MDBookmarkToolItem(type: .custom)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.regular(10)
        btn.setTitle("BROWER_SEARCH_MENU_BOOKMARKS_EDIT".localizable(), for: .normal)
        btn.setImage(UIImage(named: "bookmark_edit_icon"), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        btn.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return btn
    }()

    lazy var cancelBtn: MDBookmarkToolItem = {
        let btn = MDBookmarkToolItem(type: .custom)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.regular(10)
        btn.setTitle("SETTING_CONTACTUS_CANCEL".localizable(), for: .normal)
        btn.setImage(UIImage(named: "bookmark_cancel_icon"), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()


}

@objc extension MDBookmarkToolView {
    func newAction() {
        cancelAction()
        guard let target = viewController as? MDBookmarkToolViewProtocol else { return }
        target.newAction()
    }

    func moveAction() {
        guard let target = viewController as? MDBookmarkToolViewProtocol else { return }
        target.moveAction()
    }

    func deleteAction() {
        guard let target = viewController as? MDBookmarkToolViewProtocol else { return }
        target.deleteAction()
    }

    func modifyAction() {
        guard let target = viewController as? MDBookmarkToolViewProtocol else { return }
        target.modifyAction()
    }

    func editAction() {
        editBtn.removeFromSuperview()
        stackView.addArrangedSubview(cancelBtn)
        guard let target = viewController as? MDBookmarkToolViewProtocol else { return }
        target.editAction()
    }

    func cancelAction() {
        cancelBtn.removeFromSuperview()
        stackView.addArrangedSubview(editBtn)
        moveBtn.isEnabled = false
        deleteBtn.isEnabled = false
        modifyBtn.isEnabled = false
        guard let target = viewController as? MDBookmarkToolViewProtocol else { return }
        target.cancelAction()
    }

    func saveAction() {
        guard let target = viewController as? MDBookmarkToolViewProtocol else { return }
        target.saveAction()
    }
}

class MDBookmarkToolItem: UIButton {

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imgSize = currentImage?.size ?? .zero
        let x = (contentRect.width - imgSize.width)*0.5
        return CGRect.init(x: x,
                           y: 15,
                           width: imgSize.width,
                           height: imgSize.height)
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 0,
                           y: 44,
                           width: contentRect.width,
                           height: 10)
    }

}
