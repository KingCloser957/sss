//
//  OONetEncrptParam.swift
//  Orchid
//
//  Created by huangrui on 2022/8/25.
//

import UIKit
       
class MDNetEncrptParam: NSObject,NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(self.timeStamps, forKey: "timeStamps")
        coder.encode(self.unKey, forKey: "unKey")
    }
    
    required init?(coder: NSCoder) {
        self.timeStamps = coder.decodeObject(forKey: "timeStamps") as! Double
        self.unKey = coder.decodeObject(forKey: "unKey") as? String
    }
    
    var unKey:String?
    var timeStamps:Double = NSDate().timeIntervalSince1970
    var encryptResp:Int = 1
    var unNonce:String = ""
    var unTimestamp:String = ""
    var signData:String = ""
    var encryptData:String?
    var skv:String = "SK_1"
    var dataSkv:String = "DATA_SK_1"
    
    override init() {
        super.init()
        self.timeStamps = NSDate().timeIntervalSince1970
        self.skv = "SK_1"
        self.dataSkv = "DATA_SK_1"
        self.encryptResp = 1
        self.signData = getSignData()
        self.unNonce = getUnnoce()
        self.unTimestamp = getUnTimestamp()
    }
    
    private func getRandomStringOfLength(length: Int) -> String {
        var ranStr = ""
        let characters = MDNetEncrptParam.getCharacters()
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            let start = characters.index(characters.startIndex, offsetBy: index)
            let end = characters.index(characters.startIndex, offsetBy: index)
            ranStr.append(contentsOf: characters[start...end])
        }
        return ranStr
    }
    
    private func getUnnoce() -> String {
        return String(format: "%10ld", self.timeStamps) + "-" + self.getRandomStringOfLength(length: 10)
    }
    
    private func getUnTimestamp() -> String {
        return String(format: "%10ld", self.timeStamps)
    }
    
    private func getSignData() -> String {
        let dict = ["un_timestamp": getUnTimestamp(),
                    "un_nonce": getUnnoce()
                    ]
        if let json = dict.convertToString(), let encrpty_json = MDAES256.encrypt("34786598a2205b50e80728458798635d", json) {
            return encrpty_json
        }
        return ""
    }
    
    private class func getCharacters() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return characters
    }
    
    private func isExpired() -> Bool {
        let nowStamp = NSDate().timeIntervalSince1970
        if nowStamp - self.timeStamps < 60 * 60 {
            return false
        } else {
            return true
        }
    }
    
    public func cheakNeedRefreshUnKey() -> Bool {
        guard self.unKey != nil else {
            return true
        }
        if self.isExpired() {
            return true
        }
        return false
    }
}
