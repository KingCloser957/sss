//
//  MDMineHeaderView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDMineHeaderView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 17,
                                                             left: 25,
                                                             bottom: 0,
                                                             right: 25))
        }
        avatarImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-18)
            make.height.equalTo(70)
            make.width.equalTo(avatarImgView.snp_height)
        }
        idLab.snp.makeConstraints { make in
            make.left.equalTo(avatarImgView.snp_right).offset(25)
            make.bottom.equalTo(avatarImgView.snp_centerY)
        }
        vipImgView.snp.makeConstraints { make in
            make.bottom.equalTo(idLab)
            make.left.equalTo(idLab.snp_right).offset(38)
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
        timeLab.snp.makeConstraints { make in
            make.left.equalTo(idLab)
            make.top.equalTo(idLab.snp_bottom).offset(9)
            make.right.equalTo(arrowImgView.snp_left).offset(-10)
        }
        arrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }

    func refreshUI() {
        let model = MDUserInfoManager.share.user()
        idLab.text = model?.getAccountName()
        if model?.user?.svipInvalidTime?.isEmpty ?? true {
            timeLab.text = "\("SETTING_ACCOUNT_EXPIRED_TIME".localizable()):\("SETTING_ACCOUNT_TIME_EXPIRED".localizable())"
        } else {
            timeLab.text = "\("SETTING_ACCOUNT_EXPIRED_TIME".localizable()):\(model?.user?.svipInvalidTime)"
        }
        if model?.user?.subStatus == 1  {
            avatarImgView.image = UIImage(named: "pic_headv")
            vipImgView.image = UIImage(named: "vpay_ok")
        } else {
            avatarImgView.image = UIImage(named: "pic_head")
            vipImgView.image = UIImage(named: "vpay")
        }
    }

    lazy var cornerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0x2D3342)
        view.layer.cornerRadius = 28
        addSubview(view)
        return view
    }()

    lazy var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        cornerView.addSubview(imgView)
        return imgView
    }()

    lazy var idLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont.regular(20)
        cornerView.addSubview(lab)
        return lab
    }()

    lazy var vipImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "vpay_none")
        cornerView.addSubview(imgView)
        return imgView
    }()

    lazy var timeLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x979DAD)
        lab.font = UIFont.regular(12)
        cornerView.addSubview(lab)
        return lab
    }()

    lazy var arrowImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ic_arr_right")
        cornerView.addSubview(imgView)
        return imgView
    }()
}
