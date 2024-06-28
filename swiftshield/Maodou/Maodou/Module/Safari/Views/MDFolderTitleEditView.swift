//
//  MDFolderTitleEditView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import MBProgressHUD

class MDFolderTitleEditView: MDBasePopupView {
    
    
    var confirmBlock: ((String) -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualTo(375)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(titleLab.snp.bottom).offset(15)
            make.height.equalTo(34)
        }
        hLineView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(15)
            make.height.equalTo(0.5)
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(hLineView.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalTo(37)
            make.bottom.equalToSuperview()
        }
        vLineView.snp.makeConstraints { make in
            make.left.equalTo(cancelBtn.snp.right)
            make.top.equalTo(hLineView.snp.bottom)
            make.bottom.equalTo(cancelBtn)
            make.width.equalTo(0.5)
        }
        confirmBtn.snp.makeConstraints { make in
            make.left.equalTo(vLineView.snp.right)
            make.right.equalToSuperview()
            make.top.width.height.equalTo(cancelBtn)
        }
    }

    @objc
    func cancelBtnAction() {
        dismiss()
    }

    @objc
    func confirmBtnAction() {
        if textField.text?.isEmpty ?? true {
            MBProgressHUD.showToast(text: "文件夹名不能为空")
            return
        }
        dismiss()
        if let block = confirmBlock, let text = textField.text {
            block(text)
        }
    }

    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "请输入文件夹名称"
        lab.textAlignment = .center
        lab.textColor = UIColor.hexColor(0x050505)
        lab.font = UIFont.medium(14)
        contentView.addSubview(lab)
        return lab
    }()

    lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "文件夹名称"
        field.font = UIFont.regular(14)
        field.layer.borderColor = UIColor.hexColor(0xA4A4A4).cgColor
        field.layer.borderWidth = 1
        contentView.addSubview(field)
        return field
    }()

    lazy var hLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0x9C9C9C)
        contentView.addSubview(view)
        return view
    }()

    lazy var vLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0x9C9C9C)
        contentView.addSubview(view)
        return view
    }()

    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.regular(14)
        btn.setTitleColor(UIColor.hexColor(0x000DFF), for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.regular(14)
        btn.setTitleColor(UIColor.hexColor(0x000DFF), for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()

}
