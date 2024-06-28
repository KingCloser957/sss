//
//  OOPacUpdate.swift
//  Orchid
//
//  Created by 李白 on 2022/10/25.
//

import UIKit
import Network
import CoreMedia
//import CryptoKit

class MKPacUpdate: NSObject {

    var localPacConfig: [String: Any]!
    var count: Int = 0

    lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "com.orchid.routefiles.io.queue")
        return queue
    }()

    func reload(_ completion: ((_ result: Bool) -> Void)? = nil) {
        MDNetworkTool.routerFiles { [weak self](result, message) in
            guard let result = result as? [String:Any] else {
                return
            }

            var json = self?.getDocumentPacJson()
            if json == nil {
                json = self?.getBundlePacJson()
            }

            debugPrint("acl version ===============================")
            debugPrint(result.convertToString())
            debugPrint(json?.convertToString())
            debugPrint("===============================")

            guard let oldData = json else {
                debugPrint("本地pac列表为空")
                return
            }
            self?.localPacConfig = oldData

            guard let newData = result["data"] as? [String: Any] else { return }
            self?.count = 0
            var newCount = 0
            for (key, newDict) in newData {
                if key == "gfwlist" || key == "global" || key == "gfwlist_KR" || key == "gfwlist_otd", let newDict = newDict as? [String: Any]  {
                    debugPrint(newDict)
                    if let oldDict = oldData[key] as? [String: Any] {
                        let new_version = newDict["updated_at"] as? Int
                        let old_version = oldDict["updated_at"] as? Int
                        if new_version != old_version {
                            newCount += 1
                        }
                    }
                }
            }
            if newCount == 0 {
                if completion != nil {
                    completion!(true)
                }
                return
            }
            for (key, newDict) in newData {

                if key == "gfwlist" || key == "global" || key == "gfwlist_KR" || key == "gfwlist_otd", let newDict = newDict as? [String: Any]  {
                    debugPrint(newDict)
                    if let oldDict = oldData[key] as? [String: Any] {
                        let new_version = newDict["updated_at"] as? Int
                        let old_version = oldDict["updated_at"] as? Int
                        if new_version != old_version {
                            self?.downloadFile(newDict["file_path"] as? String, key: key, dict: newDict, finishedCall: { result in
                                if result {
                                    if self?.count == newCount && completion != nil {
                                        completion!(true)
                                    }
                                }
                            })
                        }
                    } else {
                        self?.downloadFile(newDict["file_path"] as? String, key: key, dict: newDict, finishedCall: { result in
                            if result {
                                self?.count += 1
                                if self?.count == newCount && completion != nil {
                                    completion!(true)
                                }
                            }
                        })
                    }
                }

            }
        }
    }

    func getBundlePacJson() -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: "routerfiles", ofType: nil) else {
            return nil
        }
        guard let content = try? String(contentsOfFile: path) else {
            return nil
        }
        return content.convertToDictinary()
    }

    func getDocumentPacJson() -> [String: Any]? {
        let fileManager = FileManager.default
        let myDirectory:String = NSHomeDirectory() + "/Documents/private"
        if !fileManager.fileExists(atPath: myDirectory) {
            try? fileManager.createDirectory(atPath: myDirectory,
                                    withIntermediateDirectories: true, attributes: nil)
        }
        let filePath:String = NSHomeDirectory() + "/Documents/routerfiles"
        guard fileManager.fileExists(atPath: filePath) else {
            return nil
        }
        guard let content = try? String(contentsOfFile: filePath) else {
            print("内容解析失败")
            return nil
        }
        return content.convertToDictinary()
    }

    func downloadFile(_ url: String?, key: String, dict: [String: Any], finishedCall: ((_ result: Bool) -> Void)? = nil) {
        guard let url = url else { return }
        MDNetworkTool.downloadRouterFiles(url: url) { [weak self](result, message) in
            guard let data = result else {
                if finishedCall != nil {
                    finishedCall!(false)
                }
                return
            }

            let myDirectory:String = NSHomeDirectory() + "/Documents/private/" + key + ".acl"
            let urlPath = URL(fileURLWithPath: myDirectory)

            do {
                try data.write(to: urlPath)
//                guard var data = self?.localPacConfig["data"] as? [String: Any] else {
//                    return
//                }
                self!.queue.async {
                    self?.localPacConfig[key] = dict
                    let localPacJson = self?.localPacConfig.convertToString()
                    let path = NSHomeDirectory() + "/Documents/routerfiles"

                    do {
                        try localPacJson?.write(toFile: path, atomically: true, encoding: .utf8)
                        if finishedCall != nil {
                            finishedCall!(true)
                        }
                    } catch {
                        debugPrint(error.localizedDescription)
                        if finishedCall != nil {
                            finishedCall!(false)
                        }
                    }
//                    print("--------")
//                    print(self?.localPacConfig)
                }

            } catch {
                debugPrint(error.localizedDescription)
                if finishedCall != nil {
                    finishedCall!(false)
                }
            }
        }
    }

}

