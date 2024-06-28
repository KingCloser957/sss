//
//  MDDeviceModel.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import Foundation

class MDDeviceInfoModel : Codable{
    var list: [MDDeviceLoginLogModel]?
    var mobileDownloadUrl: String?
    var platforms: [String]?
}

class MDDeviceLoginLogModel: Codable {
    var brand: String?
    var lastLoginTime: Int?
    var lastUseTime: Int?
    var model: String?
    var platform: String?
    var uuid: String?
}
