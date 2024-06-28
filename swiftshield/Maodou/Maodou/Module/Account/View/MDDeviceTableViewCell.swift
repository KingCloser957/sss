//
//  MDDeviceTableViewCell.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDDeviceTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        contentView.backgroundColor = kThemeColor
        contentView.addSubview(nameLab)
        contentView.addSubview(infoLab)
        contentView.addSubview(usingLab)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.top.equalToSuperview().offset(18)
        }
        infoLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.top.equalTo(nameLab.snp_bottom).offset(9)
            make.bottom.equalToSuperview().offset(-14)
        }
        usingLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-37)
            make.centerY.equalTo(infoLab)
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
    }

    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "PingFangSC-Medium", size: 14)
        lab.text = "iPhone 12 Pro"
        lab.textColor = .white
        return lab
    }()

    lazy var infoLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "PingFangSC-Regular", size: 11)
        lab.textColor = .white
        lab.numberOfLines = 0
        return lab
    }()

    lazy var usingLab: UIImageView = {
        let lab = UIImageView()
        lab.image = UIImage(named: "device_tip")
        return lab
    }()


}

extension MDDeviceTableViewCell: UITableViewCellProtocol {
    func refreshData<T>(_ model: T) {
        let newModel = model as! MDDeviceLoginLogModel
        nameLab.text = newModel.model
        let date =  Date(timeIntervalSince1970: Double(newModel.lastLoginTime ?? 0))
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestr = format.string(from: date)
        infoLab.text = "\("DEVICE_MANAGEMENT_LATEST_LOGIN".localizable()) \(timestr)"

        let uuidStr = MDAppInfo().device_uuid
        usingLab.isHidden = !(newModel.uuid == uuidStr)

        layoutIfNeeded()
    }
}
