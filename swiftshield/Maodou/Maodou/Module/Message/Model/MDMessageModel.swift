//
//  MDMessageModel.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDMessageModel: Codable {
    var id: Int?
    var title: String?
    var body: String?
    var textBody: String?
    var isRead: Int = 0
    var createTime: String?
}
