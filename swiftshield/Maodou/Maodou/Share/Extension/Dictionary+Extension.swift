//
//  Dictionary+Extension.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//

import Foundation

extension Dictionary {
    
    func convertToString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        let str = String(data: data, encoding: .utf8)
        return str
    }
}
