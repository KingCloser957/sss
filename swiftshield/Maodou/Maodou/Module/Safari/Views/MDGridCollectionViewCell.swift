//
//  MDGridCollectionViewCell.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDGridCollectionViewCell: UICollectionViewCell {
    
    var closeBlock: ((_ tab: MDTabModel?) -> ())?
    var tab: MDTabModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
//
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(29)
        }
        imgView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(7)
            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 15.0, height: 15.0))
        }
        titleLab.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.centerY.equalTo(iconView)
            make.trailing.equalToSuperview().offset(-4)
        }
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: 29, height: 29))
        }
    }

    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0xFFFFFF)
        contentView.addSubview(view)
        return view
    }()

    func refreshUI(_ tab: MDTabModel) {
        self.tab = tab
        imgView.image = getSanpshot(tab.id)
        titleLab.text = tab.title
        guard let urlStr = tab.url,
              let url = URL(string: urlStr) else {
            return
        }
        let domain = url.deletingPathExtension()
        let faviconUrl = domain.appendingPathComponent("favicon.ico")
        iconView.sd_setImage(with:faviconUrl, placeholderImage: UIImage(named: "tab_favicon_default_icon"))
    }

    func getSanpshot(_ name: String) -> UIImage? {
        let folder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0].appendingPathComponent("snapshot")
        let snapshotPath = folder.appendingPathComponent("\(name).png")
        guard let data = try? Data.init(contentsOf: snapshotPath) else {
            return nil
        }
        let image = UIImage(data: data)
        return image
    }

    lazy var imgView: UIImageView = {
        let iView = UIImageView()
        iView.isUserInteractionEnabled = true
        iView.backgroundColor = UIColor.hexColor(0xFFFFFF)
        iView.contentMode = .scaleAspectFill
        contentView.addSubview(iView)
        return iView
    }()

    lazy var iconView: UIImageView = {
        let iView = UIImageView()
        iView.contentMode = .scaleAspectFit
        iView.image = UIImage(named: "tab_favicon_default_icon")
        topView.addSubview(iView)
        return iView
    }()

    lazy var titleLab: UILabel = {
        let iView = UILabel()
        iView.textColor = UIColor.hexColor(0x000000)
        iView.font = UIFont(name: "PingFangSC-Regular", size: 10)
        iView.numberOfLines = 1
        topView.addSubview(iView)
        return iView
    }()

    lazy var closeBtn: UIButton = {
        let cBtn = UIButton(type: .custom)
        cBtn.setImage(UIImage(named: "table_close_icon"), for: .normal)
        cBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        topView.addSubview(cBtn)
        return cBtn
    }()
}


extension MDGridCollectionViewCell {
    @objc
    func closeAction() {
        if closeBlock != nil {
            closeBlock!(tab)
        }
    }
}