class OOBuyHTMLUpdate {

    lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "com.orchid.buyhtml.io.queue")
        return queue
    }()

    func reload(_ completion: ((_ result: Bool) -> Void)? = nil) {
        MDNetworkTool.systemSetting { [weak self](result, msg) in
            guard var result = result as? [String:Any], let data = result["data"] as? [String: Any], let globalsettings = data["globalsettings"] as? [String: Any], let content = globalsettings["content"] as? [String: Any], let buypage = content["buypage"] as? String, let version = globalsettings["version"] as? Int else { return }
            print(buypage)
//            let newArr = buypage.split(separator: "/")
//            let newVersion = newArr[newArr.endIndex-3]

            var json = self?.getDocumentPacJson()
            if json == nil {
                json = self?.getBundlePacJson()
            }

            guard let oldData = json?["data"] as? [String: Any], let oldGlobalsettings = oldData["globalsettings"] as? [String: Any], let oldContent = oldGlobalsettings["content"] as? [String: Any], let oldVersion = oldGlobalsettings["version"] as? Int else { return }
//            let oldArr = oldBuypage.split(separator: "/")
//            let oldVersion = oldArr[oldArr.endIndex-3]
            result.removeValue(forKey: "error_code")
            UserDefaults.standard.set(result, forKey: "globalsettingsBuyPage")
            UserDefaults.standard.synchronize()

            if version != oldVersion {
                self?.downloadFile(buypage, dict: result, finishedCall: { result in
                    if result && completion != nil {
                        completion!(true)
                    }
                })
            }
        }
    }

    func downloadFile(_ url: String?, dict: [String: Any], finishedCall: ((_ result: Bool) -> Void)? = nil) {
        guard let url = url else { return }
        MDNetworkTool.downloadRouterFiles(url: url) { [weak self](result, message) in
            guard let data = result else {
                if finishedCall != nil {
                    finishedCall!(false)
                }
                return
            }

            let myDirectory:String = NSHomeDirectory() + "/Documents/private/" + "i-buy.zip"
            let urlPath = URL(fileURLWithPath: myDirectory)

            do {
                try data.write(to: urlPath)
//                guard var data = self?.localPacConfig["data"] as? [String: Any] else {
//                    return
//                }

//                self?.localPacConfig[key] = dict
                self!.queue.async {
                    let json = dict.convertToString()
                    let path = NSHomeDirectory() + "/Documents/systemsetting"
    //
                    do {
                        try json?.write(toFile: path, atomically: true, encoding: .utf8)
                        if finishedCall != nil {
                            finishedCall!(true)
                        }
                    } catch {
                        debugPrint(error.localizedDescription)
                        if finishedCall != nil {
                            finishedCall!(false)
                        }
                    }
                }
            } catch {
                debugPrint(error.localizedDescription)
                if finishedCall != nil {
                    finishedCall!(false)
                }
            }
        }
    }
    
    func downloadResouerce(_ url: String?,finishedCall: ((_ result: Bool) -> Void)? = nil) {
        guard let url = url else { return }
        MDNetworkTool.downloadRouterFiles(url: url) {(result, message) in
            guard let data = result else {
                if finishedCall != nil {
                    finishedCall!(false)
                }
                return
            }
            let myDirectory:String = NSHomeDirectory() + "/Documents/private/" + "i-buy.zip"
            let urlPath = URL(fileURLWithPath: myDirectory)
            do {
                try data.write(to: urlPath)
                if finishedCall != nil {
                   finishedCall!(true)
            }
        } catch {
                debugPrint(error.localizedDescription)
                if finishedCall != nil {
                    finishedCall!(false)
                }
            }
        }
    }

    func getBundlePacJson() -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: "systemsetting", ofType: nil) else {
            return nil
        }
        guard let content = try? String(contentsOfFile: path) else {
            return nil
        }
        return content.convertToDictinary()
    }

    func getDocumentPacJson() -> [String: Any]? {
        let fileManager = FileManager.default
        let myDirectory:String = NSHomeDirectory() + "/Documents/private"
        if !fileManager.fileExists(atPath: myDirectory) {
            try? fileManager.createDirectory(atPath: myDirectory,
                                    withIntermediateDirectories: true, attributes: nil)
        }
        let filePath:String = NSHomeDirectory() + "/Documents/systemsetting"
        guard fileManager.fileExists(atPath: filePath) else {
            return nil
        }
        guard let content = try? String(contentsOfFile: filePath) else {
            print("内容解析失败")
            return nil
        }
        return content.convertToDictinary()
    }
}

