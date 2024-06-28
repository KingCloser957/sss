//
//  MDSearchBar.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDSearchBarProtocol:NSObjectProtocol {
    func searchBarDoSearch(with bar:MDSearchBar)
    func searchBarDoReload(with bar:MDSearchBar)
    func searchBarDoBack(with bar:MDSearchBar)
    func searchBarDoChooseEngnine(with bar:MDSearchBar)
}

class MDSearchBar: UIView {
    
    weak var delegate:MDSearchBarProtocol?
    
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
        containerView.addSubview(backButton)
        containerView.addSubview(searchButton)
        
        textFiled.leftViewMode = .always
        textFiled.leftView = self.searchView
        textFiled.rightViewMode = .never
        textFiled.rightView = self.reloadView
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5.5)
            make.bottom.equalToSuperview().offset(-5.5)
            make.left.equalToSuperview().offset(47)
            make.right.equalToSuperview().offset(-55)
        }
        
        textFiled.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 16))
            make.right.equalToSuperview().offset(-13)
        }
    }
    lazy var containerView: UIView = {
        let cView = UIView.init(frame: .zero)
        cView.isUserInteractionEnabled = true
        cView.backgroundColor = kThemeColor
        return cView
    }()
    
    lazy var contentView: UIView = {
        let cView = UIView.init(frame: .zero)
        cView.isUserInteractionEnabled = true
        cView.backgroundColor = UIColor.hexColor(0xDEDEDE)
        cView.layer.borderWidth = 1
        cView.layer.borderColor = UIColor.clear.cgColor
        cView.layer.masksToBounds = true
        cView.layer.cornerRadius = 17
        return cView
    }()
    
    lazy var textFiled: UITextField = {
        let text = UITextField(frame: .zero)
        text.placeholderColor = UIColor.hexColor(hexColor: 0x8C8C8C, alpha: 1.0)
        text.placeholder = "BROWER_HOME_PLACEHOLDER".localizable()
        text.borderStyle = .none
        text.keyboardType = .default
        text.textColor = UIColor.hexColor(0x1E1E1E)
        text.font = UIFont.regular(12)
        text.textAlignment = .left
        text.returnKeyType = .search
        text.backgroundColor = UIColor.hexColor(0xDEDEDE)
        text.clearButtonMode = .whileEditing
        text.autocorrectionType = .no
        return text
    }()
    
    lazy var searchView: UIView = {
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        contentView.backgroundColor = .clear
        
        let button = UIButton(type: .custom)
        button.size = CGSize(width: 15, height: 15)
        button.setImage(UIImage(named: MDSearchEngine.searchEngine.details?.searchIcon ?? "baidu"), for: .normal)
        button.addTarget(self, action: #selector(chooseEngnineAction(_:)), for: .touchUpInside)
        contentView.addSubview(button)
        button.center = contentView.center
        return contentView
    }()
    
    lazy var reloadView: UIView = {
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        contentView.backgroundColor = .clear
        
        let button = UIButton(type: .custom)
        button.size = CGSize(width: 15, height: 15)
        button.setImage(UIImage(named: "search_refresh_icon"), for: .normal)
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        contentView.addSubview(button)
        button.center = contentView.center
        return contentView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "safira_nack"), for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("BROWER_SEARCH_TOP_PLACEHOLDER".localizable(), for: .normal)
        button.titleLabel?.font = UIFont.regular(14)
        button.setTitleColor(UIColor.hexColor(hexColor: 0x000000, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return button
    }()
}

extension MDSearchBar {
    
    @objc func searchAction() {
        guard let delegate = delegate else { return }
        delegate.searchBarDoSearch(with: self)
    }
    
    @objc func backAction() {
        guard let delegate = delegate else { return }
        delegate.searchBarDoBack(with: self)
    }
    
    @objc func chooseEngnineAction(_ sender:UIButton) {
        guard let delegate = delegate else { return }
        delegate.searchBarDoChooseEngnine(with: self)
    }
    
    @objc private func reload() {
        guard let delegate = delegate else { return }
        delegate.searchBarDoReload(with: self)
    }
}

class MDSearchEngineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        //        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    func setupUI() {
    //        engineButton.snp.makeConstraints { make in
    //            make.left.top.bottom.equalToSuperview()
    //            make.width.equalTo(21)
    //        }
    //
    //        rightIndicatorView.snp.makeConstraints { make in
    //            make.top.bottom.right.equalToSuperview()
    //            make.left.equalTo(engineButton.snp.right)
    //        }
    //    }
    
    lazy var engineButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRectMake(0, 0, 21, 21)
        button.setImage(UIImage(named: "google"), for: .normal)
        addSubview(button)
        return button
    }()
    
    lazy var rightIndicatorView: UIImageView = {
        let tools = UIImageView(frame: CGRectMake(23, 21, 9, 9))
        tools.backgroundColor = UIColor.clear
        tools.image = UIImage(named: "trangoo")
        //        tools.contentMode = .scaleAspectFill
        //        tools.clipsToBounds = true
        addSubview(tools)
        return tools
    }()
}
