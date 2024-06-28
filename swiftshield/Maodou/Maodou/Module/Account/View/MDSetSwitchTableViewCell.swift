//
//  MDSetSwitchTableViewCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDSetSwitchTableViewCellProtocol {
    func switchAction(_ sender: UIButton, model: MDSetModel?)
}

class MDSetSwitchTableViewCell: UITableViewCell {
    
    private var model: MDSetModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = kThemeColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func switchAction(_ sender: UIButton) {
        guard let target = viewController() as? MDSetSwitchTableViewCellProtocol else { return }
        target.switchAction(sender, model: self.model)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.top.equalToSuperview().offset(26)
            make.bottom.equalToSuperview().offset(-26)
        }

        infoLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
        }

        switchBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-34)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 18))
        }
    }

    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.regular(15)
        lab.textColor = UIColor.hexColor(0xDEE4F4)
        contentView.addSubview(lab)
        return lab
    }()

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.regular(12)
        lab.textColor = UIColor.hexColor(0x979DAD)
        lab.numberOfLines = 0
        contentView.addSubview(lab)
        return lab
    }()

    lazy var switchBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "bt_on"), for: .selected)
        btn.setImage(UIImage(named: "bt_off"), for: .normal)
        btn.addTarget(self, action: #selector(switchAction(_:)), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()
}

extension MDSetSwitchTableViewCell: UITableViewCellProtocol {

    func refreshData<T>(_ model: T) {
        guard let model = model as? MDSetModel else { return }
        titleLab.text = model.title
        switchBtn.isHidden = !(model.needSwitch ?? true)
        if !switchBtn.isHidden {
            switchBtn.isSelected = model.state ?? false
        }
        infoLab.isHidden = model.needSwitch ?? true
        if !infoLab.isHidden {
            infoLab.text = model.info
        }
        layoutIfNeeded()
    }
}
