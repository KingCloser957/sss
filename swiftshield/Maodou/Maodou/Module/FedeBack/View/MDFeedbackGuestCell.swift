//
//  MDFeedbackGuestCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDFeedbackGuestCell: MDFeedbackDetailCell {
    
    private var data: MDFeedbackRecordModel?

    override func refreshUI(_ model: Any) {
        guard let newModel = model as? MDFeedbackRecordModel else { return }
        data = newModel
        infoLab.text = newModel.content
        if let imageUrl = newModel.imageUrl, !imageUrl.isEmpty {
//            feedbackImgView.sd_setImage(with: URL(string: imageUrl))
        }
        timeLab.text = newModel.createTime
        iconImgView.image = UIImage(named: "headpic")
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageUrl = data?.imageUrl, !imageUrl.isEmpty {
            imageViewWidth?.update(offset: 85)
        } else {
            imageViewWidth?.update(offset: 0)
        }
        iconImageLeft?.update(offset: kScreenW - 60)
        cornerLeft?.update(offset: 22)
    }

}
