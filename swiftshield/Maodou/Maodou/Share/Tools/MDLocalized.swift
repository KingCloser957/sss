//
//  MDLocalized.swift
//  Maodou
//
//  Created by KingCloser on 2024/6/1.
//

import UIKit
import Foundation

let AppLanguage = "kAppLanguageKey"

class MDLocalized: NSObject {
    private static var instance = MDLocalized()
    public var isFirstInitial = false
    
    static func shareInstance() -> MDLocalized {
        return instance
    }
    
    public func initLanguage() {
        guard let language = currentLanguage() else {
            systemLanguage()
            return
        }
        debugPrint("用户设置语言为: \(language)")
        setLanguage(language,false)
    }
    
    func currentLanguage() -> String? {
        guard let language = UserDefaults(suiteName: groupId)?.value(forKey: AppLanguage) as? String else {
            isFirstInitial = true
            return nil
        }
        return language
    }
    
    func isSystemLanguage() -> Bool {
        let languages = Bundle.main.preferredLocalizations
        guard let language = UserDefaults(suiteName: groupId)?.value(forKey: AppLanguage) as? String, let systemLanguage = languages.first  else {
            return false
        }
        return language == systemLanguage
    }
    
    func systemLanguage() {
        let languages = Bundle.main.preferredLocalizations
        guard var language = languages.first else {
            setLanguage("en", true)
            return
        }
        if language.hasPrefix("zh-Hant") {
            language = "zh-Hant" //繁体中文
        }else if language.hasPrefix("zh-Hans") {
            language = "zh-Hans" //简体中文
        }else if language.hasPrefix("ko") {
            language = "ko" //韩语
        }else if language.hasPrefix("ja") {
            language = "ja" //日语
        }else if language.hasPrefix("de") {
            language = "de" //德语
        }else if language.hasPrefix("es") {
            language = "es" //西班牙
        }else if language.hasPrefix("fr") {
            language = "fr" //法语
        }else if language.hasPrefix("it") {
            language = "it" //意大利语
        }else if language.hasPrefix("ru") {
            language = "ru" //俄罗斯语
        }else if language.hasPrefix("ar") {
            language = "ar" //阿拉伯语
        }else{
            //默认英语
            language = "en"
        }
        setLanguage(language,true)
    }
    
    func setLanguage(_ language: String?) {
        if language == nil {
            UserDefaults(suiteName: groupId)?.setValue("en", forKey: AppLanguage)
        } else {
            UserDefaults(suiteName: groupId)?.setValue(language, forKey: AppLanguage)
        }
        UserDefaults(suiteName: groupId)?.synchronize()
    }
    
    func setLanguage(_ language: String?,_ isFirstInitial:Bool?) {
        NotificationCenter.default.post(name:
                                            NSNotification.Name(rawValue: "kExChangeLanguageNotification"),
                                        object:language == "ar", userInfo: nil)
        setLanguage(language)
    }
    
    //本地语言转换为服务器的语言key值
    func convertServerLanguageKey() -> String {
        let language = currentLanguage()
        switch language {
        case "zh-Hans":
            return "zh_CN"
        case "zh-Hant":
            return "zh_TW"
        case "ko":
            return "ko_KR"
        case "ja":
            return "ja_JP"
        case "fr":
            return "fr_FR"
        case "es":
            return "es_ES"
        case "de":
            return "de_DE"
        case "it":
            return "it_IT"
        case "ru":
            return "ru_RU"
        case "ar":
            return "ar_SA"
        default:
            return "en_US"
        }
    }
    
    func convertLanguageName() -> String {
        let language = currentLanguage()
        switch language {
        case "zh-Hans":
            return "Chinese".localizable()
        case "zh-Hant":
            return "Traditional Chinese".localizable()
        case "ko":
            return "Korean".localizable()
        case "ja":
            return "Japanese".localizable()
        case "fr":
            return "French".localizable()
        case "es":
            return "Spanish".localizable()
        case "de":
            return "German".localizable()
        case "it":
            return "Italian".localizable()
        case "ru":
            return "Russian".localizable()
        case "ar":
            return "Arabic".localizable()
        default:
            return "English".localizable()
        }
    }
    func isFlip() -> Bool {
        let language = currentLanguage()
        if language == "ar" {
            return true
        }
        return false
    }
}

