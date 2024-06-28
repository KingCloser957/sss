//
//  MDToolsBarView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDWebToolViewProtocol {
    func backAction()
    func forwardAction()
    func reloadAction()
    func addTableAction()
    func showTabsAction()
    func moreAction()
}

class MDToolsBarView: UIView {
    
    func refreshTabNumbers(_ count: Int) {
        numBtn.setTitle("\(count)", for: .normal)
    }

    override func layoutSubviews() {
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(49)
        }
    }

    lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.backgroundColor = .white
        stackview.axis = .horizontal
        stackview.spacing = 10
        stackview.distribution = .fillEqually
        stackview.addArrangedSubview(backBtn)
        stackview.addArrangedSubview(forwardBtn)
        stackview.addArrangedSubview(addBtn)
        stackview.addArrangedSubview(numBtn)
        stackview.addArrangedSubview(moreBtn)
        addSubview(stackview)
        return stackview
    }()

    lazy var backBtn: UIButton = {
        let btn = UIButton(type:.custom)
        btn.setImage(UIImage(named: "tool_back_icon"), for: .normal)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return btn
    }()
    lazy var forwardBtn: UIButton = {
        let btn = UIButton(type:.custom)
        btn.setImage(UIImage(named: "tool_forward_icon"), for: .normal)
        btn.addTarget(self, action: #selector(forwardAction), for: .touchUpInside)
        return btn
    }()
    lazy var reloadBtn: UIButton = {
        let btn = UIButton(type:.custom)
        btn.setImage(UIImage(named: "search_refresh_icon"), for: .normal)
        btn.addTarget(self, action: #selector(reloadAction), for: .touchUpInside)
        return btn
    }()
    lazy var addBtn: UIButton = {
        let btn = UIButton(type:.custom)
        btn.setImage(UIImage(named: "tool_add_icon"), for: .normal)
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }()
    lazy var numBtn: MDNumButton = {
        let btn = MDNumButton(type:.custom)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 10)
        btn.setImage(UIImage(named: "tool_page_number_icon"), for: .normal)
        btn.addTarget(self, action: #selector(tablesAction), for: .touchUpInside)
        return btn
    }()
    lazy var moreBtn: UIButton = {
        let btn = UIButton(type:.custom)
        btn.setImage(UIImage(named: "tool_more_icon"), for: .normal)
        btn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return btn
    }()

}

extension MDToolsBarView {
    @objc
    func backAction() {
        guard let target = viewController() as? MDWebToolViewProtocol else { return }
        target.backAction()
    }

    @objc
    func forwardAction() {
        guard let target = viewController() as? MDWebToolViewProtocol else { return }
        target.forwardAction()
    }
    
    @objc
    func reloadAction() {
        guard let target = viewController() as? MDWebToolViewProtocol else { return }
        target.forwardAction()
    }

    @objc
    func addAction() {
        guard let target = viewController() as? MDWebToolViewProtocol else { return }
        target.addTableAction()
    }

    @objc
    func tablesAction() {
        guard let target = viewController() as? MDWebToolViewProtocol else { return }
        target.showTabsAction()
    }

    @objc
    func moreAction() {
        guard let target = viewController() as? MDWebToolViewProtocol else { return }
        target.moreAction()
    }
}

class MDNumButton: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let x = contentRect.width*0.5 - 9.5
        let y = contentRect.height*0.5 - 9.5
        return CGRect.init(x: x , y: y, width: 19, height: 19)
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let x = contentRect.width*0.5 - 9.5
        let y = contentRect.height*0.5 - 9.5
        return CGRect.init(x: x , y: y, width: 20, height: 20)
    }
}
