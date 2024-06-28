//
//  MKHomeNodeModel.swift
//  MonkeyKing
//
//  Created by huangrui on 2023/3/17.
//

import UIKit

struct MKNodeTempeleModel:Codable {
    var id: String
    var title: String = ""
    var icon: String = ""
    var type: Int
    var x: Float
    var y: Float
    var isSelected: Bool = false
    var ping: Int?
    var subTitle: String?
    var mark: String?
    var adress: String?
    var flag_icon: String?
    var modeType:VPNModeType? = .global
    
    enum CodingKeys:String,CodingKey {
        case id
        case title
        case icon
        case type
        case x
        case y
        case isSelected
        case ping
        case subTitle
        case mark
        case adress
        case flag_icon
    }
}
