//
//  MDHomeVPNModel.swift
//  Maodou
//
//  Created by huangrui on 2024/5/24.
//

import UIKit

enum VPNModeType:Int {
    case global = 0
    case game   = 1
    case video  = 2
}
enum VPNStatus:Int {
    case pausing   //暂停
    case loading   //加载中
    case running   //运行中
}

extension VPNModeType: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let int = try container.decode(Int.self)
        self = VPNModeType(rawValue: int) ?? .global
    }
}

struct MDHomeVPNModel:Codable {
    var title:String = ""
    var icon:String = ""
    var modeType:VPNModeType
    var modeIndex:Int = 0
    var modeTypeDec:String = ""
    var status:String = ""
    var selectStatus:Bool = false
    
    enum CodingKeys:String,CodingKey {
        case title
        case icon
        case modeType
        case modeIndex
        case modeTypeDec
        case status
        case selectStatus
    }
}
