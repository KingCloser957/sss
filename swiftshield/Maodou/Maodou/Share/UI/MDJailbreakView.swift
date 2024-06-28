//
//  FVJailbreakView.swift
//  FalcoVPN
//
//  Created by huangrui on 2024/3/7.
//

import UIKit
import AttributedString

class MDJailbreakView: MDBasePopupView {
    
    var cancelBlock: (() -> Void)?
    var confirmBlock: (() -> Void)?
    var message:String? = nil {
        didSet {
            tipLab.attributed.text = """
                              \(message ?? "   发生未知错误，请重新下载安装最新版本客户端，官方下载地址 ", .foreground(UIColor.hexColor(0xFFFFFF)))\(mobileDownloadUrl, .foreground(UIColor.hexColor(0x5F99FF)), .link(mobileDownloadUrl),.action {
                                     guard let url = URL.init(string: mobileDownloadUrl) else {
                                         return
                                     }
                                     if !UIApplication.shared.canOpenURL(url) {
                                         return
                                     }
                                     if #available(iOS 10.0, *) {
                                         UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                     } else {
                                         UIApplication.shared.openURL(url)
                                     }
                              })
                              """
        }
    }
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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(320)
        }
        errorImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(42)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 54))
        }
        tipLab.snp.makeConstraints { make in
            make.top.equalTo(errorImgView.snp.bottom).offset(29)
            make.left.equalToSuperview().offset(23)
            make.right.equalToSuperview().offset(-23)
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(tipLab.snp.bottom).offset(35)
            make.left.equalToSuperview().offset(23)
            make.bottom.equalToSuperview().offset(-18)
            make.height.equalTo(45)
        }
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(cancelBtn)
            make.right.equalToSuperview().offset(-23)
            make.left.equalTo(cancelBtn.snp.right).offset(7)
            make.bottom.equalTo(cancelBtn)
            make.width.equalTo(cancelBtn)
        }
    }

    lazy var controll: UIControl = {
        let control = UIControl(frame: CGRect())
        control.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        control.isUserInteractionEnabled = false
        addSubview(control)
        return control
    }()

    lazy var errorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "erromsg")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        contentView.addSubview(imgView)
        return imgView
    }()

    lazy var tipLab: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = UIFont.regular(12)
        view.isUserInteractionEnabled = true
        contentView.addSubview(view)
        return view
    }()

    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .selected)
        btn.setTitle("取消", for: .normal)
        btn.backgroundColor = UIColor.hexColor(0x343549)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.regular(14)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("去下载", for: .selected)
        btn.setTitle("去下载", for: .normal)
        btn.backgroundColor = UIColor.hexColor(0x0031F4)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.regular(14)
        btn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()
}
