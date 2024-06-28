//
//  MKUserTable.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/13.
//

import UIKit
import SQLite

class MDUserTable: MDBaseTable {

    let id = Expression<Int>("id")
    let json = Expression<String>("json")
    let timeStamp = Expression<Date>("timestamp")
    let table = Table("User")
    let connection = MDConnection.shared.connection

    static let share = MDUserTable()

    override init() {
        super.init()
    }

    override func createTable() {
        let query = table.create(ifNotExists: true, withoutRowid: false) { t in
            t.column(id, primaryKey:true)
            t.column(json)
            t.column(timeStamp, defaultValue:Date())
        }
        do {
            try connection?.run(query)
        }
        catch {
            print(error)
        }
    }

    func insert(userId: Int, info: String) {
        
        let query = table.insert(or: .replace,
                                 self.id <- userId,
                                 self.json <- info,
                                 self.timeStamp <- Date()
        )
        do {
            try connection?.run(query)
        }catch {
            Log.error(error)
        }
    }

    func select() -> MDUserInfo? {
        let query = table.select(json).order(timeStamp.desc).limit(1)
        guard let selects = try? connection?.prepare(query) else {
            return nil
        }
        var json: String?
        for row in selects {
            json = row[self.json]
        }
        guard let json = json?.convertToDictionary() else {
            return nil
        }
        let jsonDecode = JSONDecoder()
        guard let obj = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }
        guard let userInfo = try? jsonDecode.decode(MDUserInfo.self, from: obj) else {
            return nil
        }
        return userInfo
    }

    func delete() {
        let _ = try? connection?.run(table.delete())
    }
}
