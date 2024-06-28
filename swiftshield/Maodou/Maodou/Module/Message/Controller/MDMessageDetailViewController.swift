//
//  MDMessageDetailViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import WebKit

class MDMessageDetailViewController: MDBaseViewController {
    
    private var model: MDMessageModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(_ model: MDMessageModel?) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    func setupUI() {
//        title = "MESSAGE_TITLE".localizable()
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: kNavBarH + 14, left: 12, bottom: 27, right: 12))
        }
    }

    func setupData() {

        guard let title = model?.title, let time = model?.createTime ,let body = model?.body else { return }
        guard let htmlPath = Bundle.main.path(forResource: "messageDetail", ofType: "html") else {
            return
        }
        guard var htmlText = try? String(contentsOfFile: htmlPath, encoding: .utf8) else {
            return
        }
        htmlText = htmlText.replacingOccurrences(of: "orchidTitle", with: title)
        htmlText = htmlText.replacingOccurrences(of: "orchidTime", with: time)
        htmlText = htmlText.replacingOccurrences(of: "orchidInfo", with: body)
        webView.loadHTMLString(htmlText, baseURL: nil)
    }

    @objc
    func handleTap(_ tap: UITapGestureRecognizer) {
        guard let textView = tap.view as? UITextView else {
            return
        }
        let location = tap.location(in: textView)
        guard let position = textView.closestPosition(to: location) else {
            return
        }
        guard let att = textView.textStyling(at: position, in: .forward) else {
            return
        }
        if (att.keys.contains(.link)) {
            open(att[.link] as? URL)
        }
    }

    private func open(_ link: URL?) {
        guard let url = link else {
            return
        }
        if url.scheme != "orchid" {
            toSafari(url)
            return
        }
        if url.host == "home"{
//            let homeVC = navigationController?.children.first
//            if homeVC != nil {
//                navigationController?.popToViewController(homeVC!, animated: true)
//            }
        } else if url.host == "buy" {
//            let upgradeVC = OOUpgradViewController()
//            let nav = OOBaseNavigationViewController(rootViewController: upgradeVC)
//            navigationController?.present(nav, animated: true)
        } else if url.host == "my" {
//            let accountInfo = OOAccountInfoViewController()
//            navigationController?.pushViewController(accountInfo, animated: true)
        } else if url.host == "newsList" {
            navigationController?.popViewController(animated: true)
        }
    }

    private func parse(_ query: String) -> [String: String] {
        let arr = query.split(separator: "&")
        var params: [String:String] = [:]
        for item in arr {
            let list = item.split(separator: "=")
            if let key = list.first {
                params[String(key)] = String(list.last ?? "")
            }
        }
        return params
    }

    private func toSafari(_ url: URL) {
        if !UIApplication.shared.canOpenURL(url) {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let web = WKWebView(frame: .zero, configuration: config)
        web.isOpaque = false
        web.layer.cornerRadius = 15
        web.clipsToBounds = true
        web.backgroundColor = view.backgroundColor
        web.navigationDelegate = self
        web.scrollView.showsVerticalScrollIndicator = false
        view.addSubview(web)
        return web
    }()
}

extension MDMessageDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            open(navigationAction.request.url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
