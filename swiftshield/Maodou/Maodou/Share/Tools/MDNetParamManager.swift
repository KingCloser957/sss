//
//  OONetParamManager.swift
//  Orchid
//
//  Created by huangrui on 2022/8/25.
//

import UIKit

class MDNetParamManager: NSObject {
    
    let OOKeyPath = "OONetKeyPath"
    
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("Maodou.achiriver.data")
    
    var unKey:String?
    
    var finishUnkeyQuery:Bool = false
    
    static private let shared = MDNetParamManager()
    
    public class func shareInstance() -> MDNetParamManager {
        return shared
    }
    
    override init() {
        super.init()
    }
    
    public func encrptData(_ params:[String:Any]? = nil) -> [String:Any] {
        guard let params = params else {
            return [:]
        }
        guard let jsonString = params.convertToString() else { return params }
        guard let encrptData = MDAES256.encrypt(SECKEY, jsonString) else { return params}
        let encrpModel = MDNetEncrptParam()
        return ["encrypt_resp": encrpModel.encryptResp,
                "un_nonce": encrpModel.unNonce,
                "un_timestamp": encrpModel.unTimestamp,
                "sign_data": encrpModel.signData,
                "encrypt_data":encrptData,
//                "un_key": unkey,
                "skv": encrpModel.skv,
                "data_skv": encrpModel.dataSkv
        ]
    }
    
//    func addCacheData(with encrptParam:OONetEncrptParam) {
//        guard encrptParam == encrptParam else { return }
//        guard encrptParam.unKey != nil else { return }
//        do {
//            var data = Data()
//            if #available(iOS 11.0, *) {
//                data = try! NSKeyedArchiver.archivedData(withRootObject: encrptParam, requiringSecureCoding: true)
//            } else {
//                data = try! NSKeyedArchiver.archivedData(withRootObject: encrptParam)
//            }
//            do {
//                try? data.write(to: URL.init(fileURLWithPath: filePath!))
//            } catch  {
//                OOLog("写入沙河异常")
//            }
//        } catch  {
//            OOLog("归档异常")
//        }
//    }
    
//    func getCacheData() -> OONetEncrptParam? {
//        do {
//            guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath!)) else { return nil }
//            do {
//                let model = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
//                return model as? OONetEncrptParam
//            } catch  {
//                return nil
//                OOLog("解挡异常")
//            }
//        } catch  {
//            return nil
//            OOLog("解挡异常")
//        }
//    }
}
