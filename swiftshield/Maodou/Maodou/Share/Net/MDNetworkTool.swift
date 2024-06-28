//
//  MKNetworkTool.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/10.
//

import Foundation
import UIKit

class MDNetworkTool {

    typealias completionClouse = ((Any?, Error?) -> Void)

    //登录
    static func login(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.login.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }

    //注册并登录
    static func register(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.registers.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }

    //邮箱验证码
    static func emailValidateCode(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.send_email.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }

    //邮箱验证码
    static func phoneValidateCode(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.send_register_code.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }

    //找回密码
    static func getBackPassword(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.get_back_password.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }
    
    //节点列表
    static func nodeList(_ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.node_list.rawValue)
        MDNetworkManager.request(method: .GET, url: url, params: ["kind": 1]) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }
    
    //节点信息
    static func connectNode(_ params: [String: Any],_ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.nodes_connect.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }

    //公告
    static func notificationList(_ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.notificationList.rawValue)
        let param = ["kind":"0",
                     "app_version":"goku",
                     "agent_id":PRODUCT_CHANNEL,
                     "platform":"ios",
                     "app_version_number":API_VERSION,
        ]
        MDNetworkManager.request(method: .GET, url: url, params: param) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }
    
    static func getUserInfo(_ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.userInfo.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params:nil, finishedCallback: completion)
    }

    //绑定手机号或邮箱
    static func boundAccount(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.bound_account.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params, finishedCallback: completion)
    }

    //修改密码
    static func changePassword(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.update_password.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params, finishedCallback: completion)
    }

    //用户信息
    static func userInfo( _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.userInfo.rawValue)
        MDNetworkManager.request(method: .POST, url: url, finishedCallback: completion)
    }

    //消息列表
    static func messageList(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.messages.rawValue)
        MDNetworkManager.request(method: .GET, url: url, finishedCallback: completion)
    }

    //阅读消息
    static func readMessage(_ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.messages_read.rawValue)
        MDNetworkManager.request(method: .GET, url: url, params: params, finishedCallback: completion)
    }

    //用户设备信息
    static func devices(_ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.user_device.rawValue)
        MDNetworkManager.request(method: .GET, url: url, finishedCallback: completion)
    }

    //订单列表
    static func orderHistory( _ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.orderHistory.rawValue)
        MDNetworkManager.request(method: .GET, url: url, params: params, finishedCallback: completion)
    }

    //验证码校验
    static func validateCode( _ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.validate_code.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params, finishedCallback: completion)
    }

    //反馈
    static func feedback( _ params: [String: Any], images: [UIImage], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.create_feedbacks.rawValue)
        MDNetworkManager.uploadImage(url, images, params: params) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }

    //反馈详情
    static func feedbackDetail( _ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.feedback_record.rawValue)
        MDNetworkManager.request(method: .GET, url: url, params: params, finishedCallback: completion)
    }

    //反馈回复
    static func feedbackResend( _ params: [String: Any], images: [UIImage], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.feedback_resend.rawValue)
        MDNetworkManager.uploadImage(url, images, params: params) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }

    //反馈列表
    static func feedbackList( _ params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.feedback_list.rawValue)
        MDNetworkManager.request(method: .GET, url: url, params: params, finishedCallback: completion)
    }

    //产品列表
    static func products( kind: Int, _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.products.rawValue)
        let params = ["kind": kind]
        MDNetworkManager.request(method: .GET, url: url, params: params, finishedCallback: completion)
    }

    //创建订单
    static func creatOrder(params: [String: Any], _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.create_third_order.rawValue)
        MDNetworkManager.request(method: .POST, url: url, params: params, finishedCallback: completion)
    }

    //日志上报
    static func actionTrack(params: [String: Any]?, _ completion: completionClouse?) {
        guard let params = params else {
            return
        }
        let newParams = MDNetworkManager.generateParameters(params)
        guard let plainText = newParams?.convertToString() else { return }
        let encryParam = MDAES256.encrypt("86712786e2205b50e80721462334364d", plainText)
//        let timestamp = Date().timeIntervalSince1970
//            saveTrackEncryptText(encryParam, timestamp)
        guard let data = encryParam?.data(using: .utf8) else { return }
        let url = getEncyptPathUrl(MDNetURL.actionTrack.rawValue)
        MDNetworkManager.uploadData(urlString: url, data: data) { results, error in
            guard let completion = completion else { return }
            if let results = results as? [String: Any] {
                guard let success = results["success"] as? Bool else { return }
                if success {
                    if let data = results["data"] as? Bool {
                        if data == true {
                            completion("" , nil)
                        }
//                        deletTrack(timestamp)
                        return
                    }
                    if let data = results["data"] as? [String:Any] {
                        let dataStr = data.convertToString()
                        completion(dataStr, nil)
                        return
                    }
                    completion(nil , error)
                } else {
                    guard let _ = results["message"] as? String else { return }
                    completion(nil , error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    //更新推送token
    static func updateFcmToken(_ token: String, _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.fcm_token.rawValue)
        let params = ["fcm_token": token]
        MDNetworkManager.request(method: .GET, url: url, params: params, finishedCallback: completion)
    }
    
    //获取资源文件
    static func routerFiles(_ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.router_files.rawValue)
        MDNetworkManager.request(method: .POST, url: url, finishedCallback: completion)
    }
    
    static func downloadRouterFiles(url: String, _ completion:@escaping (Data?, Error?) -> Void) {
        MDNetworkManager.downloadData(.GET, url, finishedCallback: completion)
    }
    
    //获取globalSettings配置
    static func systemSetting(_ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.system_setting.rawValue)
        var parameters = ["appVersion": API_VERSION,
                          "appName": "orchid",
                          "pageType": "buypage",
                          "platform": "ios"
                         ] as [String: Any]
        if let userId = MDUserInfoManager.share.userId()  {
            parameters["userId"] = userId
        }
        MDNetworkManager.request(method: .GET, url: url, params: parameters, finishedCallback: completion)
    }
    
    //埋点批量
    static func actionTrackList() {
        let max = MDTrackTable.shared.fetchMaxTimeStamp()
        let list = MDTrackTable.shared.selectFaileDatas(max)
        if list.isEmpty {
            return
        }
        guard let plainText = list.convertToString() else { return }
        let encryParam = MDAES256.encrypt("86712786e2205b50e80721462334364d", plainText)
        guard let data = encryParam?.data(using: .utf8) else { return }
        let url = getEncyptPathUrl(MDNetURL.actionTrack.rawValue)
    
        MDNetworkManager.uploadData(urlString: url, data: data) { results, error in
            guard let results = results as? [String:Any] else { return}
            guard let success = results["success"] as? Int else { return }
              if success == 1 {
                  MDTrackTable.shared.deleteFailDatas(max)
              }
        }
    }
    
    //批量消息已读
    static func messagesRead( _ messageIdList: String, _ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.messages_read.rawValue)
        let parameters = ["messageId": messageIdList]
        MDNetworkManager.request(method: .GET, url: url, params: parameters, finishedCallback: completion)
    }
    
    static func logout(_ completion: completionClouse?) {
        let url = getEncyptPathUrl(MDNetURL.logout.rawValue)
        MDNetworkManager.request(method: .POST, url: url) { results, error in
            if completion != nil {
                completion!( results, error)
            }
        }
    }
    
}

extension MDNetworkTool {

    static func getEncyptPathUrl(_ path: String) -> String {
        let newPath = getEncryptPath(path)
        return kBaseHost + newPath
    }

    static func getEncryptPath(_ path: String) -> String {
        let timestamp = UInt(Date().timeIntervalSince1970)
        let newPath = "\(path)/\(timestamp)"
        guard let enPath = MDAES256.encrypt(HTTP_SECKEY, newPath) else {
            return path
        }
        debugPrint("\(path) ------ \(enPath)")
        return "/\(enPath)"
    }

}
