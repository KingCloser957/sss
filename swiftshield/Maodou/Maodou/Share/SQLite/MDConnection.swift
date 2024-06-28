//
//  MKConnection.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/13.
//

import Foundation
import SQLite

class MDConnection {

    static let shared = MDConnection()

    open var connection: Connection?

    init() {
        do {
            connection = try Connection(path())
            connection?.busyTimeout = 5.0
            connection?.busyHandler({ tries in
                if  tries >= 3 {
                    return false
                }
                return true
            })
            connection?.trace({ message in
                Log.info(message)
            })
        } catch {
            Log.error(error)
        }
    }

    private func path() -> String {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbName = "database_swift.sqlite3"
        return dbPath + "/" + dbName
    }

}
