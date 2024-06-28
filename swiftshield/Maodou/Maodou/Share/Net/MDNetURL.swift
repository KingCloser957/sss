//
//  HLLNetURL.swift
// IMango
//
//  Created by isec on 2019/8/24.
//  Copyright © 2019 isec. All rights reserved.
//

import UIKit

enum MDNetURL: String {
//    case loginByDeviceId = "/api/v2/passport/auth/loginByDeviceId"
//    case login = "/api/v2/passport/auth/login"
//    case registers = "/api/v2/passport/auth/register"
//    case bindEmail = "/api/v2/user/bind/email"
//    case deleteAccount = "/api/v2/passport/auth/delete"
//    case logout = "/api/v2/passport/auth/logout"
//    case userInfo = "/api/v2/user/info"
//    case updatePassword = "/api/v2/passport/auth/pass-update"
//
//    case appSubscribe = "/api/v2/client/appSubscribe"
//    case appSubscribeGroup = "/api/v2/client/appSubscribeGroup"
//    case deviceList = "/api/v1/user/device/list"
//    case deleteDevice = "/api/v1/user/device/del"
//    case clientConnect = "/api/v2/client/connect"
    
    case login = "/api/client/society_v2/account/login"
    case registers = "/api/client/society_v2/account/register"
    case anonySign = "/api/client/society/anony/anony_sign"
    case userInfo = "/api/client/society_v2/account/info"
    
    case changePassword = "/api/client/v2/users/update_password"
    case nodesList = "/api/client/v2/nodes"
    case connet = "/api/client/v2/nodes/connect"
    case nodesRegions = "/api/client/v2/nodes/node_regions"
    case personalNodes = "/api/client/v2/nodes/proper_lines"
    case websites = "/api/client/v2/websites"
    case deletePersonalNode = "/api/client/v2/nodes/delete_proper_line"
    case routesConfig = "/api/client/v2/commons/routes"
    case getIPLocation = "/api/client/society_v2/commons/location"
    case addPersonalNode = "/api/client/v2/nodes/add_proper_line"
    case updatePersonalNodes = "/api/client/v2/nodes/update_proper_line"
    case connectionLog = "/api/client/v2/nodes/connection_log"
    case userStatus = "/api/client/v2/commons"
    case versionUpdate = "/api/client/v2/commons/update_app"
    case exclusiveNodeList  = "/api/client/v2/nodes/exclusive_node_regions"
    case exclusiveSwitch = "/api/client/v2/nodes/change_node_type"
    case exclusiveSelectNode = "/api/client/v2/nodes/distribute_exclusive_node"
    case exclusiveClose  = "/api/client/v2/nodes/close_node"
    case exclusiveLogout = "/api/client/v2/user_logout"
    case uploadUserInfo = "/api/strategy/client/v1/user_infos"
    case loadCer = "/api/client/v2/commons/load_ca"
    case notificationList = "/api/client/society_v2/notifications/list"
    case international_setting = "/api/client/society_v2/commons/international_setting"
    case bound_account = "/api/client/society_v2/registers/bound_account"
    case send_email = "/api/client/society_v2/registers/send_email"
    case send_register_code = "/api/client/society_v2/registers/send_register_code"
    case products = "/api/client/society_v2/products"
    case actionTrack = "/api/log/v1/client/actionTrack"
    case anony_cipher = "/api/client/society/anony/anony_cipher"
    case create_feedbacks = "/api/client/society_v2/users/create_feedbacks"
    case validate_code = "/api/client/society_v2/registers/auth_validate_code"
    case get_back_password = "/api/client/society_v2/users/get_back_password"
    case getUnKey = "/api/client/society_v2/commons/get_un_key"
    case create_third_order = "/api/client/society/orders/create_third_order"
    case auth_apple_token = "/api/client/society_v2/orders/auth_apple_token"
    case checkStatus = "/api/client/society_v2/activities/checkStatus"
    case routList = "/e10adc3949ba59abbe56e057f20f883e"
    case recoverBuy = "/api/client/society/orders/recoverBuy"
    case router_files = "/api/client/society_v2/commons/get_router_files"
    case nodes_connect = "/api/client/society_v2/nodes/connect"
    case beat_version = "/api/client/society_v2/commons/check_beat_version"
    case node_list = "/api/client/society_v2/nodes/node_list"
    case test_1 = "/api/client/society_v2/users/testempty"
    case test_2 = "/api/client/society_v2/users/testok"
    case system_setting = "/api/client/society_v2/static/system_setting"
    case appleSign = "/api/client/society/orders/appleSign"
    case resource_package_version = "/api/client/society_v2/commons/resource_package_version"
    case messages = "/api/client/society_v2/message/messages"
    case messages_read = "/api/client/society_v2/message/read"
    case fcm_token = "/api/client/society_v2/users/fcm_token"
    case user_device = "/api/client/society_v2/users/user_device"
    case feedback_list = "/api/client/society/users/feedback_list"
    case feedback_record = "/api/client/society/users/feedback/record"
    case feedback_resend = "/api/client/society/users/feedback/resend"
    case orderHistory = "/api/client/society_v2/orders/orderHistory"
    case update_password = "/api/client/society_v2/users/update_password"
    case logout = "/api/client/society_v2/account/logout"
}

