//
//  MDFeedbackInfoCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDFeedbackInfoCell: MDFeedbackDetailCell {
    private var data: MDFeedbackListModel?

    override func setupUI() {
        super.setupUI()
        cornerView.addSubview(grayView)
        grayView.addSubview(titleLab)
    }
    override func refreshUI(_ model: Any) {
        guard let newModel = model as? MDFeedbackListModel else { return }
        data = newModel
        titleLab.text = getTitle(data?.kind)
        infoLab.attributed.text = """
                                \("\("SETTING_CONTACTUS_MESSAGE".localizable())：", .foreground(UIColor.hexColor(0xB3B7BE)))
                                \(data?.content ?? "" , .foreground(UIColor.hexColor(0xDADEE3)))
                                """
        if let imageUrl = newModel.imageUrl?.first {
//            feedbackImgView.sd_setImage(with: URL(string: imageUrl))
            let placeholder = UIImage.image(color: UIColor.hexColor(0x5F677B))
            feedbackImgView.sd_setImage(with: URL(string: imageUrl),
                                        placeholderImage: placeholder)
        }
        timeLab.text = newModel.createdTime
        iconImgView.image = UIImage(named: "headuser")
        layoutIfNeeded()
    }

    private func getTitle(_ kind:Int?) -> String {
        switch kind {
        case 10:
            return "SETTING_CONTACTUS_FEEDBACK_TYPE_SPEED".localizable()
        case 11:
            return "SETTING_CONTACTUS_FEEDBACK_TYPE_LESS_GAMES".localizable()
        case 12:
            return "SETTING_CONTACTUS_FEEDBACK_TYPE_CRASH".localizable()
        case 13:
            return "SETTING_CONTACTUS_FEEDBACK_TYPE_OTHER".localizable()
        default:
            return ""
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        grayView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(42)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.centerY.equalToSuperview()
        }
        infoLab.snp.remakeConstraints({ make in
            make.left.equalTo(cornerView).offset(17)
            make.right.equalTo(cornerView).offset(-17)
            make.top.equalTo(grayView.snp.bottom).offset(15)
        })
        if let imageUrl = data?.imageUrl, !imageUrl.isEmpty  {
            imageViewWidth?.update(offset: 85)
        } else {
            imageViewWidth?.update(offset: 0)
        }
    }

    lazy var grayView: UIView = {
        let lab = UIView()
        lab.backgroundColor = UIColor.hexColor(0x3A4152)
        return lab
    }()

    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.hexColor(0x3A4152)
        lab.font = UIFont.regular(20)
        return lab
    }()
}
