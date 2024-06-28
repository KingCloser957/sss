//
//  MDHistoryTable.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import SQLite

class MDHistoryTable: MDBaseTable {
    let connection = MDConnection.shared.connection
    let table = Table("History")
    //更新时间
    let timestamp = Expression<Date>("timestamp")
    //链接
    let url = Expression<String?>("url")
    //标题
    let title = Expression<String?>("title")

    override init() {
        super.init()
    }

    override func createTable() {
        let query = table.create(ifNotExists: true, withoutRowid: false) { t in
            t.column(title)
            t.column(url, unique: true)
            t.column(timestamp)
        }
        do {
            try connection?.run(query)
        }
        catch {
            print(error)
        }
    }

    func insert(_ model: MDHistoryModel) {
        let query = table.insert(or: .replace,
                                 self.timestamp <- Date(),
                                 self.url <- model.url,
                                 self.title <- model.title

        )
        do {
            try connection?.run(query)
        }catch {
            debugPrint(error)
        }
    }

    func delete(_ model: MDHistoryModel) {
        let query = table.filter(model.url == url).delete()
        do {
            try connection?.run(query)
        } catch{
            Log.error(error.localizedDescription)
        }
    }

    func selectAll() -> [MDHistoryModel] {
        let query = table.select(timestamp, url, title).order(timestamp.desc)
        var models: [MDHistoryModel] = []
        do {
            if let result = try connection?.prepare(query) {
                for row in result {
                    var model = MDHistoryModel()
                    model.title = row[title]
                    model.url = row[url]
                    model.timestamp = row[timestamp].timeIntervalSince1970
                    models.append(model)
                }
            }
        } catch{
            Log.error(error.localizedDescription)
        }
        return models
    }

    func select(_ limit: Int, offset: Int) -> [MDHistoryModel] {
        let query = table.select(timestamp, url, title).order(timestamp.desc).limit(limit, offset: offset)
        var models: [MDHistoryModel] = []
        do {
            if let result = try connection?.prepare(query) {
                for row in result {
                    var model = MDHistoryModel()
                    model.title = row[title]
                    model.url = row[url]
                    model.timestamp = row[timestamp].timeIntervalSince1970
                    models.append(model)
                }
            }
        } catch{
            Log.error(error.localizedDescription)
        }
        return models
    }

    func clear() {
        let query = table.delete()
        do {
            try connection?.run(query)
        } catch{
            Log.error(error.localizedDescription)
        }
    }

}
