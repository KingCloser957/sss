//
//  MKUIConstant.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/10.
//

import Foundation
import UIKit
//let height = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.height)!
let kStatusBarH = UIApplication.shared.statusBarFrame.height
let isX = (kStatusBarH == 44) ? true : false
let kBottomH = isX ? 34.0 : 0.0
let kTabBarH = 49.0 + kBottomH
let kNavBarH = 44 + kStatusBarH

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

let keyWindow = UIApplication.shared.currentWindow

let kThemeColor = UIColor.hexColor(0x222536)

