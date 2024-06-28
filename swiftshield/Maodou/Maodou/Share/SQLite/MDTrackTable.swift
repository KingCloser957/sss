//
//  MKTrackTable.swift
//  MonkeyKing
//
//  Created by huangrui on 2023/3/30.
//

import UIKit
import SQLite

class MDTrackTable: MDBaseTable {
    
    static let shared = MDTrackTable()

    let id = Expression<Int64>("id")
    let timestamp = Expression<TimeInterval>("timestamp")
    let parameter = Expression<String?>("parameter")
    let connection = MDSQLiteConnection.shared
    let track = Table("Track")

    override init() {
        super.init()
    }

    override func createTable() {
        let track = track.create(ifNotExists: true, withoutRowid: false) { t in
            t.column(timestamp, unique: true)
            t.column(parameter)
        }
        do {
            try connection.db?.run(track)
        }
        catch {
            print(error)
        }
    }

    func insert(_ timestamp: TimeInterval, _ parameter: String?) {
        let track = self.track.insert(self.timestamp <- timestamp, self.parameter <- parameter)
        let rowid = try? self.connection.db?.run(track)
        print(rowid)
    }

    func delete(_ timestamp: TimeInterval) {
        guard let timestamps = try? track.filter(self.timestamp == timestamp) else {
            return
        }
        do {
            try self.connection.db?.run(timestamps.delete())
        } catch {
            print(error)
        }
    }

    func fetchMaxTimeStamp() -> TimeInterval {
        var max: TimeInterval = 0
        do {
            let query = "SELECT MAX(timestamp) FROM Track"
            if let result = try connection.db?.prepare(query) {
                for row in result {
                    max = (row[0] as? TimeInterval) ?? 0
                }
            } else {
                max = 0
            }
        } catch {
            max = 0
        }
        return max
    }

    func selectFaileDatas(_ timestamp: TimeInterval) -> [[String: Any]] {
        let max = timestamp
        if max <= 0 {
            return []
        }
        guard let filter = try? track.filter(self.timestamp <= max) else {
            return []
        }
        guard let result = try? connection.db?.prepare(filter) else {
            return []
        }
        var list = [[String: Any]]()
        for row in result {
            let str = MDAES256.decrypt("86712786e2205b50e80721462334364d", row[parameter])
            if let dict = str?.convertToDictinary() {
                list.append(dict)
            }
            print(row)
        }
        print(list)
        return list
    }


    func deleteFailDatas(_ timestamp: TimeInterval) {

        let max = timestamp
        if max <= 0 {
            return
        }
        guard let query = try? track.filter(self.timestamp <= max) else {
            return
        }
        do {
            try self.connection.db?.run(query.delete())
        } catch {
            print(error)
        }
    }
}
