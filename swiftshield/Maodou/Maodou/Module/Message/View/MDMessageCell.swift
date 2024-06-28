//
//  MDMessageCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDMessageCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = kThemeColor
        contentView.addSubview(cornerView)
        contentView.addSubview(iconImgView)
        contentView.addSubview(titleLab)
        contentView.addSubview(infoLab)
        contentView.addSubview(arrowImgView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 6, height: 6))
            make.centerY.equalTo(titleLab)
            make.left.equalToSuperview().offset(29)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(43)
            make.right.lessThanOrEqualToSuperview().offset(-63)
        }
        infoLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(43)
            make.right.equalToSuperview().offset(-63)
            make.top.equalTo(titleLab.snp_bottom).offset(4)
            make.bottom.equalToSuperview().offset(-15)
        }
        arrowImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
    }

    lazy var cornerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0x172330)
        return view
    }()

    lazy var iconImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tip6")
        return view
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(14)
        label.textColor = .white
        return label
    }()

    lazy var infoLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.light(11)
        label.textColor = UIColor.hexColor(0xA7AAB7)
        label.numberOfLines = 2
        return label
    }()

    lazy var arrowImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_arr_right")
        return view
    }()

//    lazy var timeLab: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .right
//        label.font = UIFont(name: "PingFangSC-Regular", size: 11)
//        label.textColor = UIColor.hexColor(0x5d5d5d)
//        return label
//    }()
//
//    lazy var lineView: UIView = {
//        let lineV = UIView()
//        lineV.backgroundColor = UIColor.hexColor(0x2f3f4d)
//        return lineV
//    }()

}

extension MDMessageCell: UITableViewCellProtocol {
    func refreshData<T>(_ model: T) {
        guard let model = model as? MDMessageModel else { return }
        titleLab.text = model.title
        infoLab.text = model.textBody
        iconImgView.isHidden = (model.isRead == 0) ? false : true
        layoutIfNeeded()
        layoutIfNeeded()
    }
}
