//
//  MDFeedbackListCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDFeedbackListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = kThemeColor
//        contentView.addSubview(cornerView)
        contentView.addSubview(iconImgView)
        contentView.addSubview(titleLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(infoLab)
//        contentView.addSubview(lineView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    func refreshUI(_ model: MDFeedbackListModel) {
//        infoLab.text = model.content
////        let body = model.body ?? ""
////        let attBody = NSString.getContentAttributeString(withText: body)
////        infoLab.text = attBody.string
////        infoLab.text = model.body
//        timeLab.text = model.createdTime
//        iconImgView.isHidden = (model.isRead == 0) ? true : false
//        layoutIfNeeded()
//    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        cornerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
//        }
        iconImgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 6, height: 6))
            make.centerY.equalTo(timeLab)
            make.left.equalToSuperview().offset(29)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(43)
        }
        timeLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-40)
            make.centerY.equalTo(titleLab)
        }
        infoLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(43)
            make.right.equalToSuperview().offset(-33)
            make.top.equalTo(titleLab.snp_bottom).offset(7)
            make.bottom.equalToSuperview().offset(-6)
        }

//        lineView.snp.makeConstraints { make in
//            make.bottom.right.equalToSuperview()
//            make.height.equalTo(0.5)
//            make.left.equalToSuperview().offset(29)
//            make.right.equalToSuperview().offset(-29)
//        }
    }

//    lazy var cornerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.hexColor(0x172330)
//        return view
//    }()

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
        label.font = UIFont(name: "PingFangSC-Medium", size: 14)
        label.textColor = .white
        return label
    }()

    lazy var infoLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.light(11)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    lazy var timeLab: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.light(11)
        label.textColor = UIColor.hexColor(0xD5D5D5)
        return label
    }()

    lazy var lineView: UIView = {
        let lineV = UIView()
        lineV.backgroundColor = UIColor.hexColor(0x2f3f4d)
        return lineV
    }()

}


extension MDFeedbackListCell: UITableViewCellProtocol {

    func refreshData<T>(_ model: T) {
        guard let model = model as? MDFeedbackListModel else { return }
        titleLab.text = getTitle(kind: model.kind)
        infoLab.text = model.content
        timeLab.text = model.createdTime
        iconImgView.isHidden = (model.isRead == 0) ? true : false
        layoutIfNeeded()
    }

    private func getTitle(kind:Int?) -> String {
        if kind == 10 {
            return "SETTING_CONTACTUS_FEEDBACK_TYPE_SPEED".localizable()
        } else if kind == 11 {
            return "SETTING_CONTACTUS_FEEDBACK_TYPE_LESS_GAMES".localizable()
        } else if kind == 12 {
            return "SETTING_CONTACTUS_FEEDBACK_TYPE_CRASH".localizable()
        } else {
            return "SETTING_CONTACTUS_FEEDBACK_TYPE_OTHER".localizable()
        }
    }
}
