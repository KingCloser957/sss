//
//  MDMineCellModel.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit

class MDMineCellModel: Codable {
    let title: String
    var info: String?
    var type: Int?
    var icon: String?
    var needArrowIcon: Bool? = true
    var needRedDot: Bool? = false
}
