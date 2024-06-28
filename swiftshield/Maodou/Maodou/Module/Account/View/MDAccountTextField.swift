//
//  MDAccountTextField.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDAccountTextField: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.keyboardType = .default
        textField.clearButtonMode = .whileEditing
        textField.spellCheckingType = .no
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
//
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: 17, y: 0, width: bounds.width - 34, height: bounds.height)
//    }
//
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: 17, y: 0, width: bounds.width - 34, height: bounds.height)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: 17, y: 0, width: bounds.width - 34, height: bounds.height)
//    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0,
                                                             left: 17,
                                                             bottom: 1,
                                                             right: 17))

        }
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.right.left.equalToSuperview()
        }
    }

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(0x2D3343)
        addSubview(view)
        return view
    }()

    lazy var textField: UITextField = {
        let textF = UITextField()
        textF.textColor = UIColor.hexColor(0xDEE4F4)
        textF.tintColor = .white
        textF.font = UIFont.regular(15)
        textF.returnKeyType = .done
        let color = UIColor.hexColor(0x979DAD)
        textF.setValue(color, forKeyPath: "placeholderLabel.textColor")
        if let clearBtn = textF.value(forKeyPath: "_clearButton") as? UIButton {
            clearBtn.setImage(UIImage(named: "clear"), for: .normal)
        }
        textF.delegate = self
        addSubview(textF)
        return textF
    }()
}

extension MDAccountTextField: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
