//
//  MDBookmarkModifyViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import MBProgressHUD

class MDBookmarkModifyViewController: MDBaseViewController {
    var model: MDBookmarkModel
    init(model: MDBookmarkModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    func setupUI() {
        title = "编辑书签"
        view.backgroundColor = UIColor.hexColor(0xF5F5F5)
        titleTextFiled.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.left.equalToSuperview().offset(19)
            make.right.equalToSuperview().offset(-19)
            make.height.equalTo(54)
        }
        if !model.isFolder {
            urlTextFiled.snp.makeConstraints { make in
                make.top.equalTo(titleTextFiled.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(19)
                make.right.equalToSuperview().offset(-19)
                make.height.equalTo(54)
            }
        }

        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitleColor(UIColor.hexColor(0x000000), for: .normal)
        rightBtn.size = CGSize(width: 44, height: 44)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.addTarget(self, action: #selector(saveModifyAction), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        navigationItem.rightBarButtonItem = rightItem
    }

    func setupData() {
        titleTextFiled.text = model.title
        if !model.isFolder {
            urlTextFiled.text = model.url
        }
    }

    @objc
    func saveModifyAction() {

        if model.isFolder {
            if titleTextFiled.text?.isEmpty ?? true {
                MBProgressHUD.showToast(text: "文件夹名称不能为空")
                return
            }
        } else {
            if titleTextFiled.text?.isEmpty ?? true {
                MBProgressHUD.showToast(text: "标题不能为空")
                return
            }
            if urlTextFiled.text?.isEmpty ?? true {
                MBProgressHUD.showToast(text: "链接不能为空")
                return
            }
        }
        let table = MDBookmarkTable()
        model.title = titleTextFiled.text
        if !model.isFolder {
            model.url = urlTextFiled.text
        }
        table.update(model)
        navigationController?.popViewController(animated: true)
    }

    lazy var titleTextFiled: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 54))
        textField.rightViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 19
        textField.textColor = UIColor.hexColor(0x1E1E1E)
        textField.becomeFirstResponder()
        view.addSubview(textField)
        return textField
    }()

    lazy var urlTextFiled: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 54))
        textField.rightViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 19
        textField.textColor = UIColor.hexColor(0x1E1E1E)
        view.addSubview(textField)
        return textField
    }()


}
