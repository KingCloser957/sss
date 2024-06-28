//
//  MDBindSuccessView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDBindSuccessView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        iconImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
        tipLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgView.snp_bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }

    lazy var contentView: UIView = {
        let view = UIView()
        addSubview(view)
        return view
    }()


    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icon_ok")
        contentView.addSubview(imgView)
        return imgView
    }()

    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x7C8190)
        lab.font = UIFont.regular(12)
        contentView.addSubview(lab)
        return lab
    }()

}
