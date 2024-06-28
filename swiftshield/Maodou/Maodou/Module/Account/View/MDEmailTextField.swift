//
//  MDEmailTextField.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDEmailTextField: MDAccountTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.keyboardType = .emailAddress
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
