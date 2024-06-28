//
//  SSAppinfoHelper.swift
//  StarSpeedBrowser
//
//  Created by huangrui on 2022/2/18.
//

import UIKit

class MDAppinfoHelper: NSObject {
    
    public static var applicationBundle: Bundle {
        let bundle = Bundle.main
        switch bundle.bundleURL.pathExtension {
        case "app":
            return bundle
        case "appex":
            // .../Client.app/PlugIns/SendTo.appex
            return Bundle(url: bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent())!
        default:
            fatalError("Unable to get application Bundle (Bundle.main.bundlePath=\(bundle.bundlePath))")
        }
    }

    @objc func getAppChanel() -> String {
//        let appInfo = MDAppInfo()
//        return appInfo.app_channel
        return ""
    }
    
    @objc func getUUID() -> String {
        return MDUUIDHelper.createUUID() ?? ""
    }
    
    @objc func getIdentifier() -> String {
        return Bundle.main.bundleIdentifier!
    }
    
    @objc func getApp_version_number() -> String {
        let appInfo = MDAppInfo()
        return appInfo.app_version
    }
    
    @objc class func getConfigKey() -> String {
        let configKey = applicationBundle.object(forInfoDictionaryKey: "CONFIG_KEY") as! String
        return configKey
    }
    
    @objc class func getConfigHost() -> String {
        let host = applicationBundle.object(forInfoDictionaryKey:  "CONFIG_HOST") as! String
        return host
    }
    
    @objc class func getAppVersion() -> String {
        let version = applicationBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return version
    }
    
    @objc class func getAgent_id() -> String {
//        let appInfo = MDAppInfo()
//        return appInfo.agent_id
        return ""
    }
    
    @objc class func getUserName() -> String {
        return MDUserInfoManager.share.user()?.getAccountName() ?? ""
    }
}
