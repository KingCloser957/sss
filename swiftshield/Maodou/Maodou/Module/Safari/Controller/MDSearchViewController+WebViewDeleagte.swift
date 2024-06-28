//
//  MDSafariViewController+WebViewDeleagteViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import Foundation
import WebKit

extension MDSearchViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }

    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {

        return false
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                     initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // 自定义 JavaScript Alert 的行为
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler()
        }))
        present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        // 自定义 JavaScript Confirm 的行为
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        present(alertController, animated: true, completion: nil)
    }

}

extension MDSearchViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url, let tab = tabManager[webView] else {
            decisionHandler(.cancel)
            return
        }
//        if tab == tabManager.selectedTab {
//
//        }

        if isStoreURL(url) {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    fileprivate func isStoreURL(_ url: URL) -> Bool {
        if url.scheme == "http" || url.scheme == "https" || url.scheme == "itms-apps" {
            if url.host == "itunes.apple.com" {
                return true
            }
        }
        return false
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Log.debug("\(webView.title) --- \(webView.url?.absoluteString)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Log.debug("\(webView.title) --- \(webView.url?.absoluteString) ")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Log.debug("\(webView.title) --- \(webView.url?.absoluteString) ")

        if let tab = tabManager.selectedTab {
            setupNavigationStash(tab, webView)
        }

        if !UserDefaults.standard.bool(forKey: "kIncognitoState"),
           let url = webView.url,
           (url.scheme == "http" || url.scheme == "https") {
            let historyTable = MDHistoryTable()
            var item = MDHistoryModel()
            item.url = webView.url?.absoluteString
            item.title = webView.title
            historyTable.insert(item)
        }

        if isLocal {
            return
        }
//        self.searchFl?.text = webView.url?.absoluteString
    }

    func setupNavigationStash(_ tab: MDTabModel, _ webView: WKWebView) {
        var urlList = Array<String>()
        let backlist = tab.webView.backForwardList.backList
        backlist.forEach { item in
            let url = item.initialURL.absoluteString
            urlList.append(url)
        }
        let current = tab.webView.backForwardList.currentItem
        if let item = current {
            let url = item.initialURL.absoluteString
            urlList.append(url)
            tab.url = url
        }
        let fowardList = tab.webView.backForwardList.forwardList
        fowardList.forEach { item in
            let url = item.initialURL.absoluteString
            urlList.append(url)
        }
        tab.list = urlList
        let table = MDTabTable()
        table.insert(tab)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 处理请求超时错误
        if (error as NSError).code == NSURLErrorTimedOut {
            // 取消加载
            webView.stopLoading()
            // 显示错误信息
//            showErrorPage()
        }
    }
}
