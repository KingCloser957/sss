//
//  MDHomeSearchBar.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDHomeSearchBarDelegate {
    func scan()
    func selectEngnine()
}

class MDHomeSearchBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(containerView)
        containerView.addSubview(contentView)
        contentView.addSubview(textFiled)
        
        textFiled.leftViewMode = .always
        textFiled.leftView = self.searchView
        textFiled.rightViewMode = .always
        textFiled.rightView = self.reloadView
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(19)
            make.right.equalToSuperview().offset(-19)
        }
        
        textFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }
    lazy var containerView: UIView = {
        let cView = UIView.init(frame: .zero)
        cView.isUserInteractionEnabled = true
        cView.backgroundColor = UIColor.hexColor(0xF5F5F5)
        return cView
    }()
    
    lazy var contentView: UIView = {
        let cView = UIView.init(frame: .zero)
        cView.isUserInteractionEnabled = true
        cView.backgroundColor = UIColor.hexColor(0xDEDEDE)
        cView.layer.borderWidth = 1
        cView.layer.borderColor = UIColor.hexColor(hexColor: 0x000000, alpha: 1.0).cgColor
        cView.layer.masksToBounds = true
        cView.layer.cornerRadius = 25.5
        return cView
    }()
    
    lazy var textFiled: UITextField = {
        let text = UITextField(frame: .zero)
        text.placeholderColor = UIColor.hexColor(hexColor: 0x8C8C8C, alpha: 1.0)
        text.placeholder = "BROWER_HOME_PLACEHOLDER".localizable()
        text.borderStyle = .none
        text.keyboardType = .default
        text.textColor = UIColor.hexColor(0x878787)
        text.font = UIFont.regular(16)
        text.textAlignment = .left
        text.returnKeyType = .search
        text.backgroundColor = UIColor.clear
        text.clearButtonMode = .whileEditing
        text.isUserInteractionEnabled = true
        return text
    }()
    
    lazy var searchView: UIView = {
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        contentView.backgroundColor = .clear
        let view = HHHomeSearchEngineView.init()
        view.size = CGSize.init(width: 32, height: 32)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectEngnine(_:))))
        contentView.addSubview(view)
        view.center = contentView.center
        return contentView
    }()
    
    lazy var reloadView: UIView = {
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        contentView.backgroundColor = .clear
        
        let button = UIButton(type: .custom)
        button.size = CGSize(width: 20, height: 20)
        button.setImage(UIImage(named: "refresh3"), for: .normal)
        button.addTarget(self, action: #selector(scanAction), for: .touchUpInside)
        contentView.addSubview(button)
        button.center = contentView.center
        return contentView
    }()
}

extension MDHomeSearchBar {
    
    @objc private func selectEngnine(_ tap:UITapGestureRecognizer) {
        if let vc = viewController() as? MDHomeSearchBarDelegate {
            vc.selectEngnine()
        }
    }
    
    @objc private func scanAction() {
        if let vc = viewController() as? MDHomeSearchBarDelegate {
            vc.scan()
        }
    }
}

class HHHomeSearchEngineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        addSubview(engineButton)
        addSubview(rightIndicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var engineButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRectMake(3, 5, 21, 21)
        button.setImage(UIImage(named: MDSearchEngine.searchEngine.details?.searchIcon ?? "baidu"), for: .normal)
        return button
    }()
    
    lazy var rightIndicatorView: UIImageView = {
        let tools = UIImageView(frame: CGRectMake(21, 15.5, 9, 9))
        tools.backgroundColor = UIColor.clear
        tools.image = UIImage(named: "trangoo")
        tools.contentMode = .scaleAspectFill
        tools.clipsToBounds = true
        return tools
    }()
    
    
}
