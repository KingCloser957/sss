//
//  UIView+Extension.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//
import UIKit

extension UIView {
    // 扩展 x 的 set get 方法
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newX) {
            var tmpFrame: CGRect = frame
            tmpFrame.origin.x = newX
            frame = tmpFrame
        }
    }

    // 扩展 y 的 set get 方法
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newY) {
            var tmpFrame: CGRect = frame
            tmpFrame.origin.y = newY
            frame = tmpFrame
        }
    }

    // 扩展 width 的 set get 方法
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set(newWidth) {
            var tmpFrameWidth: CGRect = frame
            tmpFrameWidth.size.width = newWidth
            frame = tmpFrameWidth
        }
    }

    // 扩展 height 的 set get 方法
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set(newHeight) {
            var tmpFrameHeight: CGRect = frame
            tmpFrameHeight.size.height = newHeight
            frame = tmpFrameHeight
        }
    }

    // 扩展 centerX 的 set get 方法
    var centerX: CGFloat {
        get {
            return center.x
        }
        set(newCenterX) {
            center = CGPoint(x: newCenterX, y: center.y)
        }
    }

    // 扩展 centerY 的 set get 方法
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newCenterY) {
            center = CGPoint(x: center.x, y: newCenterY)
        }
    }

    // 扩展 origin 的 set get 方法
    var origin: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
        set(newOrigin) {
            x = newOrigin.x
            y = newOrigin.y
        }
    }

    // 扩展 size 的 set get 方法
    var size: CGSize {
        get {
            return CGSize(width: width, height: height)
        }
        set(newSize) {
            width = newSize.width
            height = newSize.height
        }
    }

    // 扩展 left 的 set get 方法
    var left: CGFloat {
        get {
            return x
        }
        set(newLeft) {
            x = newLeft
        }
    }

    // 扩展 right 的 set get 方法
    var right: CGFloat {
        get {
            return x + width
        }
        set(newNight) {
            x = newNight - width
        }
    }

    // 扩展 top 的 set get 方法
    var top: CGFloat {
        get {
            return y
        }
        set(newTop) {
            y = newTop
        }
    }

    // 扩展 bottom 的 set get 方法
    var bottom: CGFloat {
        get {
            return  y + height
        }
        set(newBottom) {
            y = newBottom - height
        }
    }

    func viewController() -> UIViewController? {
        var nextResponse:UIResponder? = self

        repeat {
            nextResponse = nextResponse?.next
            if let vc = nextResponse as? UIViewController {
                return vc
            }

        }while nextResponse != nil

        return nil
    }

}

extension UITextField {
    var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
        }
        set {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: newValue as Any])
        }
    }
}

extension UIView{
    func drawBoardDottedLine(width:CGFloat,lenth:CGFloat,space:CGFloat,cornerRadius:CGFloat,color:UIColor){
        self.layer.cornerRadius = cornerRadius
        let borderLayer =  CAShapeLayer()
        borderLayer.bounds = self.bounds
        
        borderLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY);
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
        borderLayer.lineWidth = width / UIScreen.main.scale
        
        borderLayer.lineDashPattern = [lenth,space] as? [NSNumber] //前边是虚线的长度，后边是虚线之间空隙的长度
        borderLayer.lineDashPhase = 0.1;
        //实线边框
        
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        self.layer.addSublayer(borderLayer)
    }
}
