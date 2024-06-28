//
//  MDSearchResultCell.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDSearchResultCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(titleLab)
        contentView.addSubview(iconImgView)
        contentView.addSubview(lineView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(49)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    lazy var titleLab: UILabel = {
        let cView = UILabel()
        cView.font = UIFont.regular(12)
        cView.textColor = UIColor.hexColor(0x0B0B0B)
        return cView
    }()
    
    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "search_icon")
        return imgView
    }()
    
    lazy var lineView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.hexColor(0xF5F5F5)
        return cView
    }()
    
    func refreshUI(with text:String) {
        self.titleLab.text = text
    }
}