class OOResourcePackageVersionTool {

    var localConfig: [String: Any]!
    let pacTool = MKPacUpdate()
    let buyHTMLTool = OOBuyHTMLUpdate()
    lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "com.orchid.packageversion.io.queue")
        return queue
    }()

    func reload() {
        MDNetworkTool.routerFiles { [weak self](result, message) in
            guard let result = result as? [String:Any] else {
                return
            }
            var json = self?.getDocumentJson()
            if json == nil {
                json = self?.getBundleJson()
            }
            debugPrint("resouce version ===============================")
            debugPrint(json?.convertToString())
            debugPrint("===============================")
            guard let oldData = json else {
                debugPrint("本地pac列表为空")
                return
            }
            self?.localConfig = oldData

            for key in result.keys {
                print(key)
                if key == "aclVersion" {
                    if let new_value = result[key] as? Int, let old_value = oldData[key] as? Int, new_value != old_value {
                        self?.pacTool.reload { result in
                            if result {
                                self!.queue.async {
                                    self?.localConfig[key] = new_value
                                    let localConfigJson = self?.localConfig.convertToString()
                                    let path = NSHomeDirectory() + "/Documents/resourcePackageVersion"

                                    do {
                                        try localConfigJson?.write(toFile: path, atomically: true, encoding: .utf8)
                                    } catch {
                                        debugPrint(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                }else if key == "h5Version" {
                    if let new_value = result[key] as? String, let old_value = oldData[key] as? String, new_value != old_value {
                        self?.buyHTMLTool.reload { result in
                            if result {
                                self?.localConfig[key] = new_value
                                let localConfigJson = self?.localConfig.convertToString()
                                let path = NSHomeDirectory() + "/Documents/resourcePackageVersion"

                                do {
                                    try localConfigJson?.write(toFile: path, atomically: true, encoding: .utf8)
                                } catch {
                                    debugPrint(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func getBundleJson() -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: "resourcePackageVersion", ofType: nil) else {
            return nil
        }
        guard let content = try? String(contentsOfFile: path) else {
            return nil
        }
        return content.convertToDictinary()
    }

    func getDocumentJson() -> [String: Any]? {
        let fileManager = FileManager.default
        let myDirectory:String = NSHomeDirectory() + "/Documents/private"
        if !fileManager.fileExists(atPath: myDirectory) {
            try? fileManager.createDirectory(atPath: myDirectory,
                                    withIntermediateDirectories: true, attributes: nil)
        }
        let filePath:String = NSHomeDirectory() + "/Documents/resourcePackageVersion"
        guard fileManager.fileExists(atPath: filePath) else {
            return nil
        }
        guard let content = try? String(contentsOfFile: filePath) else {
            print("内容解析失败")
            return nil
        }
        return content.convertToDictinary()
    }
}
