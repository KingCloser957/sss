//
//  OOBasePopupView.swift
//  Orchid
//
//  Created by 李白 on 2022/8/5.
//

import UIKit

class FVPopupScheduler {

    var queue: DispatchQueue = DispatchQueue(label:"com.orchid.popup.queue")
    var lists: [MDBasePopupView] = []
    static var instance = FVPopupScheduler()
    static func shared() -> FVPopupScheduler {
        return instance
    }

    func add(_ view: MDBasePopupView) {
        queue.async {
            self.lists.append(view)
        }
    }

    func remove(_ view: MDBasePopupView) {
        queue.async {
            self.lists = self.lists.filter({ item in
                view != item
            })
        }
    }
}

class MDBasePopupView: UIView {

    var dismissClosure: (() -> Void)?

    public func dismiss() {
        removeFromSuperview()
        if let dismissClosure = dismissClosure {
            dismissClosure()
        }
//        OOPopupScheduler.shared().remove(self)
//        if !OOPopupScheduler.shared().lists.isEmpty {
//            UIApplication.shared.keyWindow?.addSubview(OOPopupScheduler.shared().lists.first!)
//        }
    }

    public func show() {
//        OOPopupScheduler.shared().add(self)
//        if OOPopupScheduler.shared().lists.count == 1 {
            UIApplication.shared.keyWindow?.addSubview(self)
//        }

    }

    lazy var contentView: UIView = {
        let cView = UIView()
        cView.backgroundColor = .clear
        cView.layer.cornerRadius = 8.0
        cView.layer.masksToBounds = true
        addSubview(cView)
        return cView
    }()
}
