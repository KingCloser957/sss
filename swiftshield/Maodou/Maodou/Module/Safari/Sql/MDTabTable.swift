//
//  MDTabTable.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import SQLite

class MDTabTable: MDBaseTable {
    
    let connection = MDConnection.shared.connection
    let table = Table("Tables")
    let id = Expression<String>("id")
    let title = Expression<String?>("title")
    let createdTime = Expression<TimeInterval>("createdTime")
    let executedTime = Expression<TimeInterval>("executedTime")
    let list = Expression<String?>("list")
    let url = Expression<String?>("url")
    let isPrivate = Expression<Bool>("isPrivate")

    override init() {
        super.init()
    }

    override func createTable() {
        let query = table.create(ifNotExists: true, withoutRowid: false) { t in
            t.column(createdTime, defaultValue: Date().timeIntervalSince1970)
            t.column(id, unique: true)
            t.column(title)
            t.column(list)
            t.column(url)
            t.column(isPrivate, defaultValue: false)
            t.column(executedTime)
        }
        do {
            try connection?.run(query)
        }
        catch {
            print(error)
        }
    }

    func insert(_ model: MDTabModel) {
        let query = table.insert(or: .replace,
                                 self.id <- model.id,
                                 self.url <- model.url,
                                 self.title <- model.title,
                                 self.list <- model.list.convertToString(),
                                 self.isPrivate <- model.isPrivate,
                                 self.executedTime <- Date().timeIntervalSince1970
        )
        do {
            try connection?.run(query)
        }catch {
            debugPrint(error)
        }
    }

    func delete(_ id: String) {
        let id = table.filter(self.id == id)
        do {
            try connection?.run(id.delete())
        } catch {
            print(error)
        }
    }

    func deleteAll() {
        let query = table.delete()
        do {
            try connection?.run(query)
        } catch {
            print(error)
        }
    }

    func selectLatest() -> MDTabModel? {
        if let row = try? connection?.pluck(table.order(executedTime.desc).limit(1)) {
            let model = MDTabModel()
            model.id = row[id]
            model.createdTime = row[createdTime]
            model.list = (row[list]?.convertToArray() as? [String]) ?? Array<String>()
            model.url = row[url]
            model.executedTime = row[executedTime]
            return model
        }
        return nil
    }

    func selectAll() -> [MDTabModel] {
        let query = table.select(id, createdTime, list, url, title, isPrivate, executedTime)
        var models: [MDTabModel] = []
        do {
            let result = try connection!.prepare(query)
            for row in result {
                Log.debug(row[id])
                let model = MDTabModel()
                model.id = row[id]
                model.createdTime = row[createdTime]
                model.executedTime = row[executedTime]
                model.list = (row[list]?.convertToArray() as? [String]) ?? Array<String>()
                model.url = row[url]
                model.isPrivate = row[isPrivate]
                model.title = row[title]
                models.append(model)
            }
        } catch{
            Log.error(error.localizedDescription)
        }

        return models
    }
}
