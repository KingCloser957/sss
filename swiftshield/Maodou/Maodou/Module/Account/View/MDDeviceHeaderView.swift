//
//  MDDeviceHeaderView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDDeviceHeaderView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arrangView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 17,
                                                             left: 33,
                                                             bottom: 50,
                                                             right: 33))
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalTo(arrangView.snp.bottom).offset(33)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(35)
        }
    }

    func refreshUI(_ list: [String]?) {
        iphoneBtn.isSelected = list?.contains("ios") ?? false
        macBtn.isSelected = list?.contains("mac") ?? false
        androidBtn.isSelected = list?.contains("android") ?? false
        pcBtn.isSelected = list?.contains("pc") ?? false
    }

    lazy var arrangView: UIStackView = {
        let view = UIStackView()
        view.addArrangedSubview(iphoneBtn)
        view.addArrangedSubview(androidBtn)
        view.addArrangedSubview(pcBtn)
        view.addArrangedSubview(macBtn)
        view.spacing = 10
        view.axis = .horizontal
        view.distribution = .fillEqually
        addSubview(view)
        return view
    }()

    lazy var iphoneBtn: MDDeviceButton = {
        let btn = MDDeviceButton(type: .custom)
        btn.setImage(UIImage(named: "icon_phone"), for: .normal)
        btn.setImage(UIImage(named: "icon_phone_light"), for: .selected)
        btn.backgroundColor = UIColor.clear
        btn.layer.cornerRadius = 15
        btn.isUserInteractionEnabled = false
        return btn
    }()

    lazy var androidBtn: MDDeviceButton = {
        let btn = MDDeviceButton(type: .custom)
        btn.setImage(UIImage(named: "icon_android"), for: .normal)
        btn.setImage(UIImage(named: "icon_android_light"), for: .selected)
        btn.backgroundColor = UIColor.clear
        btn.layer.cornerRadius = 15
        btn.isUserInteractionEnabled = false
        return btn
    }()

    lazy var pcBtn: MDDeviceButton = {
        let btn = MDDeviceButton(type: .custom)
        btn.setImage(UIImage(named: "icon_pc"), for: .normal)
        btn.setImage(UIImage(named: "icon_pc_light"), for: .selected)
        btn.backgroundColor = UIColor.clear
        btn.layer.cornerRadius = 15
        btn.isUserInteractionEnabled = false
        return btn
    }()

    lazy var macBtn: MDDeviceButton = {
        let btn = MDDeviceButton(type: .custom)
        btn.setImage(UIImage(named: "icon_mac"), for: .normal)
        btn.setImage(UIImage(named: "icon_mac_light"), for: .selected)
        btn.backgroundColor = UIColor.clear
        btn.layer.cornerRadius = 15
        btn.isUserInteractionEnabled = false
        return btn
    }()

    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "DEVICE_MANAGEMENT_ASSOCIATED_DEVICE".localizable()
        lab.textColor = UIColor.white
        lab.font = UIFont.light(12)
        addSubview(lab)
        return lab
    }()

}

class MDDeviceButton: UIButton {

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 1
                layer.borderColor = UIColor.white.cgColor
            } else {
                layer.borderWidth = 0.5
                layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
            }
        }
    }

}
