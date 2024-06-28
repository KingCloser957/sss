//
//  MDFeedbackDetailModel.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDFeedbackDetailModel: Codable {
    var feedbackVo: MDFeedbackListModel?
    var record: [MDFeedbackRecordModel]?
    var state: Int?
}

