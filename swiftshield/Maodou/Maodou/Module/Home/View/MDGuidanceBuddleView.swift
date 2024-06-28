//
//  MDGuidanceBuddleView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/31.
//

import UIKit

protocol MDGuidanceStepOneDelegate:NSObjectProtocol {
    func didTapStepOneNext()
}

class MDGuidanceStepOneView: UIView {
    
    weak var delegate:MDGuidanceStepOneDelegate?
    var nextBlock:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
        bottleGuidanceView.refreshUI(with: .game)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(connerView)
        connerView.addSubview(topGuidanceView)
        connerView.addSubview(middleGuidanceView)
        connerView.addSubview(bottleGuidanceView)
        connerView.addSubview(nextBtn)
    }
    
    func setupConstrains() {
        
        connerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        middleGuidanceView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: MDLayout.layout(240),
                                          height: MDLayout.layout(240)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(MDLayout.layout(49.5) + 27)
        }
        
        layoutIfNeeded()
        setNeedsLayout()
        middleGuidanceView.drawBoardDottedLine(width: 3,
                                               lenth: 15,
                                               space: 4,
                                               cornerRadius:
                                                MDLayout.layout(240 / 2.0),
                                               color: UIColor.white)
        
        topGuidanceView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(middleGuidanceView.snp.bottom).offset(25)
            make.height.equalTo(32)
        }
        
        bottleGuidanceView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(MDLayout.layout(-36))
            make.top.equalTo(middleGuidanceView.snp.bottom).offset(MDLayout.layout(49.5) + 20)
            make.size.equalTo(CGSize(width: MDLayout.layout(98), height: MDLayout.layout(139)))
        }
        layoutIfNeeded()
        setNeedsLayout()
        bottleGuidanceView.drawBoardDottedLine(width: 3,
                                               lenth: 15,
                                               space: 4,
                                               cornerRadius:
                                                25,
                                               color: UIColor.white)
        
        nextBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 156, height: 32))
            make.bottom.equalToSuperview().offset(-42)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var connerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cView.isUserInteractionEnabled = true
        return cView
    }()
    
    lazy var topGuidanceView: GuidanceHeadView = {
        let view = GuidanceHeadView(frame: .zero)
        view.titleLabel.text = "HOME_PROXY_GUIDANCE_FIRST".localizable()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var middleGuidanceView: GuidanceMiddleView = {
        let view = GuidanceMiddleView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var bottleGuidanceView: MDHomeNodeModeView = {
        let view = MDHomeNodeModeView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.hexColor(hexColor: 0x03E0CF, alpha: 1.0)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.regular(20)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.hexColor(hexColor: 0x000000, alpha: 0.16).cgColor
        button.layer.shadowOpacity = 0.16
        button.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        button.layer.shadowRadius = 8
        button.setTitle("HOME_PROXY_GUIDANCE_NEXT".localizable(), for: .normal)
        button.isExclusiveTouch = true
        button.setTitleColor(UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(clickNext(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func clickNext(_ sender:UIButton) {
        if let nextBlock = nextBlock {
            nextBlock()
        }
    }
}

class MDGuidanceStepTwoView: UIView {
    
    var nextBlock:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
        bottleGuidanceView.refreshUI(with: .game,regionPlace: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(connerView)
        connerView.addSubview(topGuidanceView)
        connerView.addSubview(middleGuidanceView)
        connerView.addSubview(bottleGuidanceView)
        connerView.addSubview(nextBtn)
    }
    
    func setupConstrains() {
        
        connerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        middleGuidanceView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: MDLayout.layout(240),
                                          height: MDLayout.layout(240)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(MDLayout.layout(49.5) + 27)
        }
        
        layoutIfNeeded()
        setNeedsLayout()
        middleGuidanceView.drawBoardDottedLine(width: 3,
                                               lenth: 15,
                                               space: 4,
                                               cornerRadius:
                                                MDLayout.layout(240 / 2.0),
                                               color: UIColor.white)
        
        topGuidanceView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(middleGuidanceView.snp.bottom).offset(25)
            make.height.equalTo(32)
        }
        
        bottleGuidanceView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(middleGuidanceView.snp.bottom).offset(MDLayout.layout(49.5) + 20)
            make.size.equalTo(CGSize(width: MDLayout.layout(98), height: MDLayout.layout(139)))
        }
        layoutIfNeeded()
        setNeedsLayout()
        bottleGuidanceView.drawBoardDottedLine(width: 3,
                                               lenth: 15,
                                               space: 4,
                                               cornerRadius:
                                                25,
                                               color: UIColor.white)
        
        nextBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 156, height: 32))
            make.bottom.equalToSuperview().offset(-42)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var connerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cView.isUserInteractionEnabled = true
        return cView
    }()
    
    lazy var topGuidanceView: GuidanceHeadView = {
        let view = GuidanceHeadView(frame: .zero)
        view.titleLabel.text = "HOME_PROXY_GUIDANCE_SECOND".localizable()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var middleGuidanceView: GuidanceMiddleView = {
        let view = GuidanceMiddleView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    lazy var bottleGuidanceView: MDHomeNodeRegionView = {
        let view = MDHomeNodeRegionView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.hexColor(hexColor: 0x03E0CF, alpha: 1.0)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.regular(20)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.hexColor(hexColor: 0x000000, alpha: 0.16).cgColor
        button.layer.shadowOpacity = 0.16
        button.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        button.layer.shadowRadius = 8
        button.setTitle("HOME_PROXY_GUIDANCE_NEXT".localizable(), for: .normal)
        button.isExclusiveTouch = true
        button.setTitleColor(UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(clickNext(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func clickNext(_ sender:UIButton) {
        if let nextBlock = nextBlock {
            nextBlock()
        }
    }
}

class MDGuidanceStepThreeView: UIView {
    
    var nextBlock:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
        bottleGuidanceView.refreshUI(with: .game,regionPlace: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(connerView)
        connerView.addSubview(topGuidanceView)
        connerView.addSubview(middleGuidanceView)
        connerView.addSubview(bottleGuidanceView)
        connerView.addSubview(homeConnectView)
        connerView.addSubview(nextBtn)
    }
    
    func setupConstrains() {
        
        connerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        middleGuidanceView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: MDLayout.layout(240),
                                          height: MDLayout.layout(240)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(MDLayout.layout(49.5) + 27)
        }
        
        topGuidanceView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(middleGuidanceView.snp.bottom).offset(25)
            make.height.equalTo(32)
        }
        
        bottleGuidanceView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(middleGuidanceView.snp.bottom).offset(MDLayout.layout(49.5) + 20)
            make.size.equalTo(CGSize(width: MDLayout.layout(98), height: MDLayout.layout(139)))
        }
        
        homeConnectView.snp.makeConstraints { make in
            make.top.equalTo(bottleGuidanceView.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalTo(MDLayout.layout(339))
            make.height.equalTo(45)
        }
        
        layoutIfNeeded()
        setNeedsLayout()
        homeConnectView.drawBoardDottedLine(width: 3,
                                               lenth: 15,
                                               space: 4,
                                               cornerRadius:
                                                16,
                                               color: UIColor.white)
        
        
        nextBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 156, height: 32))
            make.bottom.equalToSuperview().offset(-42)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var connerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cView.isUserInteractionEnabled = true
        return cView
    }()
    
    lazy var topGuidanceView: GuidanceHeadView = {
        let view = GuidanceHeadView(frame: .zero)
        view.backgroundColor = .clear
        view.titleLabel.text = "HOME_PROXY_GUIDANCE_THIRD".localizable()
        return view
    }()
    
    lazy var middleGuidanceView: GuidanceMiddleView = {
        let view = GuidanceMiddleView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    lazy var bottleGuidanceView: MDHomeNodeRegionView = {
        let view = MDHomeNodeRegionView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    lazy var homeConnectView: MDHomeConnectView = {
        let view = MDHomeConnectView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.hexColor(hexColor: 0x03E0CF, alpha: 1.0)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.regular(20)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.hexColor(hexColor: 0x000000, alpha: 0.16).cgColor
        button.layer.shadowOpacity = 0.16
        button.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        button.layer.shadowRadius = 8
        button.setTitle("HOME_PROXY_CURRENT_FINISH".localizable(), for: .normal)
        button.isExclusiveTouch = true
        button.setTitleColor(UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(clickNext(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func clickNext(_ sender:UIButton) {
        if let nextBlock = nextBlock {
            nextBlock()
        }
    }
}

class GuidanceHeadView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(connerView)
        connerView.addSubview(titleLabel)
    }
    
    func setupConstrains() {
        connerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    lazy var connerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.white
        cView.isUserInteractionEnabled = true
        cView.layer.cornerRadius = 16
        cView.layer.borderColor = UIColor.clear.cgColor
        cView.clipsToBounds = true
        return cView
    }()
    
    lazy var titleLabel: UILabel = {
        let cView = UILabel.init()
        cView.text = "2. 选择一条合适的线路"
        cView.textColor = UIColor.hexColor(0x845DFF)
        cView.font = UIFont.regular(12)
        cView.textAlignment = .center
        cView.numberOfLines = 0
        cView.lineBreakMode = .byCharWrapping
        return cView
    }()
}


class GuidanceMiddleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(connerView)
        connerView.addSubview(shadowView)
    }
    
    func setupConstrains() {
        connerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var connerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.hexColor(0x5946Ea)
        cView.isUserInteractionEnabled = true
        cView.layer.cornerRadius = MDLayout.layout(240 / 2.0)
        cView.clipsToBounds = true
        cView.layer.borderColor = UIColor.clear.cgColor
        cView.clipsToBounds = true
        return cView
    }()
    
    lazy var shadowView: UIImageView = {
        let cView = UIImageView.init()
        cView.backgroundColor = UIColor.clear
        cView.contentMode = .scaleAspectFill
        cView.image = UIImage(named: "pic_yy")
        cView.layer.masksToBounds = true
        cView.isUserInteractionEnabled = true
        return cView
    }()
}
