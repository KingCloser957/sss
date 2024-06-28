//
//  MDNodeTimerView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDHomeNodeBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupViews() {
        addSubview(connerView)
        connerView.addSubview(titleLabel)
        connerView.addSubview(statusLabel)
        connerView.addSubview(selectBtn)
        connerView.addSubview(iconImageView)
    }
    
    public func setupConstrains() {
        connerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(20)
        }
        
        selectBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 13.25, height: 13.25))
            make.right.equalToSuperview().offset(-11.5)
            make.top.equalToSuperview().offset(19)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.3)
            make.bottom.equalToSuperview().offset(-16.4)
            make.size.equalTo(CGSize.init(width: 24.2, height: 32.3)).priority(500)
        }
    }
    
    lazy var connerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = .clear
        cView.layer.cornerRadius = 25
        cView.layer.masksToBounds = true
        cView.isUserInteractionEnabled = true
        return cView
    }()
    
    lazy var titleLabel: UILabel = {
        let cView = UILabel.init()
        cView.text = "HOME_PROXY_SPPED_TIME".localizable()
        cView.textColor = UIColor.hexColor(0xFFFFFF)
        cView.font = UIFont.light(10)
        cView.textAlignment = .left
        return cView
    }()
    
    lazy var statusLabel: UILabel = {
        let cView = UILabel.init()
        cView.text = "HOME_PROXY_NOT_START".localizable()
        cView.textColor = UIColor.hexColor(0xFFFFFF)
        cView.font = UIFont.medium(16)
        cView.textAlignment = .left
        return cView
    }()
    
    lazy var selectBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 26.0, height: 22.8)
        button.setImage(UIImage.init(named: "switch"), for: .normal)
        button.setImage(UIImage.init(named: "switch"), for: .selected)
        return button
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shanchu")
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class MDHomeNodeTimerView: MDHomeNodeBaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.setupViews()
        super.setupConstrains()
        self.selectBtn.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MDHomeNodeTimerView {
    
    func refreshUI(with node:MKNodeTempeleModel) {
        var viewColorInt:Int?
        switch node.modeType {
        case .global:
            viewColorInt = 0xF58735
        case .video:
            viewColorInt = 0x8888FF
        case .game:
            viewColorInt = 0x01A4D2
        case .none:
            debugPrint("nothing to do")
        }
        self.connerView.backgroundColor = UIColor.hexColor(viewColorInt!)
    }
    
    func refreshTimer(with state:OOProxyState) {
        var timeCount:Int = 0
        var timeCountString = ""
        MDTimerManager.default.setTimeInterval(interval: 1, isRepeat: true) {
            timeCount += 1
            switch state {
            case .connect:
                timeCountString = TimeInterval(timeCount).hourMinuteSecond
            case .disconnect:
                timeCountString =  "HOME_PROXY_NOT_START".localizable()
            }
            self.statusLabel.text = timeCountString
        }
    }
}


class MDHomeNodeRegionView: MDHomeNodeBaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        self.selectBtn.isHidden = false
//        self.connerView.addSubview(adressLabel)
    }
    
    override func setupConstrains() {
        super.setupConstrains()
        
//        adressLabel.snp.makeConstraints { make in
//            make.left.equalTo(self.statusLabel)
//            make.top.equalTo(self.statusLabel.snp_bottom).offset(10)
//        }
    }
}

extension MDHomeNodeRegionView {
    func refreshUI(with mode:VPNModeType,regionPlace:String?) {
        self.titleLabel.text = "HOME_PROXY_CURRENT_LINE".localizable()
        self.statusLabel.text = regionPlace ?? "HOME_PROXY_GOTO_CONNECT".localizable()
//        self.adressLabel.text = node.adress
        var viewColorInt:Int!
        switch mode {
        case .global:
            viewColorInt = 0xF58735
        case .video:
            viewColorInt = 0x8888FF
        case .game:
            viewColorInt = 0x01A4D2
        }
        self.connerView.backgroundColor = UIColor.hexColor(viewColorInt)
    }
}


class MDHomeNodeModeView: MDHomeNodeBaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        self.selectBtn.isHidden = false
    }
    
    override func setupConstrains() {
        super.setupConstrains()
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 36, height: 36)).priority(1000)
        }
    }
}

extension MDHomeNodeModeView {
    func refreshUI(with mode:VPNModeType) {
        self.titleLabel.text = "HOME_PROXY_CURRENT_MODE".localizable()
        var viewColorInt:Int?
        switch mode {
        case .global:
            self.iconImageView.image = UIImage.init(named: "ico_all")
            self.statusLabel.text = "HOME_PROXY_MODE_GLOBAL".localizable()
            viewColorInt = 0xF58735
        case .video:
            self.iconImageView.image = UIImage.init(named: "ico_yy")
            self.statusLabel.text = "HOME_PROXY_MODE_VIDEO".localizable()
            viewColorInt = 0x8888FF
        case .game:
            self.iconImageView.image = UIImage.init(named: "ico_game")
            self.statusLabel.text = "HOME_PROXY_MODE_GAME".localizable()
            viewColorInt = 0x01A4D2
        }
        self.connerView.backgroundColor = UIColor.hexColor(viewColorInt!)
    }
}


class MDNodeConfigView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(nodeTimerView)
        addSubview(nodeRegionView)
        addSubview(nodeModeView)
    }
    
    func setupConstrains() {
        nodeTimerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(MDLayout.layout(36))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: MDLayout.layout(98), height: MDLayout.layout(139)))
        }
        nodeRegionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: MDLayout.layout(98), height: MDLayout.layout(139)))
        }
        nodeModeView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(MDLayout.layout(-36))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: MDLayout.layout(98), height: MDLayout.layout(139)))
        }
    }
    
    lazy var nodeTimerView: MDHomeNodeTimerView = {
        let view = MDHomeNodeTimerView.init(frame: .zero)
        return view
    }()
    
    lazy var nodeRegionView: MDHomeNodeRegionView = {
        let view = MDHomeNodeRegionView.init(frame: .zero)
        return view
    }()
    
    lazy var nodeModeView: MDHomeNodeModeView = {
        let view = MDHomeNodeModeView.init(frame: .zero)
        return view
    }()
}

extension MDNodeConfigView {
    func proxyConnectState() -> OOProxyState {
        let userDefaults = UserDefaults(suiteName: kGroupId)
        let state = userDefaults?.bool(forKey: "kProxyConnectionState") ?? false
        return state ? .connect : .disconnect
    }
    
    func refreshUI(with node:MKNodeTempeleModel) {
        nodeTimerView.refreshTimer(with: proxyConnectState())
        nodeTimerView.refreshUI(with: node)
        nodeRegionView.refreshUI(with: node.modeType ?? .global,regionPlace: node.title)
        nodeModeView.refreshUI(with: node.modeType ?? .global)
    }
}


