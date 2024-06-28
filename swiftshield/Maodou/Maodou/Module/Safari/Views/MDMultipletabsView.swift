//
//  MDMultipletabsView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MultipletabsDelegate {
    func tapBookmarks()
    func tapFile()
    func tapBilibili()
    func tapGoogle()
    func tapYoutube()
}

class MDMultipletabsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fixDistributes = [bookMarksView,fileView,bilibiliView,googleView,youtubeView]
        fixDistributes.snp.distributeViewsAlong(axisType: .horizontal,fixedItemLength: 52,leadSpacing: 36,tailSpacing: 36)
        fixDistributes.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.top.equalToSuperview().offset(30)
        }
    }
    
    lazy var bookMarksView: MDHomeMultipleView = {
        let view = MDHomeMultipleView.init(frame: .zero)
        view.button.layer.cornerRadius = 25
        view.button.layer.borderWidth = 1
        view.button.layer.masksToBounds = true
        view.button.layer.borderColor = UIColor.hexColor(hexColor: 0xF5F5F5, alpha: 0.8).cgColor
        view.backgroundColor = UIColor.clear
        view.button.setImage(UIImage(named: "twitter"), for: .normal)
        view.button.addTarget(self, action: #selector(tapBookmarksAction), for: .touchUpInside)
        view.nameLabel.text = "Twitter"
        addSubview(view)
        return view
    }()
    
    lazy var bilibiliView: MDHomeMultipleView = {
        let view = MDHomeMultipleView.init(frame: .zero)
        view.button.layer.cornerRadius = 25
        view.button.layer.borderWidth = 1
        view.button.layer.masksToBounds = true
        view.button.layer.borderColor = UIColor.hexColor(hexColor: 0xF5F5F5, alpha: 0.8).cgColor
        view.backgroundColor = UIColor.clear
        view.button.setImage(UIImage(named: "reddit"), for: .normal)
        view.button.addTarget(self, action: #selector(tapBilibiliAction), for: .touchUpInside)
        view.nameLabel.text = "Reddit"
        addSubview(view)
        return view
    }()
    
    lazy var fileView: MDHomeMultipleView = {
        let view = MDHomeMultipleView.init(frame: .zero)
        view.button.layer.cornerRadius = 25
        view.button.layer.borderWidth = 1
        view.button.layer.masksToBounds = true
        view.button.layer.borderColor = UIColor.hexColor(hexColor: 0xF5F5F5, alpha: 0.8).cgColor
        view.backgroundColor = UIColor.clear
        view.button.setImage(UIImage(named: "linkedin"), for: .normal)
        view.button.addTarget(self, action: #selector(tapFileAction), for: .touchUpInside)
        view.nameLabel.text = "Linkedin"
        addSubview(view)
        return view
    }()
    
    lazy var googleView: MDHomeMultipleView  = {
        let view = MDHomeMultipleView.init(frame: .zero)
        view.button.layer.cornerRadius = 25
        view.button.layer.borderWidth = 1
        view.button.layer.masksToBounds = true
        view.button.layer.borderColor = UIColor.hexColor(hexColor: 0xF5F5F5, alpha: 0.8).cgColor
        view.backgroundColor = UIColor.clear
        view.button.setImage(UIImage(named: "yahu"), for: .normal)
        view.button.addTarget(self, action: #selector(tapGoogleAction), for: .touchUpInside)
        view.nameLabel.text = "Yahoo"
        addSubview(view)
        return view
    }()
    
    lazy var youtubeView: MDHomeMultipleView  = {
        let view = MDHomeMultipleView.init(frame: .zero)
        view.button.layer.cornerRadius = 25
        view.button.layer.borderWidth = 1
        view.button.layer.masksToBounds = true
        view.button.layer.borderColor = UIColor.hexColor(hexColor: 0xF5F5F5, alpha: 0.8).cgColor
        view.backgroundColor = UIColor.clear
        view.button.setImage(UIImage(named: "Youtube"), for: .normal)
        view.button.addTarget(self, action: #selector(tapYoutubeAction), for: .touchUpInside)
        view.nameLabel.text = "Youtube"
        addSubview(view)
        return view
    }()
}

extension MDMultipletabsView {
    @objc private func tapBookmarksAction() {
        if let vc = viewController() as? MultipletabsDelegate {
            vc.tapBookmarks()
        }
    }
    
    @objc private func tapFileAction() {
        if let vc = viewController() as? MultipletabsDelegate {
            vc.tapFile()
        }
    }
    
    @objc private func tapBilibiliAction() {
        if let vc = viewController() as? MultipletabsDelegate {
            vc.tapBilibili()
        }
    }
    
    @objc private func tapGoogleAction() {
        if let vc = viewController() as? MultipletabsDelegate {
            vc.tapGoogle()
        }
    }
    
    @objc private func tapYoutubeAction() {
        if let vc = viewController() as? MultipletabsDelegate {
            vc.tapYoutube()
        }
    }
}

class MultipletabsButton: UIButton {
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRectMake(0, 0, contentRect.width, contentRect.width)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRectMake(0, contentRect.width + 15, contentRect.width, contentRect.height - 15 - contentRect.width)
    }
}


class MDHomeMultipleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    lazy var button: UIButton = {
        let btn = MultipletabsButton.init(type: .custom)
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named: "Youtube"), for: .normal)
        addSubview(btn)
        return btn
    }()
    
    lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x1E1E1E)
        lab.font = UIFont.regular(12)
        lab.textAlignment = .center
        addSubview(lab)
        return lab
    }()
}
