//
//  MDChangeBindViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDChangeBindViewController: MDBindViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        super.setupUI()
        title = (type == .email) ? "CHANGE_BIND_EMAIL_TIPS".localizable() :  "CHANGE_BIND_PHONE_TIPS".localizable()
        
    }

     override func getTipText() -> String {
        if type == .email {
            return "NEW_ACCOUNT_CHANGE_BIND_EMAIL_TIPS".localizable()
        } else {
            return "NEW_ACCOUNT_CHANGE_BIND_PHONE_TIPS".localizable()
        }
    }

    override func bindSuccess() {
        super.bindSuccess()
        successView.tipLab.text = "NEW_ACCOUNT_HAS_BEEN_BIND".localizable()
    }

}
