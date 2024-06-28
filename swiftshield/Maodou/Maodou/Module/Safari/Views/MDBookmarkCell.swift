//
//  MDBookmarkCell.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDBookmarkCell: MDCornerViewCell {
    
    var model: MDBookmarkModel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(iconImgView)
        contentView.addSubview(strLab)
        contentView.addSubview(titleLab)
        contentView.addSubview(infoLab)
        cornerView.backgroundColor = UIColor.white
        lineView.isHidden = true
        tintColor = UIColor.hexColor(0x0055FF)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerSize = CGSize(width: 19, height: 19)
        let bounds = CGRect(x: 0, y: 0, width: contentView.width - 30, height: contentView.height)
        let style = model.cornerStyle
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: style , cornerRadii: cornerSize)
        maskLayer.path = path.cgPath
        cornerView.layer.mask = maskLayer

        iconImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        strLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(iconImgView.snp.right).offset(12)
//            make.centerY.equalToSuperview()
            make.top.equalTo(iconImgView)
            make.trailing.equalToSuperview().offset(-40)
        }
        infoLab.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-40)
            make.leading.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom).offset(1)
        }
    }

    lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "bookmark_floder_icon")
        return imgView
    }()

    lazy var strLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x000000)
        lab.font = UIFont.regular(15)
        lab.layer.cornerRadius = 15
        lab.layer.borderWidth = 1
        lab.layer.borderColor = UIColor.hexColor(0x8C8C8C).cgColor
        lab.textAlignment = .center
        return lab
    }()

    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x000000)
        lab.font = UIFont.regular(12)
        return lab
    }()

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x8C8C8C)
        lab.font = UIFont.regular(10)
        return lab
    }()
}

extension MDBookmarkCell: UITableViewCellProtocol {
    func refreshData<T>(_ model: T) {
        guard let newModel = model as? MDBookmarkModel else { return }
        self.model = newModel
        iconImgView.isHidden = !newModel.isFolder
        strLab.isHidden = newModel.isFolder
        if !newModel.isFolder {
            if let char = newModel.title?.first {
                strLab.text = String(char)
            } else {
                strLab.text = ""
            }
            infoLab.text = newModel.url
        } else {
            infoLab.text = ""
        }
        titleLab.text = newModel.title

    }
}
