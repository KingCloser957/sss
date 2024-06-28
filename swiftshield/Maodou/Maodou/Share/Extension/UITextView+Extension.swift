//
//  UITextView+Extension.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/21.
//

import Foundation
import UIKit

fileprivate var kTextViewPlaceholderLabel : Int = 0x2022_00
fileprivate var kTextViewPlaceholder      : Int = 0x2022_01
fileprivate var kTextViewPlaceholderColor : Int = 0x2022_02
fileprivate var kTextViewPlaceholderFont  : Int = 0x2022_03
fileprivate var kTextViewPlaceholderKeys  : Int = 0x2022_04
let kNormalViewColor = UIColor.hexColor(hexColor: 0x0D1925, alpha: 1.0)
extension UITextView {

    /// 占位符
    var x_placeholder: String {
        get {
            if let placeholder = objc_getAssociatedObject(self, &kTextViewPlaceholder) as? String {
                return placeholder
            } else {
                return ""
            }
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholder, newValue, .OBJC_ASSOCIATION_RETAIN)
            x_placeholderLabel.text = newValue
        }
    }

    /// 占位符颜色
    var x_placeholderColor: UIColor {
        get {
            if let placeholderColor = objc_getAssociatedObject(self, &kTextViewPlaceholderColor) as? UIColor {
                return placeholderColor
            } else {
                return kNormalViewColor!
            }
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholderColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            x_placeholderLabel.textColor = newValue
        }
    }

    /// 占位符字体
    var x_placeholderFont: UIFont {
        get {
            if let placeholderFont = objc_getAssociatedObject(self, &kTextViewPlaceholderColor) as? UIFont {
                return placeholderFont
            } else {
                return UIFont.systemFont(ofSize: 12)
            }
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholderColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            x_placeholderLabel.font = newValue
        }
    }

    /// 占位符 标签
    @IBInspectable var x_placeholderLabel: UILabel {
        get {
            var _placeholderLabel = UILabel()
            _placeholderLabel.font = self.font ?? UIFont.systemFont(ofSize: 12)
            _placeholderLabel.textColor = kNormalViewColor
            _placeholderLabel.textAlignment = .left
            if let label = objc_getAssociatedObject(self, &kTextViewPlaceholderLabel) as? UILabel {
                _placeholderLabel = label
            } else {
                objc_setAssociatedObject(self, &kTextViewPlaceholderLabel, _placeholderLabel, .OBJC_ASSOCIATION_RETAIN)
            }
            addPlaceholderLabelToSuperView(label: _placeholderLabel)
            return _placeholderLabel
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN)
            addPlaceholderLabelToSuperView(label: newValue)
        }
    }

    /// 是否需要添加占位符到父视图
    fileprivate var x_placeHolderNeedAddToSuperView: Bool {
        get {
            if let isAdded = objc_getAssociatedObject(self, &kTextViewPlaceholderKeys) as? Bool {
                return isAdded
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholderKeys, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// 添加占位符到父视图
    ///
    /// - Parameter label: 占位符 标签
    fileprivate func addPlaceholderLabelToSuperView(label: UILabel) {

        guard x_placeHolderNeedAddToSuperView else { return }
        x_placeHolderNeedAddToSuperView = false

        NotificationCenter.default.addObserver(self, selector: #selector(x_textChange(noti:)), name: UITextView.textDidChangeNotification, object: nil)

        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 2, bottom: 0, right: 0))
        }
    }

    /// 编辑事件
    @objc fileprivate func x_textChange(noti: NSNotification) {
        let isEmpty = text.isEmpty
        print("text:\(String(describing: text))\nisEmpty:\(isEmpty)")
        x_placeholderLabel.text = isEmpty ? x_placeholder : ""
        x_placeholderLabel.isHidden = !isEmpty
    }
}
