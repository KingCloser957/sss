//
//  MDCornerViewCell.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDCornerViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(cornerView)
        contentView.addSubview(lineView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cornerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview()
        }
    }

    lazy var cornerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.hexColor(0xD0D8E1)
        return cView
    }()

    lazy var lineView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.hexColor(hexColor: 0x7C8187, alpha: 0.5)
        return cView
    }()

}
