//
//  MDURLSchemeHandler.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WebKit

class MDURLSchemeHandler: NSObject, URLSessionDelegate {
    
    //MARK: -- life cycle
    
    override init() {
        super.init()
    }
    
    deinit {
        debugPrint("对象销毁\(String(describing: object_getClass(self)))")
    }

}

extension MDURLSchemeHandler {

    private func restoreAction(_ urlSchemeTask:WKURLSchemeTask){
        guard let url = urlSchemeTask.request.url else { return }
        guard let restoreFilePath = Bundle.main.path(forResource: "RestoreSession", ofType: ".html") else { return }
        let html = try! String.init(contentsOfFile: restoreFilePath)
        let newHtml = html.replacingOccurrences(of: "{{$pageUrl}}", with: url.absoluteString)
        let data = newHtml.data(using: .utf8)
        let response = HTTPURLResponse.init(url: url, mimeType: "text/html", expectedContentLength: -1, textEncodingName: "utf-8")
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data!)
        urlSchemeTask.didFinish()
    }
    
    private func historyAction(_ urlSchemeTask:WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else { return }
        guard let query = url.query else { return }
        let targetUrl = query.replacingOccurrences(of: "url=", with: "")
        let htmlStr = String.init(format: "<!DOCTYPE html><html><head><script>location.replace('%@');</script></head></html>", targetUrl)
        let data = htmlStr.data(using: .utf8)
        let response = HTTPURLResponse.init(url: url, mimeType: "text/html", expectedContentLength: -1, textEncodingName: "utf-8")
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data!)
        urlSchemeTask.didFinish()
    }
}

extension MDURLSchemeHandler : WKURLSchemeHandler {
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard var url = urlSchemeTask.request.url else { return }

        //恢复旧的界面
        if url.path == "/restore" {
            restoreAction(urlSchemeTask)
            return
        }else if url.path == "/history" {
            historyAction(urlSchemeTask)
            return
        }
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask){
        debugPrint("stop >>> \(urlSchemeTask.request.url!)")
    }
}
