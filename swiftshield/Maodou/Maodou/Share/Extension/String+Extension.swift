//
//  String+Extension.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//

import Foundation

extension String {

    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String: Any]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    //验证邮箱
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }

    //密码正则  8-16位字母和数字组合
    func validatePasswordRuler() -> Bool {
        let passwordRule = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }

    subscript(_ indexs: ClosedRange<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex...endIndex])
    }

    subscript(_ indexs: Range<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex..<endIndex])
    }

    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex...endIndex])
    }

    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        return String(self[beginIndex..<endIndex])
    }

    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    var ipAddress: String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }

/// 判断是不是Emoji
    ///
    /// - Returns: true false
    func containsEmoji()->Bool{
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F:
                return true
            default:
                continue
            }
        }

        return false
    }

/// 判断是不是Emoji
    ///
    /// - Returns: true false
    func hasEmoji()->Bool {

        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@",pattern)
        return pred.evaluate(with: self)
    }

/// 判断是不是九宫格
    ///
    /// - Returns: true false
    func isNineKeyBoard()->Bool{
        let other : NSString = "➋➌➍➎➏➐➑➒"
        let len = self.count
        for i in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }

        return true
    }


    /// 然后是去除字符串中的表情
    ///
    /// - Parameter text: text
    func disable_emoji(text : NSString)->String{
        do {
            let regex = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive)

            let modifiedString = regex.stringByReplacingMatches(in: text as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.length), withTemplate: "")

            return modifiedString
        } catch {
            print(error)
        }
        return ""
    }
}


extension String {
    //Base64编码
    func encodBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //Base64解码
    func decodeBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func convertToDictinary() -> [String: Any]? {
        let data = data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
    
    func convertToArray() -> Array<Any>? {
        let data = data(using: String.Encoding.utf8)
        if let array = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Any> {
            return array
        }
        return nil
    }
    
    public func localizable(from table: String = "Localizable") -> String {
        guard let language = MDLocalized.shareInstance().currentLanguage() else {
            return self
        }
//        let convertLanguage = convertServerLanguage(language)
        guard let path = Bundle.main.path(forResource: "\(language)", ofType: "lproj") else {
            return self
        }
        guard let text = Bundle(path: path)?.localizedString(forKey: self, value: nil, table: table) else {
            return self
        }
        return text
    }

    func convertServerLanguage() -> String {
        let language = MDLocalized.shareInstance().currentLanguage()
        switch language {
        case "zh-Hans":
            return "zh_CN"
        case "zh-Hant":
            return "zh_TW"
        case "ko":
            return "ko_KR"
        case "ja":
            return "ja_JP"
        case "fr":
            return "fr_FR"
        case "es":
            return "es_ES"
        case "de":
            return "de_DE"
        case "it":
            return "it_IT"
        case "ru":
            return "ru_RU"
        case "ar":
            return "ar_US"
        default:
            return "en_US"
        }
    }
    
    public func flip2String(_ string:String) -> String {
        let charArray = Array(string)
        let reversedArray = charArray.reversed()
        let reversedString = String(reversedArray)
        return reversedString
    }
}


extension TimeInterval {
    var hourMinuteSecond: String {
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    
    var minuteSecond: String {
        return String(format: "%02d:%02d", minute, second)
    }
    
    var hour: Int {
        return Int((self / 3600).truncatingRemainder(dividingBy: 3600))
    }
    
    var minute: Int {
        return Int((self / 60).truncatingRemainder(dividingBy: 60))
    }
    
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
}
