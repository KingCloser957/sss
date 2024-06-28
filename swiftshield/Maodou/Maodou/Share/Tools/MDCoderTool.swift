//
//  MKCoderTool.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/23.
//

import Foundation

class MDCoderTool {
    static func toDict<T: Codable>(_ model: T) -> [String: Any]? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(model) else {
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        return json
    }

    static func toJson<T: Codable>(_ model: T) -> String? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(model) else {
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        return json.convertToString()
    }

    static func fromDict<T: Codable>( _ type: T.Type, _ dict: [String:Any]?) -> T? {
        guard let obj = try? JSONSerialization.data(withJSONObject: dict as Any, options: []) else {
            return nil
        }
        let jsonDecode = JSONDecoder()
        guard let model = try? jsonDecode.decode(type, from: obj) else {
            return nil
        }
        return model
    }

    static func fromJson<T: Codable>( _ type: T.Type, _ json: [String:Any]?) -> T? {
        guard let obj = try? JSONSerialization.data(withJSONObject: json as Any, options: []) else {
            return nil
        }
        let jsonDecode = JSONDecoder()
        guard let model = try? jsonDecode.decode(type, from: obj) else {
            return nil
        }
        return model
    }
}
