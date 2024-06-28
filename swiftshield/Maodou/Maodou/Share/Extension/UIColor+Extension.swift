//
//  UIColor+Extension.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 十六进制颜色
    /// - Parameter hexColor: 十六进制数
    /// - Returns: 颜色
    static func hexColor(_ hexColor: Int) -> UIColor! {
        let color = UIColor(red: ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0,
                            green: ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0,
                            blue: ((CGFloat)(hexColor & 0xFF)) / 255.0,alpha: 1.0)
        return color
    }
    
    /// 十六进制颜色
    /// - Parameters:
    ///   - hexColor: 十六进制数
    ///   - alpha: 透明度（0-1 0透明 1不透明）
    /// - Returns: 颜色
    static func hexColor(hexColor: Int, alpha: Float) -> UIColor! {
        return UIColor(red: ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(hexColor & 0xFF)) / 255.0,alpha: CGFloat(alpha))
    }
    
    static func hex(hexString: String, alpha:CGFloat) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.clear}
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        if cString.count != 6 { return UIColor.clear }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        let mask = 0x000000FF
        r = UInt32(Int(r >> 16) & mask)
        g = UInt32(Int(g >> 8) & mask)
        b = UInt32(Int(b) & mask)
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        return self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
