//
//  MDSafariViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import WebKit
import Zip

let webViewURLKey = "URL"
let webViewLoadingKey = "loading"
let webViewCanBackKey = "canGoBack"
let webViewCanForwardKey = "canGoForward"
let webViewTitleKey = "title"
let kTeaAppJump = "tea_app_jump"
let kConnectAppJump = "connect_app_jump"
let kOpenUrlByUi = "open_url_by_ui"

let processPool = WKProcessPool.init()

class MDSafariViewController: MDBaseViewController {
    
    private var schemeHandler:MDURLSchemeHandler?
    
    public var url:URL?
    
    lazy var searchVc = MDSearchViewController(tabManager: MDTabManager())

    var urlString:String?
    var contentFile:URL?
    var fileName:String?
    var pageRoot:URL?
    var connectRoot:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.clear

        view.addSubview(backGroudView)
        backGroudView.addSubview(_3dLabel)
        backGroudView.addSubview(topSearchView)
        backGroudView.addSubview(containerView)
        backGroudView.addSubview(multipleTab)
        
        backGroudView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        _3dLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(112)
            make.centerX.equalToSuperview()
        }

        topSearchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(_3dLabel.snp.bottom).offset(80)
            make.height.equalTo(60)
        }

        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topSearchView.snp.bottom)
            make.bottom.equalToSuperview()
        }

        multipleTab.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topSearchView.snp.bottom)
            make.bottom.equalToSuperview()
        }

    }
    
    lazy var backGroudView: UIImageView = {
        let contentView = UIImageView.init()
        contentView.image = UIImage.init(named: "bg2")
        contentView.contentMode = .scaleAspectFill
        contentView.layer.masksToBounds = true
        contentView.isUserInteractionEnabled = true
        return contentView
    }()
    
    lazy var topSearchView: MDWebHeaderView = {
        let view = MDWebHeaderView.init(frame: .zero)
        view.backgroundColor = .clear
        view.text = ""
        return view
    }()
    
    lazy var containerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = .clear
        return cView
    }()
    
    lazy var _3dLabel: CBJ3DLabel = {
        let view = CBJ3DLabel(frame: CGRectMake(0, 0, 180, 70))
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 40)
        view.text = "Monkey Proxy"
        view.textColor = UIColor.hexColor(0x6064EF)
        return view
    }()
    
    lazy var multipleTab: MDMultipletabsView = {
        let view = MDMultipletabsView(frame: .zero)
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
}

extension MDSafariViewController:MDHeaderProtocol {
    func refreshAction() {
        
    }

    func didBackAction() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func didTapAction() {
        if MDSearchEngine.searchEngine.details?.autocompleteUrl?.isEmpty ?? true {
            return
        }
        let navVc = MDBrowserNavigtionViewController(rootViewController: searchVc)
        navVc.modalPresentationStyle = .fullScreen
        self.present(navVc, animated: true)
    }
}

extension MDSafariViewController:MultipletabsDelegate {
    func tapBilibili() {
        let searchVc = MDSearchViewController(tabManager: MDTabManager.shareInstance)
        searchVc.url = URL(string: "https://www.reddit.com")!
        let navVc = MDBrowserNavigtionViewController(rootViewController: searchVc)
        navVc.modalPresentationStyle = .fullScreen
        self.present(navVc, animated: true)
    }
    
    func tapBookmarks() {
        let searchVc = MDSearchViewController(tabManager: MDTabManager.shareInstance)
        searchVc.url = URL(string: "https://x.com")!
        let navVc = MDBrowserNavigtionViewController(rootViewController: searchVc)
        navVc.modalPresentationStyle = .fullScreen
        self.present(navVc, animated: true)
    }
    
    func tapFile() {
        let searchVc = MDSearchViewController(tabManager: MDTabManager.shareInstance)
        searchVc.url = URL(string: "https://www.linkedin.com/")!
        let navVc = MDBrowserNavigtionViewController(rootViewController: searchVc)
        navVc.modalPresentationStyle = .fullScreen
        self.present(navVc, animated: true)
    }
    
    func tapGoogle() {
        let searchVc = MDSearchViewController(tabManager: MDTabManager.shareInstance)
        searchVc.url = URL(string: "https://www.yahoo.com")!
        let navVc = MDBrowserNavigtionViewController(rootViewController: searchVc)
        navVc.modalPresentationStyle = .fullScreen
        self.present(navVc, animated: true)
    }
    
    func tapYoutube() {
        let searchVc = MDSearchViewController(tabManager: MDTabManager.shareInstance)
        searchVc.url = URL(string: "https://youtube.com/")!
        let navVc = MDBrowserNavigtionViewController(rootViewController: searchVc)
        navVc.modalPresentationStyle = .fullScreen
        self.present(navVc, animated: true)
    }
}
