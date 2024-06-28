//
//  MDHomeCircleView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/26.
//

import UIKit

protocol MDHomeCircleViewDelegate:NSObjectProtocol {
    func changeNodeRegion()
    func changeNodeMode()
}

protocol MDHomeVPNConnectDelegate:NSObjectProtocol {
    // 开启代理
    func startProxy()
    
    // 关闭代理
    func stopProxy()
    
}

class MDHomeCircleView: UIView {
    
    var delegate:MDHomeCircleViewDelegate?
    var vpnDeleagte:MDHomeVPNConnectDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.isUserInteractionEnabled = true
        self.addSubview(backGroudView)
        backGroudView.addSubview(homeCircleView)
        backGroudView.addSubview(homeNodeView)
        backGroudView.addSubview(homeConnectView)
    }
    
    private func setupConstrains() {
        backGroudView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        homeCircleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(27)
            make.size.equalTo(CGSize(width: MDLayout.layout(339), height: MDLayout.layout(339)))
        }
        
        homeNodeView.snp.makeConstraints { make in
            make.top.equalTo(homeCircleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(MDLayout.layout(139))
        }
        
        homeConnectView.snp.makeConstraints { make in
            make.top.equalTo(homeNodeView.snp.bottom).offset(28)
            make.left.right.equalTo(homeCircleView)
            make.height.equalTo(45)
        }
    }
    
    lazy var backGroudView: UIImageView = {
        let contentView = UIImageView.init()
        contentView.image = UIImage.init(named: "bg_quanju")
        contentView.contentMode = .scaleAspectFill
        contentView.layer.masksToBounds = true
        contentView.isUserInteractionEnabled = true
        return contentView
    }()
    
    lazy var homeCircleView: MDHomeAnimationView = {
        let view = MDHomeAnimationView(frame: CGRect(x: 0, y: 0, width: MDLayout.layout(339), height: MDLayout.layout(339)))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var homeNodeView: MDNodeConfigView = {
        let view = MDNodeConfigView.init(frame: .zero)
        view.backgroundColor = UIColor.clear
        view.nodeRegionView.addGestureRecognizer(UITapGestureRecognizer(target: self, 
                                                                   action: #selector(selectNodeReg)))
        view.nodeModeView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(selectNodeMode)))
        return view
    }()
    
    lazy var homeConnectView: MDHomeConnectView = {
        let view = MDHomeConnectView(frame: .zero)
        view.backgroundColor = UIColor.clear
        view.upgradeBtn.addTarget(self, action: #selector(startAction(_ :)), for: .touchUpInside)
        return view
    }()
}

extension MDHomeCircleView {
    @objc private func selectNodeReg() {
        if let delegate = delegate {
            delegate.changeNodeRegion()
        }
    }
    
    @objc private func selectNodeMode() {
        if let delegate = delegate {
            delegate.changeNodeMode()
        }
    }
    
    @objc
    private func startAction(_ sender:UIButton) {
        if sender.isSelected {
            guard let deleagte = vpnDeleagte else { return }
            deleagte.stopProxy()
        } else {
            guard let deleagte = vpnDeleagte else { return }
            deleagte.startProxy()
        }
    }
    
    func refreshUI(with node:MKNodeTempeleModel) {
        homeNodeView.refreshUI(with: node)
        var bgImageName:String = "bg_quanju"
        switch node.modeType {
        case .global:
            bgImageName = "bg_quanju"
            Log.debug("全局")
        case .video:
            bgImageName = "bg_yingyong"
            Log.debug("影音")
        case .game:
            bgImageName = "bg_youxi"
            Log.debug("游戏")
        case .none:
            debugPrint("")
        }
        self.backGroudView.image = UIImage(named: bgImageName)
    }
}
