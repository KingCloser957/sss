//
//  MDWebView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WebKit
import Zip
import SwiftUI

class MDWebView: WKWebView {
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        backgroundColor = UIColor.white
        addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        addSubview(progressView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
    deinit {
        debugPrint("对象销毁 \(String(describing: object_getClass(self)))")
        removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    //    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    //        if action == #selector(copy(_:)) || action == #selector(select(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
    //            return true
    //        }
    //        return false
    //    }
    
    func loadHome(_ urlStr: String?){
        guard let urlStr = urlStr else { return }
        guard let url = URL.init(string: urlStr) else {
            return
        }
        let request = URLRequest.init(url:url)
        load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "estimatedProgress"){
            progressView.progress = Float(estimatedProgress)
            progressView.isHidden = estimatedProgress >= 1.0
        }
    }
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView.init(progressViewStyle: .bar)
        view.tintColor = UIColor.hexColor(0x2196F3)
        view.backgroundColor = UIColor.hexColor(hexColor:0x2196F3, alpha: 0.3)
        return view
    }()
}

var responseKey = "responseKey"

extension WKWebView {
    
    class func swizzleMethod(){
        let originalSelector = #selector(WKWebView.handlesURLScheme(_:))
        let swizzleSelector = #selector(WKWebView.ss_handlesURLScheme(_:))
        swizzleMethod(for: WKWebView.self, originalSelector: originalSelector, swizzledSelector: swizzleSelector)
    }
    
    @objc class func ss_handlesURLScheme(_ urlScheme: String) -> Bool {
        print(#function)
        if urlScheme == "http" || urlScheme == "https" || urlScheme == "internal" || urlScheme == "chrome-search" {
            return false
        }
        
        return ss_handlesURLScheme(urlScheme)
    }
    
    private class func swizzleMethod(for aClass: AnyClass, originalSelector: Selector,swizzledSelector: Selector) {
        let originalMethod = class_getClassMethod(aClass, originalSelector)
        let swizzledMethod = class_getClassMethod(aClass, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
    
    var responseHeader:HTTPURLResponse? {
        get{
            objc_getAssociatedObject(self, &responseKey) as? HTTPURLResponse
        }
        set{
            objc_setAssociatedObject(self, &responseKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
