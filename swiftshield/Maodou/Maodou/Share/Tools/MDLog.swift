//
//  MKLog.swift
//  MonkeyKing
//
//  Created by 李白 on 2023/3/9.
//

import UIKit


enum Log {
    static func debug<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("\n🐞 [DEBUG] [\(fileName)][\(function)][\(line)] : \(message)")
    }

    static func info<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("\n✅ [INFO] [\(fileName)][\(function)][\(line)] : \(message)")
    }

    static func error<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("\n‼️ [ERROR] [\(fileName)][\(function)][\(line)] : \(message)")
    }

    static func warning<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("\n⚠️ [WARNING] [\(fileName)][\(function)][\(line)] : \(message)")
    }
}
