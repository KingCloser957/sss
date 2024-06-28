//
//  SSUUIDHelper.swift
//  StarSpeedBrowser
//
//  Created by 李白 on 2021/12/31.
//

import UIKit
import AudioToolbox

// 设备第一次安装的标记
private let keyAppMark = "com.maodou.mark"

final class MDUUIDHelper : NSObject {
    @objc class func createUUID() -> String? {
        var strUUID = MDKeyChain.load(service: keyAppMark)
        guard let strUUID = strUUID else {
            let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
            let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
            strUUID = (strRef! as String).replacingOccurrences(of: "-", with: "")
            MDKeyChain.save(service: keyAppMark, data: strUUID!)
            return strUUID as? String
        }
        return strUUID as? String
    }
}

private let keyUserList = "com.orchid.userList"

final class MDUserKeyChainCacheHelper : NSObject {
    static func clearUserList() {
        MDKeyChain.deleteKeyData(service: keyUserList)
    }
    static func clearUUid() {
        MDKeyChain.deleteKeyData(service: keyAppMark)
    }
    static func saveUser(_ info: [String: Any]?) {
        guard var info = info else {
            return
        }
        let timestamp = Date().timeIntervalSince1970
        info["updateTimeStamp"] = timestamp

        guard let userList: [[String: Any]] = fetchUserList() else {
            var newUserList: [[String: Any]] = []
            newUserList.append(info)
            if let data = try? JSONSerialization.data(withJSONObject: newUserList, options: []),
                let jsonStr = String(data: data, encoding: .utf8) {
                MDKeyChain.save(service: keyUserList, data: jsonStr)
            }
            return
        }

        var newUserList: [[String: Any]] = []
        var containInfo = false

        for dict in userList {
            if let preUser = dict["user"] as? [String: Any],
                let preId = preUser["id"] as? Int,
                let nextUser = info["user"] as? [String: Any],
                let nextId = nextUser["id"] as? Int {

                if preId == nextId {
                    newUserList.append(info)
                    containInfo = true
                } else {
                    newUserList.append(dict)
                }
            }
        }
        if !containInfo {
            newUserList.append(info)
        }
        debugPrint("钥匙串信息--------------------------开始")
        debugPrint(newUserList)
        debugPrint("钥匙串信息--------------------------结束")
        if let data = try? JSONSerialization.data(withJSONObject: newUserList, options: []),
            let jsonStr = String(data: data, encoding: .utf8) {
            MDKeyChain.save(service: keyUserList, data: jsonStr)
        }
    }

    static func fetchUserList() -> [[String: Any]]? {
        guard let userListStr = MDKeyChain.load(service: keyUserList) as? String, let data = userListStr.data(using: .utf8) else {
            return nil
        }
        guard let userList = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) else {
            return nil
        }
        return userList as? [[String: Any]]
    }

    static func fetchLatestUser() -> [String: Any]? {
        guard let userList = fetchUserList() else {
            return nil
        }
        var timestamp: TimeInterval = 0
        var latesUserInfo: [String: Any]?
        for dict in userList {
            if let time = dict["updateTimeStamp"] as? TimeInterval {
                if time > timestamp {
                    latesUserInfo = dict
                    timestamp = time
                }
            }
        }
        debugPrint("钥匙串信息最新用户--------------------------开始")
        debugPrint(latesUserInfo)
        debugPrint("钥匙串信息最新用户--------------------------结束")
        return latesUserInfo
    }

}
