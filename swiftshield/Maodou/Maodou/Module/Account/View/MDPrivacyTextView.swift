//
//  MDPrivacyTextView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import AttributedString

class MDPrivacyTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isScrollEnabled = false
        textColor = UIColor.hexColor(0x979DAD)
        linkTextAttributes = [:]
        attributed.text = """
                          \("LOGIN_PRIVACY_FIRST_TIPS".localizable(), .foreground(UIColor.hexColor(0x78869B)))\(" \("LOGIN_PRIVACY_USER_TERS".localizable() )", .foreground(UIColor.hexColor(0x331D9A)), .link(termsUrl))\("LOGIN_PRIVACY_USER_AND".localizable() ,.foreground(UIColor.hexColor(0x78869B)))\("LOGIN_PRIVACY_USER_PRIVACY".localizable(), .foreground(UIColor.hexColor(0x331D9A)), .link(privacyUrl))\("，\("LOGIN_PRIVACY_USER_ALLOW_PRIVACY".localizable())", .foreground(UIColor.hexColor(0x78869B)))
                          """
        font = UIFont.regular(12)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
