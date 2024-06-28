//
//  SSScriptMessageHandlerTarget.swift
//  StarSpeedBrowser
//
//  Created by 李白 on 2022/3/2.
//

import UIKit
import WebKit

class MDScriptMessageHandlerTarget: NSObject, WKScriptMessageHandler{
    
    private weak var scriptDeleagte:WKScriptMessageHandler?
    
    init(_ messageHandler:WKScriptMessageHandler?){
        super.init()
        scriptDeleagte = messageHandler
    }
    
    deinit {
        debugPrint("对象销毁\(String(describing: object_getClass(self)))")
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let scriptDeleagte = scriptDeleagte else {
            return
        }
        scriptDeleagte.userContentController(userContentController, didReceive: message)
    }
}
