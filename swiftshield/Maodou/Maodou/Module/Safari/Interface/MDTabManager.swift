//
//  MDTabManager.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WebKit

protocol MDTabManagerProtocol: NSObject {
    func tabManager(_ tabManager: MDTabManager, didSelectedTabChange selected: MDTabModel?, previous: MDTabModel?)
    func tabManager(_ tabManager: MDTabManager, didAddTab tab: MDTabModel)
    func tabManager(_ tabManager: MDTabManager, didRemoveTab tab: MDTabModel?)
    func tabManagerDidRemoveAllTabs(_ tabManager: MDTabManager)
    func tabManagerUpdateCount(_ tabManager: MDTabManager, count: Int)
}

class MDTabManager: NSObject {
    
    weak var delegate: MDTabManagerProtocol?
    fileprivate(set) var tabs = [MDTabModel]()
    fileprivate var _selectedIndex = -1
    static let shareInstance = MDTabManager()

    var count: Int {
        return tabs.count
    }

    var selectedTab: MDTabModel? {
        if !(0..<count ~= _selectedIndex) {
            return nil
        }

        return tabs[_selectedIndex]
    }

    var selectedIndex: Int { return _selectedIndex }

    var normalTabs: [MDTabModel] {
        return tabs.filter { !$0.isPrivate }
    }

    var privateTabs: [MDTabModel] {
        return tabs.filter { $0.isPrivate }
    }

    subscript(webView: WKWebView) -> MDTabModel? {
        for tab in tabs where tab._webView === webView {
            return tab
        }
        return nil
    }

    public static func makeWebViewConfig(isPrivate: Bool) -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.dataDetectorTypes = [.phoneNumber]
        configuration.processPool = WKProcessPool()
//        let blockPopups = prefs?.boolForKey(PrefsKeys.KeyBlockPopups) ?? true
//        configuration.preferences.javaScriptCanOpenWindowsAutomatically = !blockPopups
        // We do this to go against the configuration of the <meta name="viewport">
        // tag to behave the same way as Safari :-(
        configuration.ignoresViewportScaleLimits = true
        if isPrivate {
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        }
        configuration.setURLSchemeHandler(MDURLSchemeHandler(), forURLScheme: "internal")
        return configuration
    }

    // A WKWebViewConfiguration used for normal tabs
    lazy fileprivate var configuration: WKWebViewConfiguration = {
        return MDTabManager.makeWebViewConfig(isPrivate: false)
    }()

    // A WKWebViewConfiguration used for private mode tabs
    lazy fileprivate var privateConfiguration: WKWebViewConfiguration = {
        return MDTabManager.makeWebViewConfig(isPrivate: true)
    }()
}

extension MDTabManager {
    
    @discardableResult func restore() -> MDTabModel {
        let table = MDTabTable()
        let tabs = table.selectAll()
        tabs.forEach { tab in
            tab.configuration = MDTabManager.makeWebViewConfig(isPrivate: tab.isPrivate)
            delegate?.tabManager(self, didAddTab: tab)
        }
        if tabs.isEmpty {
            let tab = add(isPrivate: false)
            _selectedIndex = 0
            return tab
        }
        let tab = table.selectLatest()
        for (index, obj) in tabs.enumerated() {
            if obj.id == tab?.id {
                _selectedIndex = index
                break
            }
        }
        self.tabs = tabs
        delegate?.tabManagerUpdateCount(self, count: count)
        select(tab: selectedTab!)
        return selectedTab!
    }

    @discardableResult func add(isPrivate: Bool = false) -> MDTabModel {
        let tab = MDTabModel()
        tab.configuration = MDTabManager.makeWebViewConfig(isPrivate: isPrivate)
        tab.id = UUID().uuidString
        tabs.append(tab)
        delegate?.tabManager(self, didAddTab: tab)
        select(tab: tab)
        delegate?.tabManagerUpdateCount(self, count: count)
        return tab
    }
    
    @discardableResult func addTabItemBy(host url:String,title t:String?, isPrivate: Bool = false) -> MDTabModel {
        let tab = MDTabModel()
        tab.configuration = MDTabManager.makeWebViewConfig(isPrivate: isPrivate)
        tab.id = UUID().uuidString
        tab.url = url
        tab.title = t
        tabs.append(tab)
        delegate?.tabManager(self, didAddTab: tab)
        select(tab: tab)
        delegate?.tabManagerUpdateCount(self, count: count)
        return tab
    }

    func select(tab: MDTabModel) {
        let previous = selectedTab
        let index = tabs.firstIndex(of: tab) ?? -1
        _selectedIndex = index
        delegate?.tabManager(self, didSelectedTabChange: tab, previous: previous)
        MDTabTable().insert(tab)
    }

    func remove(tab: MDTabModel) {
        guard let index = tabs.firstIndex(of: tab) else {
            return
        }
        objc_sync_enter(self)

        if index == _selectedIndex {
            if _selectedIndex > 0 {
                _selectedIndex -= 1
                select(tab: tabs[_selectedIndex])
                tabs.remove(at: index)
            } else {
                tabs.remove(at: index)
                _selectedIndex = -1
                add()
            }
        } else if index < _selectedIndex {
            _selectedIndex -= 1
            tabs.remove(at: index)
        }
        MDTabTable().delete(tab.id)
        objc_sync_exit(self)
        delegate?.tabManager(self, didRemoveTab: tab)
        delegate?.tabManagerUpdateCount(self, count: count)

    }

    func clear(isPrivate: Bool = false) {
        tabs.removeAll()
        _selectedIndex = -1
        MDTabTable().deleteAll()
        add()
        delegate?.tabManagerUpdateCount(self, count: count)
    }

}
