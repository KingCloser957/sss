//
//  SSCrypto.swift
//  StarSpeedBrowser
//
//  Created by 李白 on 2022/1/5.
//

import Foundation
import CryptoSwift

final class MDAES256 : NSObject {
    //偏移量
    private static let iv:Array<UInt8> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0]

    @objc class func encrypt(_ key:String, _ plainText:String?)->String?{
        guard let plainText = plainText else {
            return nil
        }

        //key值转化为32位hash
        let digest = Digest.sha256(key.bytes)

        let aes = try? AES(key: digest, blockMode: CBC.init(iv: iv))
        guard let aes = aes else { return nil}

        let encrypted = try? plainText.encryptToBase64(cipher: aes)
        return encrypted
    }

    @objc class func decrypt(_ key:String, _ encryptedText:String?)->String?{
        guard let encryptedText = encryptedText else {
            return nil
        }
        //key值转化为32位hash
        let digest = Digest.sha256(key.bytes)

        let aes = try? AES(key: digest, blockMode: CBC.init(iv: iv))
        guard let aes = aes else { return nil}

        let decrypted = try? encryptedText.decryptBase64(cipher: aes)
        guard let decrypted = decrypted else { return nil}

        let content = String(data: Data(decrypted), encoding: .utf8)
        return content
    }
    
}

final class SSMD5 : NSObject {

    @objc class func encrypt(_ plainText: String) -> String{
        return plainText.md5()
    }
}
