//
//  MDHomeAnimationView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDHomeAnimationViewDelegate:NSObjectProtocol {
    func switchNodeStatus()
}

class MDHomeAnimationView: UIView {
    
    var delegate:MDHomeAnimationViewDelegate?
    
    let leftAngle:CGFloat          = 240.0
    let rightAngle:CGFloat         = 35.0
    let bigSquareRadius:CGFloat    = MDLayout.layout(320 / 2.0)
    let smallSquareRadius:CGFloat  = MDLayout.layout(240 / 2.0)
    let iconSquareRadius:CGFloat   = MDLayout.layout(150)
    
    var statusType:VPNStatus? = .pausing {
        didSet {
            refreshUI(statusType ?? .pausing, vpnType ?? .global)
        }
    }
    var vpnType:VPNModeType? = .global {
        didSet {
            refreshUI(statusType ?? .pausing, vpnType ?? .global)
        }
    }
    
    var vpnSelectAction:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,status :VPNStatus,mode:VPNModeType) {
        super.init(frame: frame)
        statusType = status
        vpnType = mode
        setupConstrains()
    }
    
    lazy var contentView: UIView = {
        let cView = UIView.init()
        cView.backgroundColor = UIColor.clear
        addSubview(cView)
        cView.isUserInteractionEnabled = true
        return cView
    }()
    
    lazy var bgView: UIImageView = {
        let cView = UIImageView.init()
        cView.backgroundColor = UIColor.clear
        contentView.addSubview(cView)
        cView.isUserInteractionEnabled = true
        return cView
    }()
    
    lazy var angleLeftView: UIView = {
        let cView = UIView.init()
        cView.backgroundColor = UIColor.hexColor(hexColor: 0xDADADA, alpha: 1.0)
        cView.layer.masksToBounds = true
        cView.layer.cornerRadius = 4.5
        cView.isHidden = true
        contentView.addSubview(cView)
        return cView
    }()
    
    lazy var shadowView: UIImageView = {
        let cView = UIImageView.init()
        cView.backgroundColor = UIColor.clear
        cView.contentMode = .scaleAspectFill
        cView.layer.masksToBounds = true
        cView.layer.cornerRadius = smallSquareRadius
        contentView.addSubview(cView)
        cView.isUserInteractionEnabled = true
        return cView
    }()
    
    lazy var angleRightView: UIView = {
        let cView = UIView.init()
        cView.isHidden = true
        cView.backgroundColor = UIColor.hexColor(hexColor: 0xDADADA, alpha: 1.0)
        cView.layer.masksToBounds = true
        cView.layer.cornerRadius = 7.0
        contentView.addSubview(cView)
        return cView
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pic_yx")
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(switchMode))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupConstrains() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(self.width / 2 - bigSquareRadius)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(bigSquareRadius * 2)
        }
        
        let leftOrigViewx = bigSquareRadius * (1 + CGFloat(cosf(Float(leftAngle * Double.pi / 180.0)))) - 4.5
        let leftOrigViewy = bigSquareRadius * (1 + CGFloat(sinf(Float(leftAngle * Double.pi / 180.0)))) - 4.5
        
        angleLeftView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(leftOrigViewy)
            make.left.equalToSuperview().offset(leftOrigViewx)
            make.size.equalTo(CGSize.init(width: 9.0, height: 9.0))
        }
        
        let rightOrigViewx = smallSquareRadius * CGFloat(cosf(Float(rightAngle * Double.pi / 180.0))) + 7 - bigSquareRadius
        let rightOrigViewy = smallSquareRadius * CGFloat(sinf(Float(rightAngle * Double.pi / 180.0))) + 7 - bigSquareRadius
        
        angleRightView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(rightOrigViewy)
            make.right.equalToSuperview().offset(rightOrigViewx)
            make.size.equalTo(CGSize.init(width: 14.0, height: 14.0))
        }
        
        shadowView.snp.makeConstraints { make in
            make.center.equalTo(bgView)
            make.width.height.equalTo(smallSquareRadius * 2)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(bgView)
            make.size.equalTo(CGSize(width: iconSquareRadius, height: iconSquareRadius))
        }
    }
}

extension MDHomeAnimationView {
    
    @objc private func switchMode() {
        guard let delegate = self.delegate else { return  }
        delegate.switchNodeStatus()
    }
    
    func drawLineDash() {
        self.bgView.image = drawlineofDashByImageView(imageView: self.bgView)
    }
    
    func refreshUI() {
        refreshUI(.pausing, .global)
    }
    
