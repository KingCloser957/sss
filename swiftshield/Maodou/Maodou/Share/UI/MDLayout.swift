//
//  MKNetworkTool.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//


import UIKit

struct MDLayout {

    static let scalRatio:CGFloat = (UIScreen.main.bounds.size.width > 450.0 ? 450.0 : UIScreen.main.bounds.size.width) / 375.0
    static func layout(_ number:CGFloat) -> CGFloat {
        return scalRatio * number
    }
}
