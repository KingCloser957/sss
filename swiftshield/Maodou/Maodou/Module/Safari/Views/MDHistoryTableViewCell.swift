//
//  MDHistoryTableViewCell.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDHistoryTableViewCell: UITableViewCell {
    
    var isOpenLeft: Bool = false
    private var model: MDHistoryModel?
    var closeOtherSwipe: (() -> Void)?
    var deleteBlock: ((MDHistoryTableViewCell) -> Void)?

    weak var panGes: UIPanGestureRecognizer!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = UIColor.hexColor(0xF5F5F5)
        contentView.addSubview(cornerView)
        cornerView.addSubview(animationView)
        animationView.addSubview(deleteBtn)
        animationView.addSubview(containerView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshUI(_ model: MDHistoryModel) {
        self.model = model
        nameLab.text = (model.title?.isEmpty ?? true) ? model.url : model.title
        infoLab.text = model.url
        guard let char = nameLab.text?.first else { return }
        let titlePre = String(char)
        iconBtn.setTitle(titlePre, for: .normal)
//        guard let iconUrl = model.url,
//              let url = URL(string: iconUrl),
//              let scheme = url.scheme,
//              let host = url.host else { return }
//        if let newUrl = URL(string: "\(scheme)://\(host)") {
//            let faviconUrl = newUrl.appendingPathComponent("favicon.ico")
//            iconBtn.sd_setImage(with: faviconUrl, for: .normal)
//        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        markBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(contentView.snp.left)
        }
        cornerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
        }
        animationView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        deleteBtn.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(60)
            make.left.equalTo(containerView.snp.right)
        }
        containerView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(cornerView)
        }
        iconBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(21)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(iconBtn.snp.right).offset(19)
            make.top.equalToSuperview().offset(11)
            make.right.equalToSuperview().offset(-20)
        }
        infoLab.snp.makeConstraints { make in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-20)
        }
    }

    lazy var cornerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()

    lazy var animationView: UIView = {
        let view = UIView()
        //添加手势
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)

//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
//        view.addGestureRecognizer(tap)

        return view
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self,
                      action: #selector(deleteButtonAction),
                      for: .touchUpInside)
        return btn
    }()

    lazy var iconBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isUserInteractionEnabled = false
        btn.setImage(UIImage(named: "download_download_icon"), for: .normal)
        btn.addTarget(self,
                      action: #selector(downloadStateChange(_:)),
                      for: .touchUpInside)
        btn.setTitleColor(UIColor.hexColor(0x8C8C8C), for: .normal)
        btn.titleLabel?.font = UIFont.regular(15)
        btn.layer.cornerRadius = 15
        btn.layer.borderColor = UIColor.hexColor(0x8C8C8C).cgColor
        btn.layer.borderWidth = 1.0
        containerView.addSubview(btn)
        return btn
    }()

    lazy var markBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "download_deselected_icon"), for: .normal)
        btn.setImage(UIImage(named: "download_selected_icon"), for: .selected)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self,
                      action: #selector(selectAction(_:)),
                      for: .touchUpInside)
        addSubview(btn)
        return btn
    }()

    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x000000)
        lab.font = UIFont(name: "PingFangSC-Regular", size: 12)
        containerView.addSubview(lab)
        return lab
    }()

    lazy var stateLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x8C8C8C)
        lab.font = UIFont(name: "PingFangSC-Regular", size: 10)
        containerView.addSubview(lab)
        return lab
    }()

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor(0x8C8C8C)
        lab.font = UIFont(name: "PingFangSC-Regular", size: 10)
        lab.text = "1Mb/s  - 24Mb / 1.4Gb (1%)"
        containerView.addSubview(lab)
        return lab
    }()

}

@objc extension MDHistoryTableViewCell {

    func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .left {
            if isOpenLeft {
                return
            }
            if closeOtherSwipe != nil {
                closeOtherSwipe!()
            }
            UIView.animate(withDuration: 0.5) {
                self.animationView.transform = CGAffineTransform(translationX: -60, y: 0)
            }
            isOpenLeft = true
        } else if swipe.direction == .right {
            closeLeftSwipe()
        }
    }

    func tapAction(_ tap: UITapGestureRecognizer) {
        if !isOpenLeft {
            return
        }
        closeLeftSwipe()
    }

    func closeLeftSwipe() {
        if !isOpenLeft {
            return
        }
        UIView.animate(withDuration: 0.5) {
            self.animationView.transform = .identity
        }
        isOpenLeft = false
    }

    func selectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    func deleteButtonAction() {
        if let block = deleteBlock {
            block(self)
        }
    }

    func downloadStateChange(_ sender: UIButton) {

    }
}
