//
//  MDBookmarkTable.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import SQLite

class MDBookmarkTable: MDBaseTable {
    
    let connection = MDConnection.shared.connection
    let table = Table("Bookmark")
    //创建时间
    let createdTime = Expression<Date>("createdTime")
    //修改时间
    let modifyTime = Expression<Date>("modifyTime")
    //链接
    let url = Expression<String?>("url")
    //标题
    let title = Expression<String?>("title")
    //是否文件夹
    let isFolder = Expression<Bool>("isFolder")
    //id
    let id = Expression<String>("id")
    //上级id
    let parentId = Expression<String?>("parentId")
    let path = Expression<String?>("path")

    override init() {
        super.init()
    }

    override func createTable() {
        let query = table.create(ifNotExists: true, withoutRowid: false) { t in
            t.column(id)
            t.column(parentId)
            t.column(title)
            t.column(url, unique: true)
            t.column(isFolder, defaultValue: false)
            t.column(createdTime, defaultValue: Date())
            t.column(modifyTime)
            t.column(path)
        }
        do {
            try connection?.run(query)
        }
        catch {
            print(error)
        }
    }

    func insert(_ model: MDBookmarkModel) throws {
        let query = table.insert(or: .fail,
                                 self.modifyTime <- Date(),
                                 self.url <- model.url,
                                 self.title <- model.title,
                                 self.id <- model.id,
                                 self.parentId <- model.parentId,
                                 self.isFolder <- model.isFolder,
                                 self.path <- model.path
                                )
        try connection?.run(query)
    }

    func update(_ model: MDBookmarkModel) {
        let query = table.filter(id == model.id).update([path <- model.path,
                                                         title <- model.title,
                                                         url <- model.url,
                                                         modifyTime <- Date(),
                                                         parentId <- model.parentId
                                                        ])
        do {
            try connection?.run(query)
        }catch {
            debugPrint(error)
        }
    }

    func delete(_ model: MDBookmarkModel) {
        //文件夹删除
        if model.isFolder {
            let query = table.filter(path.like("\(model.path!)")).delete()
            do {
                try connection?.run(query)
            } catch{
                Log.error(error.localizedDescription)
            }
        } else {
            let query = table.filter(model.id == id).delete()
            do {
                try connection?.run(query)
            } catch{
                Log.error(error.localizedDescription)
            }
        }
    }

    func delete( with url: String) {
        let query = table.filter(self.url == url).delete()
        do {
            try connection?.run(query)
        } catch{
            Log.error(error.localizedDescription)
        }
    }

//    func selectAll() -> [MDHistoryModel] {
//        let query = table.select(timestamp, url, title).order(timestamp.desc)
//        var models: [MDHistoryModel] = []
//        do {
//            if let result = try connection?.prepare(query) {
//                for row in result {
//                    var model = MDHistoryModel()
//                    model.title = row[title]
//                    model.url = row[url]
//                    model.timestamp = row[timestamp].timeIntervalSince1970
//                    models.append(model)
//                }
//            }
//        } catch{
//            Log.error(error.localizedDescription)
//        }
//        return models
//    }

    func select(_ parentId: String?) -> [MDBookmarkModel] {
        let query = table.filter(self.parentId == parentId).select(id, self.parentId, path, createdTime, modifyTime, url, title, isFolder ).order(modifyTime.desc)
        var models: [MDBookmarkModel] = []
        do {
            if let result = try connection?.prepare(query) {
                for row in result {
                    var model = MDBookmarkModel()
                    model.id = row[id]
                    model.parentId = row[self.parentId]
                    model.path = row[path]
                    model.title = row[title]
                    model.url = row[url]
                    model.createdTime = row[createdTime]
                    model.modifyTime = row[modifyTime]
                    model.isFolder = row[isFolder]
                    models.append(model)
                }
            }
        } catch{
            Log.error(error.localizedDescription)
        }
        return models
    }


    func isContain(url: String?) -> Bool {
        let query = table.filter(self.url == url)
        var isEmpty = false
        do {
            let result = try connection?.prepare(query)
            result?.forEach({ row in
                isEmpty = true
            })
        } catch{
            Log.error(error.localizedDescription)
        }
        return isEmpty
    }

}
