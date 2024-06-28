//
//  MKTableViewDefaultView.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/20.
//

import UIKit

class MDTableViewDefaultView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }

        tipLab.snp.makeConstraints { make in
            make.top.equalTo(iconImgView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }

        moreBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-96)
            make.left.equalToSuperview().offset(38)
            make.right.equalToSuperview().offset(-38)
            make.width.lessThanOrEqualTo(320)
            make.height.equalTo(42)
        }
    }

    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        addSubview(imgView)
        return imgView
    }()

    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0xC6CBCF)
        lab.font = UIFont.regular(14)
        addSubview(lab)
        return lab
    }()

    lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.regular(16)
        btn.backgroundColor = UIColor.hexColor(0x7A7D89)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.hexColor(hexColor: 0x000000, alpha: 0.16).cgColor
        btn.layer.cornerRadius = 21
        btn.isHidden = true
        addSubview(btn)
        return btn
    }()

}
