//
//  MDWebsiteStorage.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WebKit

class MDWebsiteStorage {
    static let shared = MDWebsiteStorage()

    private static let allTypes = WKWebsiteDataStore.allWebsiteDataTypes()

    private static let allTypesButCookies: Set<String> = {
        var types = allTypes
        types.remove(WKWebsiteDataTypeCookies)

        return types
    }()


    private let store = WKWebsiteDataStore.default()
    
    private init() {
    }
    
    func cleanup() {
        store.httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                self.store.httpCookieStore.delete(cookie)
            }
        }
    }
}
