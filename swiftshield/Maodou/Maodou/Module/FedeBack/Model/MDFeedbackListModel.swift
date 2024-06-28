//
//  MDFeedbackListModel.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import Foundation

class MDFeedbackListModel: Codable {

    var content: String?
    var createdTime: String?
    var id: Int?
    var imageUrl: [String]?
    var isRead: Int?
    var kind: Int?
    enum CodingKeys: String, CodingKey {
        case content
        case createdTime = "created_at"
        case id
        case imageUrl = "image_url"
        case isRead = "is_read"
        case kind
    }
}
