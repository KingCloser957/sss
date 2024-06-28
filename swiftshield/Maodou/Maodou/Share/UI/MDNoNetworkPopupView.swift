//
//  MKNoNetworkPopupView.swift
//  MonkeyKing
//
//  Created by huangrui on 2023/3/29.
//

import UIKit
import AttributedString

var isShowNoNetworkView: Bool = false

class MDNoNetworkTipView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        cornerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }

        iconImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.centerY.equalToSuperview()
        }

        tipLab.snp.makeConstraints { make in
            make.left.equalTo(iconImgView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }

    }

    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0xff9797)
        lab.font = UIFont(name: "PingFangSC-Regular", size: 12)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        cornerView.addSubview(lab)
        return lab
    }()

    lazy var cornerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.hexColor(0x270e01)
        addSubview(view)
        return view
    }()

    lazy var iconImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "hud_net_weak_icon")
        cornerView.addSubview(view)
        return view
    }()
}

class MDNoNetworkStepView: UIView {

    var tapAction: (() -> ())?

    override func layoutSubviews() {
        super.layoutSubviews()
        cornerView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

        tipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let tapAction = tapAction else {
            return
        }

        tapAction()
    }

    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont(name: "PingFangSC-Regular", size: 14)
        lab.numberOfLines = 0
        lab.textAlignment = .left
        cornerView.addSubview(lab)
        return lab
    }()

    lazy var cornerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.hexColor(0x394451)
        addSubview(view)
        return view
    }()
}

class MDNoNetworkPopupView: MDBasePopupView {

    var text: String?
//    var count: Int = 0

//    @objc
//    func countAction() {
//        count += 1
//        countLab.text = "\(count) s"
//    }

//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
////        timer.fire()
////        if !timer.isValid {
//            timer.fire()
////        }
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }

    override func dismiss() {
        super.dismiss()
        isShowNoNetworkView = false
    }

    override func show() {
        super.show()
        isShowNoNetworkView = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalToSuperview()
//            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        }

        tipView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.bottom.equalTo(firstStepView.snp.top).offset(-6)
        }

        firstStepView.snp.makeConstraints { make in
            make.left.right.equalTo(tipView)
            make.bottom.equalTo(secondStepView.snp.top).offset(-6)
        }

        secondStepView.snp.makeConstraints { make in
            make.left.right.equalTo(tipView)
            make.bottom.equalTo(thirdStepView.snp.top).offset(-6)
        }

        thirdStepView.snp.makeConstraints { make in
            make.left.right.equalTo(tipView)
            make.bottom.equalToSuperview().offset(-34)
        }
//        iconImgView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.size.equalTo(CGSize(width: 125, height: 78))
//            make.top.equalToSuperview()
//        }
//        tipLab.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(iconImgView.snp.bottom).offset(19)
//            make.width.equalTo(300)
//        }
//        cornerView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(tipLab.snp.bottom).offset(56)
//            make.size.equalTo(CGSize(width: 58, height: 58))
//            make.bottom.equalToSuperview()
//        }
//        loadingImgView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(0)
//            make.size.equalTo(CGSize(width: 48, height: 43.5))
//        }
//        countLab.snp.makeConstraints { make in
//            make.top.equalTo(loadingImgView.snp.bottom).offset(0)
//            make.centerX.equalToSuperview()
//        }

    }

    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "popup_no_network")
        contentView.addSubview(imgView)
        return imgView
    }()

    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont(name: "PingFangSC-Regular", size: 14)
        lab.numberOfLines = 0
//        lab.text =  """
//                    No network available
//                    Please check whether your network is normal
//                    You can check \"cellular network\" or \"Wi-Fi\"
//                    """
        lab.textAlignment = .center
        contentView.addSubview(lab)
        return lab
    }()

    lazy var cornerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.hexColor(0x394451)
        contentView.addSubview(view)
        return view
    }()

    lazy var loadingImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.loadGif(name: "connection_loading")
        cornerView.addSubview(imgView)
        return imgView
    }()

    lazy var countLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont(name: "PingFangSC-Regular", size: 10)
        lab.numberOfLines = 0
        cornerView.addSubview(lab)
        return lab
    }()
    
    lazy var tipView: MDNoNetworkTipView = {
        let view = MDNoNetworkTipView()
        addSubview(view)
        return view
    }()


    lazy var firstStepView: MDNoNetworkStepView = {
        let view = MDNoNetworkStepView()
        view.tipLab.attributed.text = """
                           1. \("请检查您的网络")\("[设定]", .foreground(UIColor.hexColor(0x82c1ff)))\("查看更多信息")
                           """
        view.tapAction = { [weak self] in
            self?.toSetCellular()
        }
        addSubview(view)
        return view
    }()

    lazy var secondStepView: MDNoNetworkStepView = {
        let view = MDNoNetworkStepView()
        view.tipLab.attributed.text = """
                            2. \("检查权限")\("打开网络", .foreground(UIColor.hexColor(0x82c1ff)))
                            """
        view.tapAction = { [weak self] in
            self?.toSetWLAN()
        }
        addSubview(view)
        return view
    }()

    lazy var thirdStepView: MDNoNetworkStepView = {
        let view = MDNoNetworkStepView()
        view.tipLab.text = "3. \("以上都失败了，联系客服")"
        addSubview(view)
        return view
    }()

//    lazy var timer: Timer = {
////        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(countAction), userInfo: nil, repeats: true)
//        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countAction), userInfo: nil, repeats: true)
//        RunLoop.current.add(timer, forMode: .common)
//        return timer
//    }()

    func toSetCellular() {
        toSetWLAN()
    }

    /// 前往Wi-Fi设置页面
    func toSetWLAN() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.openURL(url)
    }

}
