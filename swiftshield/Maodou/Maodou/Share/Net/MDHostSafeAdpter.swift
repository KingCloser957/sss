//
//  MKHostSafeAdpter.swift
//  MonkeyKing
//
//  Created by huangrui on 2023/3/29.
//

import UIKit

var hasHost = false
var errorCount = 0
var finishCount = 0

class MDHostSafeAdpter: NSObject {
    
    static let safeHostKey = "kSafeHostKey"

//    #if DEBUG
    static let hosts: [String] = [ "01msxs.com",
                                   "02msxg.com",
                                   "02msxg.com"
                                  ]
//    #else
    /*
    static let hosts: [String] =  [ "apigame01.com",
                                    "apigame02.com",
                                    "xyworld01.com",
                                    "yagu01.com",
                                    "xsllq1.com"]*/
//    #endif
    static let kGithubUrl = "https://raw.githubusercontent.com/ywqado12/xhsos/main/README.md"
    static let kGiteeUrl = "https://gitee.com/ywqado12/xhsos/raw/master/README.md"
    static let kJsonUrl = "http://106.52.42.23:51200/xhdomain.json"
    static var randomHosts: [String] = []
    static var preKey = "sz1"
    static let port = 50100

    static let queue = DispatchQueue(label: "com.safehost.queue")

    static func startCheckHostSafe(_ comppltion:@escaping (String) -> (Void)) {
//        #if DEBUG
//            comppltion("https://sz1.01msxs.com:50100")
//            comppltion("https://sz1.mfenfa.com:50100")
//            return
//        #endif
        createRandomHosts() //随机数组
        if let cacheHost = UserDefaults.standard.value(forKey: safeHostKey) as? String {
            pingHostURL(cacheHost) { host, error in
                if host != nil {
                    hasHost = true
                    comppltion(host!)
                    return
                } else {
                    let arr = randomHosts.filter { str in
                        return str != cacheHost
                    }
                    let newArr = arr.map { str in
                        return "https://\(preKey).\(str):\(port)"
                    }
                    hasHost = false
                    errorCount = 0
                    finishCount = newArr.count
                    for i in 0..<newArr.count {
                        pingHostURL(newArr[i]) { (host, error) in
                            if error != nil {
                                errorCount += 1
                            }
                            debugPrint("errorCount: \(errorCount) --- \(finishCount)" )
                            if errorCount == finishCount {
                                requestGithubReadme(comppltion)
                                return
                            }

                            if host != nil {
                                hasHost = true
                                comppltion(host!)
                                return
                            }
                        }
                    }
                }
            }

        } else {
            let newHosts = randomHosts.map { host in
                return "https://\(preKey).\(host):\(port)"
            }

            finishCount = 3
            errorCount = 0
            hasHost = false

            for i in 0..<3 {
                pingHostURL(newHosts[i]) { (host, error) in
                    if error != nil {
                        errorCount += 1
                    }
                    debugPrint(" step 1 -- errorCount: \(errorCount) --- \(finishCount) ---- \(hasHost)" )
                    if errorCount == finishCount {
                        finishCount = 2
                        errorCount = 0
                        hasHost = false
                        for i in 3..<randomHosts.count {
                            pingHostURL(newHosts[i]) { (host, error) in
                                if error != nil {
                                    errorCount += 1
                                }
                                debugPrint("step 2 --- errorCount: \(errorCount) --- \(finishCount) --- \(hasHost)" )
                                if errorCount == finishCount {
                                    requestGithubReadme(comppltion)
                                    return
                                }
                                queue.async {
                                    if host != nil && !hasHost {
                                        comppltion(host!)
                                        saveSafeHost(host!)
                                        hasHost = true
                                    }
                                }
                            }
                        }
                        return
                    }
                    queue.async {
                        if host != nil && !hasHost {
                            comppltion(host!)
                            saveSafeHost(host!)
                            hasHost = true
                        }
                    }
                }
            }

        }
    }

    static func saveSafeHost(_ url: String) {
        UserDefaults.standard.setValue(url, forKey: safeHostKey)
        UserDefaults.standard.synchronize()
    }

    static func fetchSafeHost() -> String? {
        guard let url = UserDefaults.standard.value(forKey: safeHostKey) as? String else {
            return nil
        }
        return url
    }

    static func requestGiteeReadme(_ comppltion:@escaping (String) -> (Void)) {
        guard let url = URL(string: kGiteeUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = TimeInterval(5)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            let dataStr = String(data: data, encoding: .utf8)!.trimmingCharacters(in: CharacterSet.newlines)
            guard let content = MDAES256.decrypt(SECKEY, dataStr) else {
                return
            }
            debugPrint(content)
            let arr = content.split(separator: ",")
            let newArr = arr.map { str in
                return "https://\(preKey).\(str):\(port)"
            }
            finishCount = newArr.count
            errorCount = 0
            hasHost = false
            debugPrint(newArr)
            for i in 0..<newArr.count {
                pingHostURL(newArr[i]) { host, error in
                    if error != nil {
                        errorCount += 1
                    }
                    debugPrint("errorCount: \(errorCount) --- \(finishCount) -- \(newArr[i])" )
                    if errorCount == finishCount {
//                        let finalHost = createHost()
//                        comppltion(finalHost)
                        requestGithubReadme(comppltion)
                        return
                    }
                    queue.async {
                        if host != nil && !hasHost {
                            comppltion(host!)
                            saveSafeHost(host!)
                            hasHost = true
                        }
                    }
                }
            }
        }
        task.resume()
    }

