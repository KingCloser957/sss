//
//  MKUserInfoManager.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/13.
//

import Foundation

class MDUserInfoManager {

    static let share = MDUserInfoManager()

    open func save(_ info: [String: Any]) {
        var newInfo = info
        if let pwd = self.user()?.user?.password {
            newInfo["password"] = pwd
        }
        let jsonDecode = JSONDecoder()
        guard let obj = try? JSONSerialization.data(withJSONObject: newInfo, options: []) else {
            return
        }
        guard let userInfo = try? jsonDecode.decode(MDUserInfo.self, from: obj) else {
            return
        }
        let userTable = MDUserTable()
        guard let id = userInfo.user?.id, let json = newInfo.convertToString() else { return }
        userTable.insert(userId: id, info: json)
    }

    open func user() -> MDUserInfo? {
        let userTable = MDUserTable()
        return userTable.select()
    }
    
    open func isLogin()-> Bool{
        guard let user = self.user() else { return false }
        if user.user != nil && user.user?.apiToken != nil {
            return true
        }
        return false
    }
    
    open func userId() -> Int? {
        guard let user = self.user() else { return 0 }
        if user.user != nil && user.user?.id != nil {
            return user.user?.id
        }
        return 0
    }
    
    open func isVip() -> Bool {
        guard let user = self.user() else { return false }
        guard let sonUser = user.user else { return false }
        if sonUser.svipInvalidTime?.isEmpty == false || sonUser.vipInvalidTime?.isEmpty == false {
            return true
        }
        return false
    }

    open func clear() {
        let userTable = MDUserTable()
        userTable.delete()
    }

}
