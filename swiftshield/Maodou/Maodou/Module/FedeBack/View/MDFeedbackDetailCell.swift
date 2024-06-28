//
//  MDFeedbackDetailCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import SnapKit

class MDFeedbackDetailCell: UITableViewCell {
    
    var imageViewWidth: Constraint?
    var iconImageLeft: Constraint?
    var cornerLeft: Constraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = kThemeColor
        contentView.addSubview(cornerView)
        contentView.addSubview(iconImgView)
        contentView.addSubview(infoLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(feedbackImgView)
    }

    func refreshUI(_ model: Any) {

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cornerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalToSuperview().offset(-91)
            cornerLeft = make.left.equalToSuperview().offset(22).constraint
        }
        iconImgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalTo(cornerView)
            iconImageLeft = make.left.equalToSuperview().offset(kScreenW - 60).constraint
        }
        infoLab.snp.makeConstraints { make in
            make.left.equalTo(cornerView).offset(17)
            make.right.equalTo(cornerView).offset(-17)
            make.top.equalTo(cornerView).offset(14)
        }
        feedbackImgView.snp.makeConstraints { make in
            make.left.equalTo(cornerView).offset(17)
            make.top.equalTo(infoLab.snp_bottom).offset(3)
            imageViewWidth = make.width.height.equalTo(85).constraint
        }

        timeLab.snp.makeConstraints { make in
            make.left.equalTo(cornerView).offset(17)
            make.top.equalTo(feedbackImgView.snp_bottom).offset(13)
            make.bottom.equalTo(cornerView).offset(-13)
        }
    }

    lazy var cornerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0x2D3343)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "PingFangSC-Regular", size: 12)
        lab.numberOfLines = 0
        lab.textColor = UIColor.hexColor(0xDADEE3)
        return lab
    }()

    lazy var feedbackImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 15
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()

    lazy var timeLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x6E7C93)
        lab.font = UIFont(name: "PingFangSC-Regular", size: 12)
        return lab
    }()

    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()

}
