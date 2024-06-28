//
//  MKHomeSelectModeViewCell.swift
//  MonkeyKing
//
//  Created by huangrui on 2023/3/16.
//

import UIKit

class MKHomeSelectModeViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.hexColor(hexColor: 0x222536, alpha: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            connerView.layer.borderWidth = 4
        } else {
            connerView.layer.borderWidth = 0
        }
    }
    
    lazy var connerView: UIView = {
        let cView = UIView.init()
        cView.backgroundColor = UIColor.clear
        addSubview(cView)
        cView.isUserInteractionEnabled = true
        cView.backgroundColor = UIColor.hexColor(hexColor: 0x2D3343, alpha: 1.0)
        cView.layer.masksToBounds = true
        cView.layer.cornerRadius = 38.5
        cView.layer.borderColor = UIColor.hexColor(hexColor: 0xC8BCFA, alpha: 1.0).cgColor
        contentView.addSubview(cView)
        return cView
    }()
    
    lazy var titleLabel: UILabel = {
        let cView = UILabel.init()
        cView.text = "加速时间"
        cView.textColor = UIColor.hexColor(0xFFFFFF)
        cView.font = UIFont.medium(14)
        connerView.addSubview(cView)
        cView.textAlignment = .left
        return cView
    }()
    
    lazy var statusLabel: UILabel = {
        let cView = UILabel.init()
        cView.text = "加速时间"
        cView.textColor = UIColor.hexColor(0x979DAD)
        cView.font = UIFont.medium(10)
        connerView.addSubview(cView)
        cView.textAlignment = .left
        return cView
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ico_game")
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        connerView.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        connerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.init(top: 4.5, left: 22, bottom: 2.5, right: 22))
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 27, height: 30))
            make.left.equalToSuperview().offset(28.5)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.left.equalTo(iconImageView.snp.right).offset(18.5)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }

}

extension MKHomeSelectModeViewCell {
    func refreshData(_ model: MDHomeVPNModel) {
        titleLabel.text = model.title
        statusLabel.text = model.status
        iconImageView.image = UIImage.init(named: model.icon)
        if model.selectStatus {
            connerView.layer.borderWidth = 4
        } else {
            connerView.layer.borderWidth = 0
        }
    }
}
