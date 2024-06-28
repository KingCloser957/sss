//
//  MKNodeDetailView.swift
//  MonkeyKing
//
//  Created by huangrui on 2024/5/23.
//

import UIKit

protocol MKNodeConnectViewDelegate:NSObjectProtocol {
    func didConnectNode(with node:MKNodeTempeleModel?)
}

class MKNodeDetailView: UIView {
    
    weak var delegate:MKNodeConnectViewDelegate?
    var node:MKNodeTempeleModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(topHeadView)
        self.addSubview(connectView)
    }
    
    private func setupConstrains() {
        
        topHeadView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(100)
        }
        
        connectView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
    }

    lazy var topHeadView: MKTopHeadView = {
        let cView = MKTopHeadView()
        cView.backgroundColor = .white
        cView.layer.cornerRadius = 8.0
        cView.layer.masksToBounds = true
        self.addSubview(cView)
        return cView
    }()
    
    lazy var connectView: MKConnectView = {
        let cView = MKConnectView()
        cView.backgroundColor = .white
        cView.layer.cornerRadius = 8.0
        cView.layer.masksToBounds = true
        cView.arrowBtn.addTarget(self, action: #selector(connnect(_:)), for: .touchUpInside)
        self.addSubview(cView)
        return cView
    }()
}

extension MKNodeDetailView {
    @objc func connnect(_ sender:UIButton) {
        if sender.isSelected {
            sender.backgroundColor = UIColor.hexColor(0x00E0CF)
        } else {
            sender.backgroundColor = UIColor.red
        }
        sender.isSelected = !sender.isSelected
        if let delegate = delegate {
            delegate.didConnectNode(with: self.node)
        }
    }
    public func refreshUI(with node:MKNodeTempeleModel) {
        self.node = node
        topHeadView.refreshUI(with: node)
    }
}

class MKTopHeadView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(contentView)
        contentView.addSubview(iconImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(pingLab)
        contentView.addSubview(adressLab)
        contentView.addSubview(markLab)
    }
    
    private func setupConstrains() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(iconImgView.snp.right).offset(18)
            make.top.equalTo(iconImgView)
        }
        
        pingLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(20)
        }
        
        adressLab.snp.makeConstraints { make in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(8)
        }
        
        markLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.left.equalTo(nameLab)
        }
    }
    
    lazy var contentView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.hexColor(0xF2F2F2)
        return cView
    }()
    
    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 4
        return imgView
    }()

    lazy var nameLab: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "PingFangSC-Regular", size: 16)
        return label
    }()
    
    lazy var adressLab: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.font = UIFont(name: "PingFangSC-Regular", size: 14)
        return label
    }()
    
    lazy var markLab: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        return label
    }()
    
    lazy var pingLab: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        return label
    }()
    
    lazy var placeLab: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        return label
    }()

}

extension MKTopHeadView {
    public func refreshUI(with node:MKNodeTempeleModel) {
        self.nameLab.text = node.subTitle
        if let flag_icon = node.flag_icon {
            self.iconImgView.image = UIImage.init(named: flag_icon)
        }
        if let ping = node.ping {
            if ping < 100 {
                self.pingLab.textColor = UIColor.hexColor(0x61ff90)
            } else if ping < 200 {
                self.pingLab.textColor = UIColor.hexColor(0xe7d51b)
            } else {
                self.pingLab.textColor = UIColor.hexColor(0xde4851)
            }
            self.pingLab.text = "\(ping)ms"
        }
        if let adress = node.adress {
            self.adressLab.text = adress
        }
        if let mark = node.mark {
            self.markLab.text = mark
        }
    }
}

class MKConnectView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(contentView)
        contentView.addSubview(arrowBtn)
    }
    
    private func setupConstrains() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        arrowBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.center.equalToSuperview()
            make.top.equalToSuperview().offset(4)
        }
    }
    
    lazy var contentView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.hexColor(0xF2F2F2)
        return cView
    }()
    
    lazy var arrowBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.hexColor(0x00E0CF)
        btn.setTitle("HOME_PROXY_START_DISCONNECT".localizable(), for: .normal)
        btn.setTitle("HOME_PROXY_STOP_DISCONNECT".localizable(), for: .selected)
        btn.setTitleColor(.white, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.layer.cornerRadius = 6.0
        btn.layer.masksToBounds = true
        contentView.addSubview(btn)
        return btn
    }()
}

