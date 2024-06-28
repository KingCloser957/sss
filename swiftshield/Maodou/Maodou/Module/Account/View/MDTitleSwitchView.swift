//
//  MDTitleSwitchView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDTitleSwitchViewProtocol {
    func didSelectAction(_ type: MDTitleSwitchViewType)
}

enum MDTitleSwitchViewType: Int {
    case email
    case phone
}

class MDTitleSwitchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftBtn.snp.makeConstraints { make in
            make.right.equalTo(self.snp_centerX)
            make.centerY.equalToSuperview()
            make.width.equalTo(89)
        }
        rightBtn.snp.makeConstraints { make in
            make.left.equalTo(self.snp_centerX)
            make.centerY.equalToSuperview()
            make.width.equalTo(89)
        }
        lineView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 89, height: 2))
            make.right.equalTo(self.snp_centerX)
            make.bottom.equalToSuperview()
        }
    }

    private var mk_type: MDTitleSwitchViewType = .email

    var type: MDTitleSwitchViewType {
        get {
            return mk_type
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var leftBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.medium(18)
        btn.setTitleColor(UIColor.hexColor(0x979DAD), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0xDEE4F4), for: .selected)
        btn.isSelected = true
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(leftAction(_:)), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()

    lazy var rightBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.hexColor(0x979DAD), for: .normal)
        btn.setTitleColor(UIColor.hexColor(0xDEE4F4), for: .selected)
        btn.titleLabel?.font = UIFont.medium(13)
        btn.isSelected = false
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0xDEE4F4)
        view.size = CGSize(width: 89, height: 2)
        addSubview(view)
        return view
    }()
}

extension MDTitleSwitchView {

    public func setupDatas(_ datas: [String]) {
        leftBtn.setTitle(datas[0], for: .normal)
        rightBtn.setTitle(datas[1], for: .normal)
        layoutIfNeeded()
    }

    @objc
    private func leftAction(_ sender: UIButton) {
        mk_type = .email
        sender.isEnabled = false
        sender.isSelected = true
        sender.titleLabel?.font = UIFont.medium(18)
        rightBtn.isEnabled = true
        rightBtn.isSelected = false
        rightBtn.titleLabel?.font = UIFont.medium(13)
        refreshLineViewPosition()
        guard let vc = viewController() as? MDTitleSwitchViewProtocol else { return }
        vc.didSelectAction(.email)
    }

    @objc
    private func rightAction(_ sender: UIButton) {
        mk_type = .phone
        sender.isEnabled = false
        sender.isSelected = true
        sender.titleLabel?.font = UIFont.medium(18)
        leftBtn.isEnabled = true
        leftBtn.isSelected = false
        leftBtn.titleLabel?.font = UIFont.medium(13)
        refreshLineViewPosition()
        guard let vc = viewController() as? MDTitleSwitchViewProtocol else { return }
        vc.didSelectAction(.phone)
    }

    private func refreshLineViewPosition() {
        if leftBtn.isSelected {
            lineView.snp.updateConstraints({ make in
                make.right.equalTo(self.snp_centerX)
            })
        } else {
            lineView.snp.updateConstraints({ make in
                make.right.equalTo(self.snp_centerX).offset(89)
            })
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
