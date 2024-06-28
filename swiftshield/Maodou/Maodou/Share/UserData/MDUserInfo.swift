//
//  HHUserInfo.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/13.
//

import Foundation

class MDUserInfo: Codable {

    var kind: Int?
    var existNewMessage: Int?
    var proxySessionId: String?
    var user: MKUser?

    enum CodingKeys: String, CodingKey {
        case kind
        case existNewMessage = "exist_new_message"
        case proxySessionId = "proxy_session_id"
        case user
    }

    open func getAccountName() -> String {
        if let phone = user?.phone, let code = user?.regionCode, !phone.isEmpty {
            var phoneString = "\(code) "
            phoneString += "****"
            if phone.count > 4 {
                phoneString += phone.suffix(4)
            } else {
                phoneString += phone.suffix(phone.count - 1)
            }
            return phoneString
        }
        if let email = user?.emailAdress, !email.isEmpty {
            let arr = email.split(separator: "@")
            let header = String(arr.first ?? "")
            let hLength = header.count
            let newHeader = header[..<1]
            let emailString = newHeader + "****@" + (arr.last ?? "")
            return emailString
        }
        return user?.username ?? ""
    }

    open func getUserName() -> String {
        return user?.username ?? ""
    }
    
    open func getToken() -> String {
        return user?.apiToken ?? ""
    }

    open func getSafePhone() -> String {
        guard let phone = user?.phone, !phone.isEmpty, let code = user?.regionCode, !code.isEmpty else {
            return "SETTING_BINGACCOUNT_NOCK_MORE_FUNCTION".localizable()
        }
        var phoneString = "\(code) "
        phoneString += "****"
        if phone.count > 4 {
            phoneString += phone.suffix(4)
        } else {
            phoneString += phone.suffix(phone.count - 1)
        }
        return phoneString
    }

    open func getSafeEmail() -> String {
        guard let emailAdress = user?.emailAdress, !emailAdress.isEmpty else {
            return "SETTING_BINGACCOUNT_NOCK_MORE_FUNCTION".localizable()
        }
        let arr = emailAdress.split(separator: "@")
        let header = String(arr.first ?? "")
        let hLength = header.count
        let newHeader = header[..<(hLength-1)]
        let emailString = newHeader + "****@" + (arr.last ?? "")
        return emailString
    }
}

class MKUser: Codable {

    var id: Int?
    var subStatus: Int? //"订阅状态  0.未订阅、1. 订阅中、2.试用中、3.已退订 4.试用期退订
    var regionCode: String = "+86"
    var phone: String?
    var emailAdress: String?
    var vipInvalidTime: String?
    var apiToken: String?
    var channelId: String?
    var username: String?
    var shareUrl: String?
    var svipInvalidTime: String?
    var website: String?
    var inviteCode: String?
    var isVisitor: Int?
    var userType: UInt8?
    var userLevel: UInt8?
    var password: String?

    enum CodingKeys: String, CodingKey {
        case id
        case subStatus = "sub_status"
        case regionCode = "region_code"
        case phone
        case emailAdress = "email_address"
        case vipInvalidTime = "vip_invalid_time"
        case apiToken = "api_token"
        case channelId = "channel_id"
        case username = "username"
        case shareUrl = "share_url"
        case svipInvalidTime = "svip_invalid_time"
        case website
        case inviteCode = "invite_code"
        case isVisitor = "is_visitor"
        case userType = "user_type"
        case userLevel = "user_level"
        case password
    }
}


