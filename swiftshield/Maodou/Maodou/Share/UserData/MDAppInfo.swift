//
//  MDAppInfo.swift
//  Maodou
//
//  Created by huangrui on 2024/5/11.
//

import Foundation
import UIKit

struct MDAppInfo: Codable {
    
    var device_uuid = MDUUIDHelper.createUUID()
    var uuid = MDUUIDHelper.createUUID()
    var vpn_key = "c6447788-6a83-42f6-878c-61eea6bd53d6"
    var project_name = "heather"
    var agent_id = PRODUCT_CHANNEL
    var app_channel = PRODUCT_CHANNEL
    var platform = "ios"
    var device_os = "ios"
    var device_brand = UIDevice.current.model
    var app_version_number = API_VERSION
    var app_version = "heather"
    var device_model = MDAppInfo.getDeviceModle()
    var device_name = UIDevice.current.name
    var device_bundle = Bundle.main.bundleIdentifier
    var screen_size = getScreenSize()
    var physical_pixel = getPhysicalPixel()
    var inner_ip = String.init().ipAddress
    var device_system_language = getSystemLanguage()
    var current_time = Int(Date().timeIntervalSince1970)
    var install_time = getApplicationInstalTime()

//    var device_id = MDUUIDHelper.createUUID()
//    var device_type = 1
//    var app_version = API_VERSION
//    var accept_language  = getSystemLanguage()
//    var user_agent = "ios"
//    var device_model = MDAppInfo.getDeviceModle()
//    var send_date = Int(Date().timeIntervalSince1970)
//    var rand = Int(arc4random_uniform(899) + 100)
//    var sign = ""
//    var token = ""
//    var authorization = ""
//    var app_channel = PRODUCT_CHANNEL
//    var platform = "ios"
//    var device_os = "ios"
//    var device_brand = UIDevice.current.model
//    var app_version_number = API_VERSION
//    var current_time = Int(Date().timeIntervalSince1970)
//    var install_time = getApplicationInstalTime()
//
//    enum Codingkeys:String,CodingKey {
//        case device_id = "Device-ID"
//        case device_type = "Device-Type"
//        case app_version = "APP-version"
//        case accept_language = "Accept-Language"
//        case user_agent = "user-agent"
//        case device_model = "Device-Model"
//        case send_date = "send-date"
//        case rand
//        case app_channel
//        case platform
//        case device_os
//        case device_brand
//        case app_version_number
//        case current_time
//        case install_time
//    }

    static func getSystemLanguage() -> String {
//        let languages = Bundle.main.preferredLocalizations
//        guard let language = languages.first else {
//            return ""
//        }
//        return language
        return "zh_CN"
    }

    static func getDeviceModle() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        let path = Bundle.main.path(forResource: "modelList", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        guard let json = try? JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [String: String] else {
            return identifier
        }
        let value = json[identifier] ?? identifier
        return value
    }

    static func getScreenSize() -> String {
        let size = UIScreen.main.bounds.size
        let text = "\(size.width)*\(size.height)"
        return text
    }

    static func getPhysicalPixel() -> String {
        let scale = UIScreen.main.scale
        return "\(scale)"
    }
    
    static func getApplicationInstalTime() -> Int {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: documentsDirectory.path)
                if let creationDate = attributes[.creationDate] as? Date {
                    return Int(creationDate.timeIntervalSince1970)
                } else {
                    return Int(Date().timeIntervalSince1970)
                }
            } catch {
                return Int(Date().timeIntervalSince1970)
            }
        } else {
            return Int(Date().timeIntervalSince1970)
        }
    }
    
    //地区
    static func getlocaleIdentifier() -> String? {
        return NSLocale.current.regionCode
    }
}
