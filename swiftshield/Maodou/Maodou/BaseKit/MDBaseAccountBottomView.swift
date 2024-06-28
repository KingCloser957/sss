//
//  MDBaseAccountBottomView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDBaseAccountBottomViewProtocol {
    func confirmAction()
}

class MDBaseAccountBottomView: UIView {

    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 20
        btn.layer.borderColor =  UIColor.hexColor(0x494C5A).cgColor
        btn.layer.borderWidth = 1.0
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.regular(14)
        btn.setTitleColor(.white, for: .normal)
        
        if let normalColor = UIColor.hexColor(0x3D404F),
            let normalImg = UIImage.image(color:normalColor) {
            btn.setBackgroundImage(normalImg, for: .normal)
        }
        if let disabledImg = UIImage.image(color:UIColor.clear) {
            btn.setBackgroundImage(disabledImg, for: .disabled)
        }

        btn.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()

    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x979DAD)
        lab.numberOfLines = 0
        lab.font = UIFont.regular(12)
        lab.textAlignment = .center
        addSubview(lab)
        return lab
    }()

}

extension MDBaseAccountBottomView {

    @objc
    func confirmAction(_ sender: UIButton) {
        UIApplication.shared.currentWindow?.endEditing(true)
        guard let vc = viewController() as? MDBaseAccountBottomViewProtocol else { return }
        vc.confirmAction()
    }

}
