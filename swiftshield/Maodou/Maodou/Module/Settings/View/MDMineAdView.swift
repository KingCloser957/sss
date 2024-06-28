//
//  MDMineAdView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDMineAdView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15,
                                                             left: 0,
                                                             bottom: 15,
                                                             right: 0))
        }
        
        layoutIfNeeded()
        setNeedsLayout()
        caLayer.bounds = adImgView.bounds
        caLayer.position = adImgView.center
        adImgView.layer.addSublayer(caLayer)
        
        adImgView.addSubview(_3dLabel)
        _3dLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    lazy var adImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.clipsToBounds = true
        addSubview(imgView)
        return imgView
    }()
    
    lazy var caLayer: CAGradientLayer = {
        let layer1 = CAGradientLayer()
        layer1.colors = [UIColor(red: 0.686, green: 0.431, blue: 1, alpha: 1).cgColor, UIColor(red: 0.859, green: 0.557, blue: 0.98, alpha: 1).cgColor, UIColor(red: 0.867, green: 0.561, blue: 0.98, alpha: 1).cgColor]
        layer1.locations = [0, 0.61, 1]
        layer1.startPoint = CGPoint(x: 0.5, y: 0)
        layer1.endPoint = CGPoint(x: 0.5, y: 0.73)
        return layer1
    }()
    
    lazy var _3dLabel: CBJ3DLabel = {
        let view = CBJ3DLabel(frame: CGRectMake(0, 20, kScreenW - 40, 120))
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20)
        view.text = "Enjoy life better  Internet surfing easier"
        view.textColor = UIColor.hexColor(0x6064EF)
        return view
    }()
}
