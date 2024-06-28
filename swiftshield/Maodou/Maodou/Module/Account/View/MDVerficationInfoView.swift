//
//  MDVerficationInfoView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDVerficationInfoView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(17)
        }

        infoLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-17)
            make.centerY.equalToSuperview()
        }

        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.right.left.equalToSuperview()
        }
    }


    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.regular(15)
        lab.textColor = UIColor.white
        addSubview(lab)
        return lab
    }()

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.regular(15)
        lab.textColor = UIColor.hexColor(0xDEE4F4)
        addSubview(lab)
        return lab
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0x2D3343)
        addSubview(view)
        return view
    }()

}
