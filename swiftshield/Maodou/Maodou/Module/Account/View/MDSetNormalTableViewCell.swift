//
//  MDSetNormalTableViewCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDSetNormalTableViewCell: UITableViewCell {
    
    private var model: MDSetModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = kThemeColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.top.equalToSuperview().offset(26)
            make.bottom.equalToSuperview().offset(-26)
        }

        infoLab.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLab.snp_right).offset(20)
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowImgView.snp_left).offset(-13)
        }

        arrowImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-34)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }

    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.regular(15)
        lab.textColor = UIColor.hexColor(0xDEE4F4)
        contentView.addSubview(lab)
        return lab
    }()

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.regular(12)
        lab.textColor = UIColor.hexColor(0x979DAD)
        lab.numberOfLines = 0
        contentView.addSubview(lab)
        return lab
    }()

    lazy var arrowImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ic_arr_right")
        contentView.addSubview(imgView)
        return imgView
    }()

//    lazy var switchBtn: UIButton = {
//        let imgView = UIButton(type: .custom)
////        imgView.image = UIImage(named: "ic_arr_right")
//        contentView.addSubview(imgView)
//        return imgView
//    }()
//
}


extension MDSetNormalTableViewCell: UITableViewCellProtocol {

    func refreshData<T>(_ model: T) {
        guard let model = model as? MDSetModel else { return }
        titleLab.text = model.title
        infoLab.text = model.info
        arrowImgView.isHidden = !(model.needArrow ?? true)
        layoutIfNeeded()
    }
}
