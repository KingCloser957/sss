//
//  MDSearchEngine.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDSearchEngine: NSObject {
    fileprivate static var allSearchEngines: [String:Any]? = {
        if let url = Bundle.main.url(forResource: "SearchEngines.plist", withExtension: nil),
           let data = try? Data(contentsOf: url),
           let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String:Any]
        {
            return dict
        }
        return [:]
    }()
    
    static var totalSearchEngines: [String:SearchEngine.Details] = {
        if let dict = MDSearchEngine.allSearchEngines,
           let searchEngnines = dict["SearchEngines"] as? [[String:Any]],
           let searchApps = dict["SearchApps"] as? [[String:Any]]{
                var modelDic:[String:Any] = [:]
                searchEngnines.forEach { s in
                    if let key = s.keys.first {
                        modelDic[key] = s[key]
                    }
                }
                searchApps.forEach { s in
                    if let key = s.keys.first {
                        modelDic[key] = s[key]
                    }
                }
                if let data = MDCoderTool.fromDict([String: SearchEngine.Details].self, modelDic){
                     return data
                }
        }
        return [:]
    }()
    
    static var searchEngines: [String:SearchEngine.Details] = {
        if let dict = MDSearchEngine.allSearchEngines,
           let searchEngnines = dict["SearchEngines"] as? [[String:Any]] {
            var modelDic:[String:Any] = [:]
            searchEngnines.forEach { s in
                if let key = s.keys.first {
                    modelDic[key] = s[key]
                }
            }
            if let data = MDCoderTool.fromDict([String: SearchEngine.Details].self, modelDic){
                return data
            }
        }
        return [:]
    }()
    
    static var searchApps: [String:SearchEngine.Details] = {
        if let dict = MDSearchEngine.allSearchEngines,
           let searchEngnines = dict["SearchApps"] as? [[String:Any]] {
            var modelDic:[String:Any] = [:]
            searchEngnines.forEach { s in
                if let key = s.keys.first {
                    modelDic[key] = s[key]
                }
            }
            if let data = MDCoderTool.fromDict([String: SearchEngine.Details].self, modelDic){
                return data
//                return data.keys.sorted().map { SearchEngine(name: $0)}
            }
        }
        return [:]
    }()
    
    class var searchEngine: SearchEngine {
        get {
            let name = UserDefaults.standard.object(forKey: "search_engine") as? String
            if name == nil {
                return MDSearchEngine.defaultSearchEngine
            }
            return SearchEngine(name: name ?? "")
        }
        set {
            UserDefaults.standard.set(newValue.name, forKey: "search_engine")
        }
    }
    
    static var defaultSearchEngine:SearchEngine {
        return SearchEngine(name: "Bing")
    }
}

struct SearchEngine:Equatable {
    let name:String
    var details:Details? {
        return MDSearchEngine.totalSearchEngines[name]
    }
    
    func set(details:Details?) {
        MDSearchEngine.totalSearchEngines[name] = details
    }
    
    struct Details:Codable {
        enum CodingKeys:String,CodingKey {
            case searchUrl = "search_url"
            case homepageUrl = "homepage_url"
            case autocompleteUrl = "autocomplete_url"
            case postParams = "post_params"
            case searchChineseName = "search_chinese_name"
            case searchIcon =  "search_icon"
        }
        
        let searchUrl:String?
        
        let homepageUrl:String?
        
        let autocompleteUrl:String?
        
        let postParams:[String:String]?
        
        let searchChineseName:String?
        
        let searchIcon:String?
        
        init(searchUrl:String? = nil,homepageUrl:String? = nil,autocompleteUrl:String? = nil,postParams:[String:String]? = nil,searchChineseName:String? = nil,searchIcon:String? = nil) {
            self.searchUrl = searchUrl
            self.homepageUrl = homepageUrl
            self.autocompleteUrl = autocompleteUrl
            self.postParams = postParams
            self.searchChineseName = searchChineseName
            self.searchIcon = searchIcon
        }
        
        init(from dict:[String:Any]) {
            self.searchUrl = dict[CodingKeys.searchUrl.rawValue] as? String
            self.homepageUrl = dict[CodingKeys.homepageUrl.rawValue] as? String
            self.autocompleteUrl = dict[CodingKeys.autocompleteUrl.rawValue] as? String
            self.postParams = dict[CodingKeys.postParams.rawValue] as? [String:String]
            self.searchChineseName = dict[CodingKeys.searchChineseName.rawValue] as? String
            self.searchIcon = dict[CodingKeys.searchIcon.rawValue] as? String
        }
        
        func toDict() -> [String:Any] {
            var dict = [String:Any]()
            if let searchUrl = searchUrl {
                dict[CodingKeys.searchUrl.rawValue] = searchUrl
            }
            if let homepageUrl = homepageUrl {
                dict[CodingKeys.homepageUrl.rawValue] = homepageUrl
            }
            if let autocompleteUrl = autocompleteUrl {
                dict[CodingKeys.autocompleteUrl.rawValue] = autocompleteUrl
            }
            if let postParams = postParams {
                dict[CodingKeys.postParams.rawValue] = postParams
            }
            if let searchChineseName = searchChineseName {
                dict[CodingKeys.searchChineseName.rawValue] = searchChineseName
            }
            if let searchIcon = searchIcon {
                dict[CodingKeys.searchIcon.rawValue] = searchIcon
            }
            return dict
        }
    }
    
}
