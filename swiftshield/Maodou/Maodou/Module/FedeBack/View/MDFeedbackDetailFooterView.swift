//
//  MDFeedbackDetailFooterView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDFeedbackDetailFooterView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }

    func refreshText(_ text: String) {
        titleLab.text = "——\(text)——"
    }

    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "—— \("FEEDBACK_HAS_GET_TIP".localizable()) ——"
        lab.font = UIFont.regular(12 )
        lab.textColor = UIColor.hexColor(0x7A7D89)
        addSubview(lab)
        return lab
    }()
}
