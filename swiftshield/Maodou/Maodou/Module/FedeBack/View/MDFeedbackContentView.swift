//
//  MDFeedbackContentView.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

protocol MDFeedbackContentViewProtocol {
    func selectImage(_ sender: UIButton)
}

class MDFeedbackContentView: UIView {
    
    var text: String? {
        get{
            return textView.text
        }
    }
    var image: [UIImage]? {
        didSet {
            if let newImage = image?.first {
                imgBtn.setImage(newImage, for: .normal)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-21)
            make.left.equalToSuperview().offset(21)
        }
        imgBtn.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(21)
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.bottom.equalToSuperview().offset(-24)
        }
    }

    @objc
    private func addImageAction(_ sender: UIButton) {
        guard let target = viewController() as? MDFeedbackContentViewProtocol else { return }
        target.selectImage(sender)
    }

    lazy var textView: UITextView = {
        let view = UITextView()
        view.font = UIFont.regular(12)
        view.tintColor = .white
        view.textColor = UIColor.hexColor(0x7A7D89)
        view.backgroundColor = .clear
        view.x_placeholder =  "SETTING_CONTACTUS_MESSAGE_PLACEHOLD".localizable()
        view.x_placeholderColor = UIColor.hexColor(0x7A7D89)
        view.x_placeholderFont = UIFont.regular(12)
        view.returnKeyType = .done
        addSubview(view)
        return view
    }()

    lazy var imgBtn: UIButton = {
        let view = UIButton(type: .custom)
        view.setBackgroundImage(UIImage(named: "add_pic"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 15.0
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(addImageAction(_:)), for: .touchUpInside)
        addSubview(view)
        return view
    }()
}
