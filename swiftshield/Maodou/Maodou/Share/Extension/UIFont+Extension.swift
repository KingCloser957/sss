//
//  UIFont+Extension.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//

import Foundation
import UIKit


extension UIFont {

    static func light(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
