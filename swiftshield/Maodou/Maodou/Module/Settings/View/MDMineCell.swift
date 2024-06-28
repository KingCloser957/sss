//
//  MDMineCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDMineCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = kThemeColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        redDotImgView.snp.makeConstraints { make in
            make.left.equalTo(iconImgView.snp.right).offset(0)
            make.top.equalTo(iconImgView)
            make.size.equalTo(CGSize(width: 6, height: 6))
        }
        iconImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 17))
        }

        if iconImgView.isHidden {
            titleLab.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(40)
                make.top.equalToSuperview().offset(26)
                make.bottom.equalToSuperview().offset(-26)
            }
        } else {
            titleLab.snp.makeConstraints { make in
                make.left.equalTo(iconImgView.snp_right).offset(19)
                make.top.equalToSuperview().offset(26)
                make.bottom.equalToSuperview().offset(-26)
            }
        }

        titleLab.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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

    lazy var redDotImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tip6")
        contentView.addSubview(view)
        return view
    }()

    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        contentView.addSubview(imgView)
        return imgView
    }()

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
}

extension MDMineCell: UITableViewCellProtocol {
    func refreshData<T>(_ model: T) {
        guard let model = model as? MDMineCellModel else { return }
        titleLab.text = model.title
        infoLab.text = model.info
        if let icon = model.icon {
            iconImgView.image = UIImage(named: icon)
            iconImgView.isHidden = false
        } else {
            iconImgView.isHidden = true
        }
        redDotImgView.isHidden = !(model.needRedDot ?? false)
        arrowImgView.isHidden = !(model.needArrowIcon ?? true)
        layoutIfNeeded()
    }
}
