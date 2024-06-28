//
//  OOAlertView.swift
//  Orchid
//
//  Created by 李白 on 2022/8/13.
//

import UIKit

class MDAlertView: MDBasePopupView {

    var cancelBlock: (() -> Void)?
    var confirmBlock: (() -> Void)?
    @objc
    private func cancelAction() {
        if cancelBlock != nil {
            cancelBlock!()
        }
        dismiss()
    }

    @objc
    private func confirmAction() {
        if confirmBlock != nil {
            confirmBlock!()
        }
        dismiss()
    }
    
    var tips:String = "" {
        didSet {
            if tips.isEmpty == false {
                let attributedString = NSMutableAttributedString(string: tips)
                
            }
        }
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(314)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        tipLab.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(34)
            make.right.equalToSuperview().offset(-34)
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(tipLab.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(23)
            make.bottom.equalToSuperview().offset(-21)
            make.height.equalTo(48)
        }
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(cancelBtn)
            make.right.equalToSuperview().offset(-23)
            make.left.equalTo(cancelBtn.snp.right).offset(9)
            make.bottom.equalTo(cancelBtn)
            make.width.equalTo(cancelBtn)
        }
    }

    lazy var controll: UIControl = {
        let control = UIControl(frame: CGRect())
        control.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        control.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        addSubview(control)
        return control
    }()

    lazy var titleLab: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.regular(14)
        view.textAlignment = .center
        contentView.addSubview(view)
        return view
    }()

    lazy var tipLab: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.regular(12)
        view.numberOfLines = 0
        view.textAlignment = .center
        contentView.addSubview(view)
        return view
    }()

    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .selected)
        btn.setTitle("取消", for: .normal)
        btn.setBackgroundImage(UIImage.imageFromeGradient(gradientColors: [UIColor.hexColor(0x343958),UIColor.hexColor(0x363051)]), for: .normal)
        btn.layer.cornerRadius = 24
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.regular(14)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确定", for: .selected)
        btn.setTitle("确定", for: .normal)
        btn.setBackgroundImage(UIImage.imageFromeGradient(gradientColors: [UIColor.hexColor(0x060CE8),UIColor.hexColor(0xCE08FE)]), for: .normal)
        btn.layer.cornerRadius = 24
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.regular(14)
        btn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()
}
