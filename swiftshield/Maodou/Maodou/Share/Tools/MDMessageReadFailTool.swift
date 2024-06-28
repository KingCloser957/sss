//
//  File.swift
//  Orchid
//
//  Created by 李白 on 2023/2/21.
//

import Foundation


class MDMessageReadFailTool {
    static let shared = MDMessageReadFailTool()
    var loading: Bool = false


    func uploadFailMessage() {
        let list = fetchFailMessages()
        if list.isEmpty {
            return
        }

        if loading {
            return
        }

        let newList = list.map { value in
            "\(value)"
        }

        let messageIdStr = newList.joined(separator: ",")
        loading = true
        MDNetworkTool.messagesRead(messageIdStr) { results, error in
            self.loading = false
            if results != nil {
                var cacheList = self.fetchFailMessages()
                cacheList = cacheList.filter {
                                list.contains($0)
                            }
                UserDefaults.standard.setValue(cacheList, forKey: "kMessageReadFaileList")
                UserDefaults.standard.synchronize()
            }
        }
    }

    func saveFailMessage(_ id: Int) {
        if var list = UserDefaults.standard.value(forKey: "kMessageReadFaileList") as? [Int] {
            if list.contains(id) {
                return
            }
            list.append(id)
            UserDefaults.standard.setValue(list, forKey: "kMessageReadFaileList")
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.setValue([id], forKey: "kMessageReadFaileList")
            UserDefaults.standard.synchronize()
        }
    }

    func fetchFailMessages() -> [Int] {
        if let list = UserDefaults.standard.value(forKey: "kMessageReadFaileList") as? [Int] {
            return list
        }
        return []
    }
}