extension MDNetURL{
    
    /*
     case loginByDeviceId = "/api/v2/passport/auth/loginByDeviceId"
     case login = "/api/v2/passport/auth/login"
     case registers = "/api/v2/passport/auth/register"
     case bindEmail = "/api/v2/user/bind/email"
     case deleteAccount = "/api/v2/passport/auth/delete"
     case logout = "/api/v2/passport/auth/logout"
     case userInfo = "/api/v2/user/info"
     
     case updatePassword = "/api/v2/passport/auth/pass-update"
     
     case appSubscribe = "/api/v2/client/appSubscribe"
     case appSubscribeGroup = "/api/v2/client/appSubscribeGroup"
     case deviceList = "/api/v1/user/device/list"
     case deleteDevice = "/api/v1/user/device/del"
     case clientConnect = "/api/v2/client/connect"
     */
    
    /// 请求的名称, 仅为方便查看log
    var debugDescription: String? {
        get{
            switch self {
//            case .loginByDeviceId:
//                return "用设备id登录"
//            case .login:
//                return "邮箱登陆"
//            case .registers:
//                return "邮箱注册"
//            case .bindEmail:
//                return "用户绑定邮箱"
//            case .deleteAccount:
//                return "注销账号"
//            case .logout:
//                return "登出"
//            case .userInfo:
//                return "个人基本信息"
//            case .updatePassword:
//                return "修改密码"
//            case .appSubscribe:
//                return "获取直连列表"
//            case .appSubscribeGroup:
//                return "获取直连节点分组列表"
//            case .deviceList:
//                return "用户设备列表"
//            case .deleteDevice:
//                return "用户设备删除"
//            case .clientConnect:
//                return "请求连接节点"
            case .updatePersonalNodes:
                return "更新专线请求"
            case .connectionLog:
                return "服务器连接日志请求"
            case .userStatus:
                return "检查用户状态请求"
            case .versionUpdate:
                return "版本更新"
            case .exclusiveNodeList:
                return "独占线路列表"
            case .exclusiveSwitch:
                return "开启/关闭独占线路"
            case .exclusiveSelectNode:
                return "选择独占区域(线路)"
            case .exclusiveClose:
                return "断开独占连接"
            case .exclusiveLogout:
                return "退出登录"
            case .uploadUserInfo:
                return "上传用户信息"
            case .loadCer:
                return "获取证书下载地址"
            case .userInfo:
                return "获取用户信息"
            case .notificationList:
                return "公告列表"
            case .international_setting:
                return "国际化设置"
            case .checkStatus:
                return "活动状态"
            case .recoverBuy:
                return "恢复购买"
            case .nodes_connect:
                return "线路连接"
            case .node_list:
                return "线路列表"
            case .system_setting:
                return "系统配置下载"
            case .orderHistory:
                return "订单记录"
            default:
                return "未知内容"
            }
        }
    }
    
    /// 请求是否需要token
    var isTokenNeeded: Bool {
        get{
            switch self {
            case .login, .versionUpdate, .exclusiveClose, .exclusiveLogout:
                return false
            default:
                return true
            }
        }
    }
}

