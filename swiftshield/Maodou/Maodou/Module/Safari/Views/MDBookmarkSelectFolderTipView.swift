//
//  MDBookmarkSelectFolderTipView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDBookmarkSelectFolderTipView: UIView {
    var toSelectFolderBlock: (() -> Void)?
    override func layoutSubviews() {
        super.layoutSubviews()
        tipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        selectBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalTo(tipLab.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }

    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.text = "已保存到书签"
        lab.font = UIFont.regular(14)
        lab.textColor = .white
        addSubview(lab)
        return lab
    }()

    lazy var selectBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.backgroundColor = UIColor.hexColor(0x000DFF)
        btn.layer.cornerRadius = 12.5
        btn.titleLabel?.font = UIFont.regular(14)
        btn.setTitle("更改位置", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(selectBtnAction), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()
}

@objc
extension MDBookmarkSelectFolderTipView {
    func selectBtnAction() {
        if let block = toSelectFolderBlock {
            block()
        }
    }
}
