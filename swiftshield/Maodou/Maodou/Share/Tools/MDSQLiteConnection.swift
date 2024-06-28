//
//  OOConnectManager.swift
//  Orchid
//
//  Created by 李白 on 2022/10/28.
//

import Foundation
import SQLite

class MDSQLiteConnection {

    static let shared = MDSQLiteConnection()
    public let queue = DispatchQueue(label: "com.sqlite.io.queue")
    var db: Connection?

    init() {
        do {
            db = try Connection("\(PATH_OF_DOCUMENT)/\(DEFAULT_DB_NAME)")
            db?.busyTimeout = 5.0
            db?.busyHandler({ tries in
                if tries >= 3  {
                    return false
                }
                return true
            })
            db?.trace({ message in
                print("sqlite --- \(message)")
            })
        } catch {
            print(error)
        }
    }

//    func insert(_ insert: Insert) {
//        queue.async { [weak self] in
//            do {
//                try self?.db?.run(insert)
//            }
//            catch {
//                print(error)
//            }
//        }
//    }
//
//    func delete(_ delete: Delete) {
//        queue.async { [weak self] in
//            do {
//                try self?.db?.run(delete)
//            }
//            catch {
//                print(error)
//            }
//        }
//    }
}
