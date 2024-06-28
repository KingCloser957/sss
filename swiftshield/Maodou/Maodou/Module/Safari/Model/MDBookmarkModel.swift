//
//  MDBookmarkModel.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

struct MDBookmarkModel {
    var id: String = ""
    var parentId: String?
    var title: String?
    var url: String?
    var isFolder: Bool = false
    var createdTime: Date?
    var modifyTime: Date?
    var path: String?
    var cornerStyle: UIRectCorner = []
}
