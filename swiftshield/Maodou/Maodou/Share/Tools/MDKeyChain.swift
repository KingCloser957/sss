//
//  SSKeyChain.swift
//  StarSpeedBrowser
//
//  Created by 李白 on 2021/12/31.
//

import UIKit

class MDKeyChain: NSObject {
    class func getKeyChainQuery(service:String) -> [String: Any] {
        return [kSecClass as String:kSecClassGenericPassword,       // item save type
                kSecAttrService as String:service,                  // item main key
                kSecAttrAccount as String:service,                  // item main key
                kSecAttrAccessible as String:kSecAttrAccessibleAfterFirstUnlock]    // degree of protection
    }

    // save uuid to keychian
    class func save(service:String, data:Any) {
        var keychainQuery = getKeyChainQuery(service: service)
        SecItemDelete(keychainQuery as CFDictionary)
        keychainQuery[kSecValueData as String] = NSKeyedArchiver.archivedData(withRootObject: data)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    // fet uuid from keychain
    class func load(service:String) -> Any? {
        var ret:Any?
        var keychainQuery = getKeyChainQuery(service: service)
        keychainQuery[kSecReturnData as String] = kCFBooleanTrue
        keychainQuery[kSecMatchLimit as String] = kSecMatchLimitOne
        var result:AnyObject?
        if SecItemCopyMatching(keychainQuery as CFDictionary, &result) == noErr {
            ret = NSKeyedUnarchiver.unarchiveObject(with: (result as? Data)!)
        }
        return ret
    }

    // delete uuid from keychain
    class func deleteKeyData(service:String) {
        let keychainQuery = getKeyChainQuery(service: service)
        SecItemDelete(keychainQuery as CFDictionary)
    }
}
