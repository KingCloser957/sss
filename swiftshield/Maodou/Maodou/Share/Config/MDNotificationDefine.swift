//
//  OONotificationDefine.swift
//  Orchid
//
//  Created by huangrui on 2022/8/11.
//  所有的通知name宏定义

import Foundation

public func addNotification(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
    NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
}

public func postNotification(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
    NotificationCenter.default.post(name: aName, object: anObject, userInfo: aUserInfo)
}

let kAnonySignSuccessNotification = "kAnonySignSuccessNotification"

let kPopToSettingVcNotification = "kPopToSettingVcNotification"

let kGetRemoteConfigSuccessNotification = "kGetRemoteConfigSuccessNotification"

let kExChangeLoginSuccessNotification = "kExChangeLoginSuccessNotification"
