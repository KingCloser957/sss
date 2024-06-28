//
//  MDWebHeaderView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDHeaderProtocol {
    func refreshAction()
    func didTapAction()
    func didBackAction()
}

class MDWebHeaderView: UIView {
    override init(frame: CGRect) {
        self.text = ""
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        backBtn.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(10)
//            make.bottom.equalToSuperview()
//            make.width.equalTo(44)
//            make.height.equalTo(44)
//        }
        cornerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
        iconImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        textLab.snp.makeConstraints { make in
            make.leading.equalTo(iconImgView.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        refreshBtn.snp.makeConstraints { make in
            make.leading.equalTo(textLab.snp.trailing)
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    var text: String {
        didSet {
            if text.isEmpty || text == "" {
                textLab.textColor = UIColor.hexColor(0xDDD48E)
                textLab.text = "BROWER_HOME_PLACEHOLDER".localizable()
            } else {
                textLab.text = text
            }
        }
    }

//    lazy var backBtn: UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "back"), for: .normal)
//        btn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
//        addSubview(btn)
//        return btn
//    }()

    lazy var cornerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 17
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        addSubview(view)
        return view
    }()

    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "search_icon")
        cornerView.addSubview(imgView)
        return imgView
    }()

    lazy var textLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0xDDD48E)
        lab.text = ""
        cornerView.addSubview(lab)
        return lab
    }()

    lazy var refreshBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "search_refresh_icon"), for: .normal)
        view.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        view.isHidden = true
        cornerView.addSubview(view)
        return view
    }()
}

extension MDWebHeaderView {

    @objc
    func refreshAction() {
        guard let target = viewController() as? MDHeaderProtocol else { return }
        target.refreshAction()
    }

    @objc
    func backBtnAction() {
        guard let target = viewController() as? MDHeaderProtocol else { return }
        target.didBackAction()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let target = viewController() as? MDHeaderProtocol else { return }
        target.didTapAction()
    }
}
