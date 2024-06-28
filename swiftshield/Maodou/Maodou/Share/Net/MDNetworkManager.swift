//
//  MKNetworkTool.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//

import Foundation
import AFNetworking
import UIKit

enum HTTPRequestType {
    case GET
    case POST
}

let SECKEY = "34786598a2205b50e80728458798635d"

class MDNetworkManager {

    static let share = MDNetworkManager()

    let manager = AFHTTPSessionManager()

    init() {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json,text/html", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("application/json;text/html;charset=utf-8", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.timeoutInterval = 15
        manager.responseSerializer = AFHTTPResponseSerializer()
    }

    class func request(method: HTTPRequestType, url: String, params: [String: Any]? = nil, needDecrypt: Bool = true, finishedCallback : ((_ results : Any?, _ error: Error?) -> ())?) {
        let success = { (tasks: URLSessionDataTask, json: Any) ->() in
            let obj = String(data: json as! Data, encoding: .utf8)
            if needDecrypt {
                guard let dataStr = MDAES256.decrypt(SECKEY, obj)?.convertToDictionary() else {
                    if finishedCallback != nil {
                        finishedCallback!(json, nil)
                    }
                    return
                }
                let exception = showExceptionView(dataStr)
                if exception {

                }
                if finishedCallback != nil {
                    finishedCallback!(dataStr, nil)
                }
            } else {
                if finishedCallback != nil {
                    finishedCallback!(json, nil)
                }
            }
        }
        let failure = { (tasks: URLSessionDataTask?, error:Error) ->() in
            if finishedCallback != nil {
                finishedCallback!(nil,error)
            }
        }

        let newParams = MDNetworkManager.generateParameters(params)
        let encrpParams = MDNetParamManager.shareInstance().encrptData(newParams)
        if method == .GET {
            share.manager.get(url,
                              parameters: encrpParams,
                              headers: self.simplyfyCommonHeader(),
                              progress: nil,
                              success: success,
                              failure: failure)
        }else {
            share.manager.post(url,
                               parameters: encrpParams,
                               headers: self.simplyfyCommonHeader(),
                               progress: nil,
                               success: success,
                               failure: failure)
        }
    }

    class func uploadImage(_ url: String, _ images: [UIImage], params: [String: Any]? = nil, needDecrypt: Bool = true, finishedCallback : @escaping (_ results : Any?, _ error: Error?) -> ()) {
        let success = { (tasks: URLSessionDataTask, json: Any) ->() in
            let obj = String(data: json as! Data, encoding: .utf8)
            if needDecrypt {
                guard let dataStr = MDAES256.decrypt(SECKEY, obj)?.convertToDictionary() else {
                    return
                }
                finishedCallback(dataStr, nil)
            } else {
                guard let json = (json as? String)?.convertToDictionary() else { return }
                finishedCallback(json, nil)
            }
        }
        let failure = { (tasks: URLSessionDataTask?, error:Error) ->() in
            finishedCallback(nil,error)
        }
        let newParams = MDNetworkManager.generateParameters(params)
        let encrpParams = MDNetParamManager.shareInstance().encrptData(newParams)
        let task = share.manager.post(url,
                                      parameters: encrpParams,
                                      headers: self.simplyfyCommonHeader()) { formData in
            for obj in images {
                if let data = obj.compressImageOnlength(maxLength: 500) {
                    let imageName = String(format: "%lld.jpeg", NSDate().timeIntervalSince1970)
                    formData.appendPart(withFileData: data,
                                        name: "file",
                                        fileName: imageName,
                                        mimeType: "image/jpeg")
                } else {
                    let error = NSError(domain: "",
                                        code: -10087,
                                        userInfo: ["message": "image compress faile"])
                    finishedCallback(nil, error)
                    return
                }
            }
        } progress: { _ in

        } success: { task, data in
            success(task, data as Any)
        } failure: { task, error in
            failure(task, error)
        }
        task?.resume()
    }

    static func uploadData(urlString: String,
                           data: Data,
                           finishedCallback : ((_ results : Any?, _ error: Error?) -> ())?) {
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        let request = try? AFHTTPRequestSerializer().request(withMethod: "POST", urlString: urlString, parameters: nil)
        request?.timeoutInterval = 10
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.httpBody = data
        for (key,value) in self.simplyfyCommonHeader() {
            request?.setValue(value, forHTTPHeaderField: key)
        }
        let responseSerializer = AFHTTPResponseSerializer()
        responseSerializer.acceptableContentTypes = NSSet(set: ["application/json","text/html","text/json","text/javascript","text/plain"]) as? Set<String>
        manager.responseSerializer = responseSerializer;
        manager.dataTask(with: request! as URLRequest, uploadProgress: nil, downloadProgress: nil) { response, responseObject, error in
            guard let responseObject = responseObject else {
                if finishedCallback != nil { finishedCallback!(nil,error) }
                return
            }
            guard let value = String(data: responseObject as! Data, encoding: .utf8) else {
                if finishedCallback != nil { finishedCallback!(nil,error)}
                return
            }
            guard let dataStr = MDAES256.decrypt(SECKEY,value) else {
                let error = NSError(domain: "", code: -10086, userInfo: ["message": "Decryption failure"])
                if finishedCallback != nil { finishedCallback!(nil, error)}
                return
            }
            guard let json = dataStr.convertToDictionary() else {
                if finishedCallback != nil { finishedCallback!(["content": dataStr], nil) }
                return
            }
            if finishedCallback != nil { finishedCallback!(json,nil) }
        }.resume()
    }
    
