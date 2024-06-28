//
//  MDTabModel.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WebKit

protocol MDTabProtocol: NSObject {
    func tab(_ tab: MDTabModel, didCreateWebView webView: WKWebView)
    func tab(_ tab: MDTabModel, willDeleteWebView webView: WKWebView)
    func tab(_ tab: MDTabModel, urlChange url: URL)
    func tab(_ tab: MDTabModel, loadingStateChange state: Bool)
}


class MDTabModel: NSObject {
    var id: String!
    var createdTime: TimeInterval?
    var executedTime: TimeInterval?
    var list: [String] = []
    var url: String?
    var title: String?
    var isPrivate: Bool = false

    var nightMode: Bool {
        didSet {
            guard nightMode != oldValue else {
                return
            }
            injectUserScriptsIntoTab(self, nightMode: nightMode, noImageMode: noImageMode)
        }

    }
    var noImageMode: Bool {
        didSet {
            guard noImageMode != oldValue else {
                return
            }
            injectUserScriptsIntoTab(self, nightMode: nightMode, noImageMode: noImageMode)
        }
//        get {
//            return UserDefaults.standard.bool(forKey: "kNoImageMode")
//        }
    }
    var configuration: WKWebViewConfiguration!
    var _webView: WKWebView?
    weak var delegate: MDTabProtocol?
    var webView: WKWebView {
        get {
            if _webView == nil {
                createWebview()
            }
            return _webView!
        }
    }

    override init() {
        self.noImageMode = UserDefaults.standard.bool(forKey: "kNoImageMode")
        self.nightMode = UserDefaults.standard.bool(forKey: "kNightMode")
    }

    func createWebview() {
        configuration.allowsInlineMediaPlayback = true
        let webview = MDWebView(frame: .zero, configuration: configuration)
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webview.allowsBackForwardNavigationGestures = true
        webview.allowsLinkPreview = true
        webview.backgroundColor = .black
        webview.scrollView.layer.masksToBounds = true
        webview.scrollView.contentInsetAdjustmentBehavior = .never
        restore(webview)
        _webView = webview
        _webView?.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        _webView?.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        _webView?.addObserver(self, forKeyPath: "loading", options: .new, context: nil)

        injectUserScriptsIntoTab(self, nightMode: noImageMode, noImageMode: noImageMode)
        delegate?.tab(self, didCreateWebView: webview)
    }

    func injectUserScriptsIntoTab(_ tab: MDTabModel, nightMode: Bool, noImageMode: Bool) {
        guard configuration != nil else {
            return
        }
        tab.configuration.userContentController.removeAllUserScripts()
        
        let  userContentController = tab.configuration.userContentController
        let list = [
                    [
                        "source":"__firefox__",
                        "time": WKUserScriptInjectionTime.atDocumentStart,
                        "onlyMain": false
                    ],
                    [
                        "source":"GetAllImageHelper",
                         "time": WKUserScriptInjectionTime.atDocumentEnd,
                         "onlyMain": true
                    ],
                    [
                        "source":"NoImageModeHelper",
                        "time": WKUserScriptInjectionTime.atDocumentStart,
                        "onlyMain": true
                    ]
                    ]
        list.forEach { dict in
            if let name = dict["source"] as? String,
               let path = Bundle.main.path(forResource: name, ofType: "js"),
               let time = dict["time"] as? WKUserScriptInjectionTime,
               let onlyMain = dict["onlyMain"] as? Bool
            {
                do {
                    let content = try String(contentsOfFile: path)
                    let userScript = WKUserScript(source: content,
                                                  injectionTime: time,
                                                  forMainFrameOnly: onlyMain)
                    userContentController.addUserScript(userScript)
                }
                catch {
                    Log.error(error.localizedDescription)
                }
            }
        }
        
        let state = noImageMode ? "true" : "false"
        let userScript = WKUserScript(source: "window.__firefox__.NoImageMode.setEnabled(\(state))", injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "URL", let url = webView.url, (url.scheme == "http" || url.scheme == "https") {
            delegate?.tab(self, urlChange: url)
            Log.debug(url.absoluteString)
        }

        if keyPath == "title", let title = webView.title, title != "blank" {
            Log.debug(webView.title)
            self.title = title

        }
        if keyPath == "loading" {
            delegate?.tab(self, loadingStateChange: webView.isLoading)
        }
    }

    func restore(_ webView: WKWebView) {

        if let url = getRestoreUrl() {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    private func getRestoreUrl() -> URL?{
        guard let currentPage = url else { return nil }
        let params = ["urls": list, "currentPage":currentPage] as [String : Any]
        let paramsStr = params.convertToString()!
        var urlComponents = URLComponents.init()
        urlComponents.scheme = "internal"
        urlComponents.host = "local"
        urlComponents.query = "params=\(paramsStr)"
        urlComponents.path = "/restore"
        return urlComponents.url
    }

    var canGoBack: Bool {
        get {
            return webView.canGoBack
        }
    }

    var canGoForward: Bool {
        get {
            return webView.canGoForward
        }
    }

    func goBack() {
        if canGoBack {
            webView.goBack()
        }
    }

    func goForward() {
        if canGoForward {
            webView.goForward()
        }
    }

    func reload() {
        webView.reload()
    }

    func stopLoading() {
        webView.stopLoading()
    }

    @discardableResult func loadRequest(_ request: URLRequest) -> WKNavigation? {
        return webView.load(request)
    }

    deinit {
//        _webView?.removeObserverBlocks(forKeyPath: "URL")
//        _webView?.removeObserverBlocks(forKeyPath: "title")
        _webView?.navigationDelegate = nil
    }
}
