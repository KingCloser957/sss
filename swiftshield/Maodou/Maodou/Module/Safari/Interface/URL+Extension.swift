//
//  URL+Extension.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import Foundation

extension URL {
    
    static let blank = URL(string: "about:blank")!
    static let `default` = URL(string: "https://www.baidu.com")!
    static var defaultUserAgent = "" {
        didSet {
            var uaparts = defaultUserAgent.components(separatedBy: " ")
            let osv = UIDevice.current.systemVersion.components(separatedBy: ".")
            let index = (uaparts.endIndex) - 1
            uaparts.insert("Version/\(osv.first ?? "0").0", at: index)
            
            for p in uaparts {
                if p.contains("AppleWebKit/") {
                    uaparts.append(p.replacingOccurrences(of: "AppleWebKit", with: "Safari"))
                    break
                }
            }
            defaultUserAgent = uaparts.joined(separator: " ")
        }
    }
}

