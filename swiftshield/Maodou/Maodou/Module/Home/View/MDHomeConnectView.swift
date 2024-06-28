//
//  MDHomeConnectView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/28.
//

import UIKit

class MDHomeConnectView: UIView {
    var statusType:VPNStatus = .pausing

    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI(_:)), name: NSNotification.Name.init(rawValue: "VPNLoadingStatusNotification"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,status :VPNStatus,mode:VPNModeType) {
        super.init(frame: frame)
        statusType = status
    }
    
    lazy var upgradeBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.hexColor(hexColor: 0x101010, alpha: 1.0)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.regular(12)
        button.layer.cornerRadius = 22.5
        button.layer.shadowColor = UIColor.hexColor(hexColor: 0x000000, alpha: 1).cgColor
        button.layer.shadowOpacity = 0.47
        button.layer.shadowOffset = CGSize.init(width: 0, height: 4)
        button.layer.shadowRadius = 12
        button.setTitle("HOME_PROXY_START_SPEED_UP".localizable(), for: .normal)
        button.isExclusiveTouch = true
        button.setTitleColor(UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 1.0), for: .normal)
        addSubview(button)
        return button
    }()
    
    lazy var indicatorView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.hexColor(hexColor: 0x4D4D4D, alpha: 1.0)
        cView.layer.masksToBounds = true
        cView.layer.cornerRadius = 2
        upgradeBtn.addSubview(cView)
        return cView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        upgradeBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-2)
            make.size.equalTo(CGSize.init(width: 39, height: 4))
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let pointIndicatorView = self.convert(point, toViewOrWindow: indicatorView)
//        if indicatorView.point(inside: pointIndicatorView, with: event) {
//            return upgradeBtn
//        }
        return super.hitTest(point, with: event)
    }
}

extension MDHomeConnectView {
    
    @objc private func refreshUI(_ ntf:NSNotification) {
        let obj = ntf.object
        var isConnected:Bool = false
        if let result = obj as? [String:Any],let mode = result["VPNMode"] as? VPNModeType,let status = result["VPNStatus"] as? VPNStatus {
            switch mode {
            case .global:
                switch status {
                case .pausing:
                    isConnected = false
                    indicatorView.backgroundColor = UIColor.hexColor(0x4D4D4D)
                    upgradeBtn.setTitle("HOME_PROXY_START_SPEED_UP".localizable(), for: .normal)
                case .loading:
                    upgradeBtn.setTitle("HOME_PROXY_START_SPEEDING".localizable(), for: .normal)
                    indicatorView.backgroundColor = UIColor.hexColor(0x8384F7)
                case .running:
                    isConnected = true
                    upgradeBtn.setTitle("HOME_PROXY_START_STOPPING".localizable(), for: .normal)
                    indicatorView.backgroundColor = UIColor.hexColor(0x8384F7)
                }
            case .video:
                switch status {
                case .pausing:
                    isConnected = false
                    upgradeBtn.setTitle("HOME_PROXY_START_SPEED_UP".localizable(), for: .normal)
                    indicatorView.backgroundColor = UIColor.hexColor(0x4D4D4D)
                case .loading:
                    upgradeBtn.setTitle("HOME_PROXY_START_SPEEDING".localizable(), for: .normal)
                    indicatorView.backgroundColor = UIColor.hexColor(0x00FFFF)
                case .running:
                    isConnected = true
                    upgradeBtn.setTitle("HOME_PROXY_START_STOPPING".localizable(), for: .normal)
                    indicatorView.backgroundColor = UIColor.hexColor(0x00FFFF)
                }
            case .game:
                switch status {
                case .pausing:
                    isConnected = false
                    upgradeBtn.setTitle("HOME_PROXY_START_SPEED_UP".localizable(), for: .normal)
                    indicatorView.backgroundColor = UIColor.hexColor(0x4D4D4D)
                case .loading:
                    upgradeBtn.setTitle("HOME_PROXY_START_SPEEDING".localizable(), for: .normal)
                    indicatorView.backgroundColor = UIColor.hexColor(0xFCCB58)
                case .running:
                    isConnected = true
                    upgradeBtn.setTitle("HOME_PROXY_START_STOPPING".localizable(), for: .normal)
                    indicatorView.backgroundColor = UIColor.hexColor(0xFCCB58)
                }
            }
            upgradeBtn.isSelected = isConnected
        }
    }
}