    static func requestGithubReadme(_ comppltion:@escaping (String) -> (Void)) {
        guard let url = URL(string: kGithubUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = TimeInterval(5)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            let dataStr = String(data: data, encoding: .utf8)!.trimmingCharacters(in: CharacterSet.newlines)
            guard let content = MDAES256.decrypt(SECKEY, dataStr) else {
                return
            }
            debugPrint(content)
            let arr = content.split(separator: ",")
            let newArr = arr.map { str in
                return "https://\(preKey).\(str):\(port)"
            }
            finishCount = newArr.count
            errorCount = 0
            hasHost = false
            debugPrint(newArr)
            for i in 0..<newArr.count {
                pingHostURL(newArr[i]) { host, error in
                    if error != nil {
                        errorCount += 1
                    }
                    debugPrint("errorCount: \(errorCount) --- \(finishCount) -- \(newArr[i])" )
                    if errorCount == finishCount {
//                        let finalHost = createHost()
//                        comppltion(finalHost)
                        requestJson(comppltion)
                        return
                    }
                    queue.async {
                        if host != nil && !hasHost {
                            comppltion(host!)
                            saveSafeHost(host!)
                            hasHost = true
                        }
                    }
                }
            }
        }
        task.resume()
    }

    static func requestJson(_ comppltion:@escaping (String) -> (Void)) {
        guard let url = URL(string: kJsonUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = TimeInterval(5)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            let dataStr = String(data: data, encoding: .utf8)!.trimmingCharacters(in: CharacterSet.newlines)
            guard let content = MDAES256.decrypt(SECKEY, dataStr) else {
                return
            }
            debugPrint(content)
            let arr = content.split(separator: ",")
            let newArr = arr.map { str in
                return "https://\(preKey).\(str):\(port)"
            }
            finishCount = newArr.count
            errorCount = 0
            hasHost = false
            debugPrint(newArr)
            for i in 0..<newArr.count {
                pingHostURL(newArr[i]) { host, error in
                    if error != nil {
                        errorCount += 1
                    }
                    debugPrint("errorCount: \(errorCount) --- \(finishCount) -- \(newArr[i])" )
                    if errorCount == finishCount {
                        let finalHost = createHost()
                        comppltion(finalHost)
                        return
                    }
                    queue.async {
                        if host != nil && !hasHost {
                            comppltion(host!)
                            saveSafeHost(host!)
                            hasHost = true
                        }
                    }
                }
            }
        }
        task.resume()
    }

    static func createRandomHosts() {
        if !randomHosts.isEmpty {
            randomHosts.removeAll()
        }
        var newHost = hosts
        for _ in 0..<hosts.count {
            let random = Int.random(in: 0..<newHost.count)
            randomHosts.append(newHost[random])
            newHost.remove(at: random)
        }
        debugPrint(randomHosts)
    }

    static func pingHostURL(_ url: String, _ timeout: Int = 5 , completion:@escaping (String? , Error?) -> (Void)) {
        var urlStr = url.trimmingCharacters(in: CharacterSet.whitespaces)
        urlStr = urlStr.trimmingCharacters(in: CharacterSet.newlines)
        guard let candidate = URL(string: urlStr) else {
            return
        }
        var request = URLRequest(url: candidate)
        request.httpMethod = "HEAD"
        request.timeoutInterval = TimeInterval(timeout)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if error == nil {
                completion(url, error)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }

    static func networkStatus(completion:@escaping (Bool) -> Void) {
        let arr = ["https://www.baidu.com", "https://www.google.com"]
        errorCount = 0
        finishCount = arr.count
        for i in 0..<arr.count {
            pingHostURL(arr[i]) { host, error in
                if error != nil {
                    errorCount += 1
                }
                debugPrint("errorCount: \(errorCount) --- \(finishCount) -- \(arr[i])" )
                if errorCount == finishCount {
                    completion(true)
                    return
                }
                if hasHost {
                    return
                }
                if host != nil {
                    hasHost = true
                    completion(false)
                }
            }
        }
    }

    static func createHost() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let year = formatter.string(from: date)
        let fixed = "01023590000ABCDEFGHI"
        let baseStr = year + fixed
        guard let base64Str = baseStr.encodBase64() else {
            return "https://" + "MjAyMjAxMD.com:\(port)"
        }
        if base64Str.count < 10 {
            return "https://" + "MjAyMjAxMD.com:\(port)"
        }
        let index = base64Str.index(base64Str.startIndex, offsetBy: 10)
        let host = String(base64Str[..<index])
        return "https://" + host + ".com:\(port)"
    }
}
