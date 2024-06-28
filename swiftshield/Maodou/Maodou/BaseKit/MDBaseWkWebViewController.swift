//
//  MDBaseWkWebViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/6/2.
//

import UIKit
import WebKit

class MDBaseWkWebViewController: MDBaseViewController {
    
    var urlString:String?
    
    var localString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        guard let url = urlString,let url = URL(string: url) else {
            guard let url = Bundle.main.url(forResource: localString, withExtension: "html") else {
                return
            }
            let request = URLRequest(url: url)
            wkWebView.load(request)
            return
        }
        let request = URLRequest(url: url)
        wkWebView.load(request)
    }
    
    lazy var wkWebView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.backgroundColor = UIColor.white
        webView.isOpaque = false
        return webView
    }()

}
