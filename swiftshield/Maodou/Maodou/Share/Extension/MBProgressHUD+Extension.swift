//
//  MBProgressHUD+Extension.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/16.
//

import Foundation
import MBProgressHUD
import UIKit

extension MBProgressHUD {
    
    static func hide( _ view: UIView? = nil, animated: Bool) {
        if view == nil {
            guard let appDelegate = UIApplication.shared.sceneDelegate, let window = appDelegate.window else {
                return
            }
            MBProgressHUD.hide(for: window, animated: animated)
        } else {
            MBProgressHUD.hide(for: view!, animated: animated)
        }
    }

    static func showLoading(_ view: UIView? = UIApplication.shared.windows.last!) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.bezelView.style = .solidColor
        hud.mode = .customView

        let contentView = UIView()
        contentView.backgroundColor = kThemeColor
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.hexColor(0x2D3343).cgColor

        let iconImgView = UIImageView()
        iconImgView.clipsToBounds = true
        iconImgView.image = UIImage(named: "loading")
        contentView.addSubview(iconImgView)

        let animal = CABasicAnimation(keyPath: "transform.rotation.z")
        animal.fromValue = 0
        animal.toValue = CGFloat.pi * 2
        animal.duration = 0.8
        animal.autoreverses = false
        animal.repeatCount = MAXFLOAT
        animal.fillMode = .forwards
        iconImgView.layer.add(animal, forKey: nil)

        let tipLab = UILabel()
        tipLab.textColor = .white
        tipLab.font = UIFont(name: "PingFangSC-Regular", size: 12)
        tipLab.numberOfLines = 0
        tipLab.text = "LOADING_TIPS".localizable()
        tipLab.textAlignment = .left
        contentView.addSubview(tipLab)

        hud.bezelView.isHidden = true
        hud.backgroundView.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.width.height.equalTo(76)
            make.center.equalToSuperview()
        }

        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(16)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }

        tipLab.snp.makeConstraints { make in
            make.top.equalTo(iconImgView.snp_bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        return hud
    }

    static func showToast(_ view: UIView? = UIApplication.shared.windows.last!, text: String?) {
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.bezelView.style = .solidColor
        hud.mode = .customView

        let contentView = UIView()
        contentView.backgroundColor = UIColor.hexColor(0x10111B)
        contentView.layer.cornerRadius = 16

        let tipLab = UILabel()
        tipLab.textColor = UIColor.hexColor(0xB5B9DC)
        tipLab.font = UIFont(name: "PingFangSC-Regular", size: 12)
        tipLab.numberOfLines = 0
        tipLab.text = text
        tipLab.textAlignment = .center
        contentView.addSubview(tipLab)

        hud.bezelView.isHidden = true
        hud.backgroundView.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(32)
            make.width.lessThanOrEqualTo(270)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-130)
        }

        tipLab.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }

        hud.hide(animated: true, afterDelay: 1.5)
    }

}