    func refreshUI(_ status :VPNStatus,_ mode:VPNModeType) {
        layoutIfNeeded()
        let width = self.shadowView.width
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "VPNLoadingStatusNotification"), object: ["VPNStatus":status,"VPNMode":mode], userInfo:nil)
        switch mode {
        case .global:
            switch status {
            case .pausing:
                self.bgView.alpha = 0
                self.iconImageView.image = UIImage.init(named: "pic_qq")
                self.shadowView.image = UIImage.imageFromeColor(color: UIColor.hexColor(hexColor: 0xD8D8D8, alpha: 1.0), width: width, height: width)
                self.endLoadingAnimation()
                Log.debug("全局暂停")
            case .loading:
                self.bgView.alpha = 1
                self.iconImageView.image = UIImage.init(named: "pic_qq")
                self.shadowView.image = UIImage.imageFromeColor(color: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.14), width: width, height: width)
                drawLineDash()
                beginLoadingAnimation()
                Log.debug("全局加载")
            case .running:
                self.bgView.alpha = 1
                self.iconImageView.image = UIImage.init(named: "pic_qq")
                self.shadowView.image = UIImage.imageFromeColor(color: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.14), width: width, height: width)
                self.bgView.image = UIImage.init(named: "jiasu_quanju")
                Log.debug("全局运行")
            }
        case .video:
            switch status {
            case .pausing:
                self.bgView.alpha = 0
                self.iconImageView.image = UIImage.init(named: "pic_yy")
                self.shadowView.alpha = 1
                self.shadowView.image = UIImage.imageFromeColor(color:UIColor.hexColor(hexColor: 0x2D3343, alpha: 0.3), width: width, height: width)
                self.endLoadingAnimation()
                Log.debug("影音暂停")
            case .loading:
                self.bgView.alpha = 1
                self.iconImageView.image = UIImage.init(named: "pic_yy")
                self.shadowView.image = UIImage.imageFromeColor(color: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.14), width: width, height: width)
                drawLineDash()
                beginLoadingAnimation()
                Log.debug("影音加载")
            case .running:
                self.bgView.alpha = 1
                self.iconImageView.image = UIImage.init(named: "pic_yy")
                self.shadowView.image = UIImage.imageFromeColor(color: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.08), width: width, height: width)
                self.bgView.image = UIImage.init(named: "jiasu_yingyin")
                Log.debug("影音运行")
            }
        case .game:
            switch status {
            case .pausing:
                self.bgView.alpha = 0
                self.iconImageView.image = UIImage.init(named: "pic_yx")
                self.endLoadingAnimation()
                self.shadowView.image = UIImage.imageFromeColor(color:UIColor.hexColor(hexColor: 0x2D3343, alpha: 0.3), width: width, height: width)
                Log.debug("游戏暂停")
            case .loading:
                self.bgView.alpha = 1
                self.iconImageView.image = UIImage.init(named: "pic_yx")
                drawLineDash()
                self.shadowView.image = UIImage.imageFromeColor(color: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.14), width: width, height: width)
                beginLoadingAnimation()
                Log.debug("游戏加载")
            case .running:
                self.bgView.alpha = 1
                self.iconImageView.image = UIImage.init(named: "pic_yx")
                self.shadowView.image = UIImage.imageFromeColor(color: UIColor.hexColor(hexColor: 0xFFFFFF, alpha: 0.08), width: width, height: width)
                self.bgView.image = UIImage.init(named: "jiasu_youxi")
                Log.debug("游戏运行")
            }
        }
    }
    
    private func whirl(with view:UIView,path layerPath:UIBezierPath) {
        let animation = CAKeyframeAnimation.init(keyPath: "position")
        animation.path = layerPath.cgPath
        animation.duration = 3.0
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(animation, forKey: nil)
    }
    
    public func beginLoadingAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn) {
            self.angleLeftView.isHidden = false
            self.angleRightView.isHidden = false
        } completion: { success in
            let beziePath1 = UIBezierPath.init(
                                            arcCenter: self.bgView.center,
                                            radius: self.bgView.width / 2.0,
                                            startAngle: self.leftAngle,
                                            endAngle: .pi * 2 + self.leftAngle,
                                            clockwise: true)
            beziePath1.lineWidth = 3
            beziePath1.lineCapStyle = .round
            beziePath1.lineJoinStyle = .round
            beziePath1.stroke()
            self.whirl(with: self.angleLeftView, path: beziePath1)
            
            let beziePath2 = UIBezierPath.init(
                                            arcCenter: self.shadowView.center,
                                            radius: self.shadowView.width / 2.0,
                                            startAngle: self.rightAngle,
                                            endAngle: .pi * 2 + self.rightAngle,
                                            clockwise: true)
            beziePath2.lineWidth = 3
            beziePath2.lineCapStyle = .round
            beziePath2.lineJoinStyle = .round
            beziePath2.stroke()
            self.whirl(with: self.angleRightView, path: beziePath2)
        }
    }
    
    func endLoadingAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.beginFromCurrentState) {
            self.angleLeftView.layer.removeAnimation(forKey: "position")
            self.angleLeftView.layer.removeAnimation(forKey: "position")
        } completion: { success in
            self.angleLeftView.isHidden = true
            self.angleRightView.isHidden = true
        }
    }
    
    func drawlineofDashByImageView(imageView:UIImageView) -> UIImage {
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: CGRect.init(x: 0, y: 0, width: imageView.width, height: imageView.height))
        
        let line = UIGraphicsGetCurrentContext()
        line?.setLineCap(CGLineCap.round)
        let lineDashPattern: [CGFloat] = [5, 5]
        line?.setStrokeColor(UIColor.white.cgColor)
        
        let center = imageView.center
        let radius: CGFloat = imageView.width / 2.0
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = .pi * 2
        line?.setLineDash(phase: 2, lengths: lineDashPattern)
        line?.addArc(center: center , radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        line?.strokePath()
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