    public class func downloadData(_ type:HTTPRequestType, _ urlString: String, finishedCallback: @escaping (_ results : Data?, _ error: Error?) -> ()){
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        let request = try? AFHTTPRequestSerializer().request(withMethod: "GET", urlString: urlString, parameters: nil)
        request?.timeoutInterval = 10
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        for (key,value) in self.simplyfyCommonHeader() {
            request?.setValue(value, forHTTPHeaderField: key)
        }
        let responseSerializer = AFHTTPResponseSerializer()
        responseSerializer.acceptableContentTypes = NSSet(set: ["application/json","text/html","text/json","text/javascript","text/plain"]) as? Set<String>
        manager.responseSerializer = responseSerializer;
        manager.dataTask(with: request! as URLRequest, uploadProgress: nil, downloadProgress: nil) { response, responseObject, error in
            guard let responseObject = responseObject else {
                finishedCallback(nil,error)
                return
            }
            finishedCallback(responseObject as? Data, nil)
            return
            guard let value = String(data: responseObject as! Data, encoding: .utf8) else {
                finishedCallback(nil,error)
                return
            }
            guard let dataStr = MDAES256.decrypt(SECKEY,value) else {
                let error = NSError(domain: "", code: -10086, userInfo: ["message": "Decryption failure"])
                finishedCallback(nil, error)
                return
            }
//            guard let json = dataStr.convertToDictinary() else {
//                finishedCallback(["content": dataStr], nil)
//                return
//            }
//            finishedCallback(json,nil)
        }.resume()
    }

    private class func simplyfyCommonHeader() -> [String:String] {
        let headers = NSMutableDictionary()
        if let token = getToken() {
            headers.setObject(token, forKey: "Authorization" as NSCopying)
        }
        var un_timestamp = ""
        un_timestamp = String(format: "%10ld", NSDate().timeIntervalSince1970)
        let un_nonce = un_timestamp + "-" + self.getRandomStringOfLength(length: 10)
        headers.setObject(un_timestamp, forKey: "un_timestamp" as NSCopying)
        headers.setObject(un_nonce, forKey: "un_nonce" as NSCopying)
        let dict = ["un_timestamp": un_timestamp,
                    "un_nonce": un_nonce
                    ]
        if let json = dict.convertToString(), let encrpty_json = MDAES256.encrypt(SECKEY, json) {
            headers.setObject(encrpty_json, forKey: "sign_data" as NSCopying)
        }
        let appInfo = MDAppInfo()
        headers.setObject(appInfo.app_channel, forKey: "channel_id" as NSCopying)
        headers.setObject("ios", forKey: "app_type" as NSCopying)
        headers.setObject(appInfo.app_version_number, forKey: "app_version" as NSCopying)
        headers.setObject(appInfo.app_version, forKey: "app_name" as NSCopying)
        headers.setObject("zh_CN", forKey: "language" as NSCopying)
        headers.setObject("v3", forKey: "api_version" as NSCopying)
        return headers as! [String : String]
    }

    private class func getToken() -> String? {
        let user = MDUserInfoManager.share.user()
        return user?.user?.apiToken
    }

    private class func getRandomStringOfLength(length: Int) -> String {
        var ranStr = ""
        let characters = getCharacters()
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            let start = characters.index(characters.startIndex, offsetBy: index)
            let end = characters.index(characters.startIndex, offsetBy: index)
            ranStr.append(contentsOf: characters[start...end])
        }
        return ranStr
    }

    private class func getCharacters() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return characters
    }

    open class func generateParameters(_ customHeader:[String: Any]?) -> [String: Any]? {
        guard var param = MDCoderTool.toDict(MDAppInfo()) else {
            return customHeader
        }
        guard let customHeader = customHeader else {
           return param
        }
        for (key, value) in customHeader {
            param[key] = value
        }
        return param
    }

    static func showExceptionView(_ json: [String: Any]) -> Bool {
        if isShowExceptionView {
            return false
        }
        if let code = json["error_code"] as? Int {
            if code == 101 {
                guard let window = UIApplication.shared.windows.last else {
                    return false
                }
                let view = MDAlertView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
                view.contentView.backgroundColor = UIColor.hexColor(0x2D3343)
                view.contentView.layer.cornerRadius = 21
                view.titleLab.text = "登出提示"
                view.tipLab.text = "您的账户已在其他设备上登录，如非本人操作请检查密码是否泄漏。"
                view.cancelBtn.setTitle("知道了", for: .normal)
                view.confirmBtn.setTitle("重新登录", for: .normal)
                view.cancelBlock = {
                    UserDefaults.standard.setValue(true, forKey: "kExceptionGotIt")
                    UserDefaults.standard.synchronize()
                    view.dismiss()
                    exit(0)
                }
                view.confirmBlock = {
                    isShowExceptionView = false
//                    let appdelegate = UIApplication.shared.delegate as? AppDelegate
//                    appdelegate?.logout()
                }
                window.addSubview(view)
                isShowExceptionView = true
            }
        }
        return false
    }
    
    static func observerNetConnectionState(_ completion:@escaping (MKNetState) -> (Void)) {
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange {  status in
            print("网络状态: \(status)")
            if status == .notReachable { // 无网络
                completion(.disconnect)
            } else { // 其他
                completion(.connect)
            }
        }
    }
}

