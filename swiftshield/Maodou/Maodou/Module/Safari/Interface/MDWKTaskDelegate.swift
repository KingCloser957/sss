//
//  MDWKTaskDelegate.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WebKit

class MDWKTaskDelegate: NSObject {
    weak var urlSchemeTask:WKURLSchemeTask?
}

extension MDWKTaskDelegate : URLSessionDataDelegate {

    //重定向处理
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        debugPrint(String(describing: request.url?.absoluteString))
        debugPrint(response.statusCode)
        debugPrint(response.allHeaderFields["Location"] as? String)
    }

    //task相关的response回调
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void){

        guard let response = response as? HTTPURLResponse else {
            completionHandler(.cancel)
            return
        }
        let headerField = modifierResponseHeader(response)

        guard let url = response.url else {
            completionHandler(.cancel)
            return
        }
        guard let newResponse = HTTPURLResponse.init(url: url, statusCode: response.statusCode, httpVersion: nil, headerFields: headerField as? [String:String]) else {
            completionHandler(.cancel)
            return
        }
        urlSchemeTask?.didReceive(newResponse)
        completionHandler(.allow)
    }

    static let specialKeys = ["content-security-policy",
                              "content-security-policy-report-only",
                              "expect-ct",
                              "report-to",
                              "x-content-security-policy",
                              "x-webkit-csp",
                              "x-xss-protection",
                              "x-permitted-cross-domain-policies",
                              "x-content-type-options",
                              "x-frame-options",
                              "permissions-policy",
                              "timing-allow-origin",
                              "cross-origin-embedder-policy",
                              "cross-origin-opener-policy",
                              "cross-origin-opener-policy-report-only",
                              "cross-origin-embedder-policy-report-only"]

    private func modifierResponseHeader(_ header: HTTPURLResponse) -> [String: Any]? {
        var headerField: [String: Any] = [:]
        for (key, value) in header.allHeaderFields {
            let newKey = (key as! String).lowercased()
            if !MDWKTaskDelegate.specialKeys.contains(newKey) {
                headerField[key as! String] = value
            }
        }
        return headerField
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        urlSchemeTask?.didReceive(data)
    }

    //task结果回调

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        debugPrint(task.currentRequest?.url as Any)
        if let e = error {
            urlSchemeTask?.didFailWithError(e)
            debugPrint("error \(task.currentRequest?.url?.absoluteString) >>> \(error?.localizedDescription)")
        }else{
            urlSchemeTask?.didFinish()
        }
    }
}
