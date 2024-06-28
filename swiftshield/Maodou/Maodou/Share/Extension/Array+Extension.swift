//
//  Array+Extension.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//

import Foundation

extension Array {

    func convertToString() -> String? {
        //首先判断能不能转换
        if (!JSONSerialization.isValidJSONObject(self)) {
            Log.warning("format error")
            return nil
        }
        guard let data: Data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        let str = String(data: data, encoding: .utf8)
        return str
    }
}
