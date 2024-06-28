//
//  MDGridToolView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDGridToolViewProtocol {
    func closeAllTableAction()
    func newTableAction()
    func backAction()
}

class MDGridToolView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }

    lazy var stackView: UIStackView = {
        let sView = UIStackView(arrangedSubviews: [closeBtn, newBtn, backBtn])
        sView.axis = .horizontal
        sView.distribution = .fillEqually
        addSubview(sView)
        return sView
    }()

    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "table_close_all_icon"), for: .normal)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return btn
    }()

    lazy var newBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "table_new_icon"), for: .normal)
        btn.addTarget(self, action: #selector(newAction), for: .touchUpInside)
        return btn
    }()

    lazy var backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "table_back_icon"), for: .normal)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return btn
    }()

}

extension MDGridToolView {
    @objc
    func closeAction() {
        guard let target = viewController() as? MDGridToolViewProtocol else { return }
        target.closeAllTableAction()
    }

    @objc
    func newAction() {
        guard let target = viewController() as? MDGridToolViewProtocol else { return }
        target.newTableAction()
    }

    @objc
    func backAction() {
        guard let target = viewController() as? MDGridToolViewProtocol else { return }
        target.backAction()
    }

}
