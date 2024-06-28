//
//  MDHistoryToolView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDHistoryToolView: UIView {
    
    var clearBlock: (() -> Void)?
    override func layoutSubviews() {
        super.layoutSubviews()
        clearBtn.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(49)
        }
    }

    lazy var clearBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("BROWER_SEARCH_MENU_BOOKMARKS_NO_HISTORY".localizable(), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0xFF0000), for: .normal)
        btn.titleLabel?.font = UIFont.regular(12)
        btn.addTarget(self, action: #selector(clearBtnAction), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()

    @objc
    func clearBtnAction() {
        if let block = clearBlock {
            block()
        }
    }

}
