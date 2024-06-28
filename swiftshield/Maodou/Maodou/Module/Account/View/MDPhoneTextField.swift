//
//  MDPhoneTextField.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDPhoneTextField: MDAccountTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.keyboardType = .namePhonePad
    }

    var regionCode: String {
        get {
            return regionBtn.regionCode ?? "86"
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        regionBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.height.equalTo(34)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
        }
        textField.snp.remakeConstraints({ make in
            make.left.equalTo(regionBtn.snp_right).offset(15)
            make.right.equalToSuperview().offset(-17)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
        })
        regionBtn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        regionBtn.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        regionBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func defaultRegionModel() -> MDCountyCodeModel? {
        guard let url = Bundle.main.url(forResource: "country_code", withExtension: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        let decode = JSONDecoder()
        guard let model = try? decode.decode(MDCountyCodeListModel.self, from: data) else {
            return nil
        }
        let user = MDUserInfoManager.share.user()
        let cacheCode = user?.user?.regionCode ?? "86"
        let result = model.countryList.filter { item in
            return item.code == Int(cacheCode)
        }
        return result.first
    }

    lazy var regionBtn: MDRegionCodeButton = {
        let btn = MDRegionCodeButton()
        let model = defaultRegionModel()
        btn.regionCode = "\(model?.code ?? 86)"
        btn.setTitle("+\(model?.code ?? 86) \(model?.zhHans ?? "LOGIN_PHONE_CHINA_TIPS".localizable())")
        btn.setImage(UIImage(named: "arrow_down"), for: .normal)
        btn.setImage(UIImage(named: "arrow_up"), for: .selected)
        btn.addTarget(self, action: #selector(regionAction(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 17
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.hexColor(0x3D4455).cgColor
        addSubview(btn)
        return btn
    }()

    @objc
    private func regionAction(_ sender: MDRegionCodeButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let window = UIApplication.shared.currentWindow
            let rect = sender.convert(sender.frame, to: window)
            let codeView = MDCountryCodeView(frame: window!.bounds)
            codeView.contentTop = rect.midY
            codeView.didSelectBlock = { [weak self](model) in
                self?.regionBtn.regionCode = "\(model.code)"
                self?.regionBtn.county = model.zhHans
                self?.regionBtn.setTitle("+\(model.code) \(model.zhHans)")
                self?.regionBtn.isSelected = false
                self?.layoutSubviews()
            }
            codeView.dismissClosure = { [weak self] in
                self?.regionBtn.isSelected = false
            }
            codeView.show()
        }
    }
}

class MDRegionCodeButton: UIControl {

    private var normalImage: UIImage?
    private var selectImage: UIImage?
    private var normalTitle: String?
    private var selectTitle: String?

    open var regionCode: String?
    open var county: String?

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
//            make.width.lessThanOrEqualTo(150)
        })
        imageView.snp.makeConstraints({ make in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.size.equalTo(CGSize(width: 9, height: 5))
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(titleLabel)
        })
    }

    func setImage(_ image: UIImage?, for state: UIControl.State) {
        switch state {
        case .normal:
            normalImage = image
        case .selected:
            selectImage = image
        default:
            break
        }
        imageView.image = isSelected ? normalImage : selectImage
    }

    func setTitle(_ title: String?) {
        normalTitle = title
        titleLabel.text = normalTitle
        layoutIfNeeded()
    }

    override var isSelected: Bool {
        didSet {
            Log.info(isSelected)
            imageView.image = isSelected ? selectImage : normalImage
        }
    }

    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.regular(15)
        lab.textColor = UIColor.white
        addSubview(lab)
        return lab
    }()

    lazy var imageView: UIImageView = {
        let lab = UIImageView()
        addSubview(lab)
        return lab
    }()
}
