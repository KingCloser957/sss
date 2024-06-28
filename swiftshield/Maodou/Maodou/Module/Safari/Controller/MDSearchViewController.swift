//
//  MDSearchViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import WebKit
import Zip

class MDSearchViewController: MDBaseViewController {
    
    var searchOngoing:Bool? = false {
        didSet {
            if searchOngoing ?? false {
                DispatchQueue.main.async {
                    if let view = self.tabManager.selectedTab?.webView {
                        self.tableView.isHidden = false
                        view.isHidden = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let view = self.tabManager.selectedTab?.webView {
                        self.tableView.isHidden = true
                        view.isHidden = false
                    }
                }
            }
        }
    }
    
    private var lastQuery: String?
    private var results = [String]()
    private var insets:UIEdgeInsets = .zero
    var isLocal:Bool = false
    var searchFl:UITextField?
    
    let tabManager: MDTabManager!
    
    init(tabManager: MDTabManager) {
        self.tabManager = tabManager
        super.init(nibName: nil, bundle: nil)
        didInit()
    }
    
    var url:URL? {
        didSet {
            if let url = url {
                self.tabManager.selectedTab?.webView.load(URLRequest(url: url))
            } else {
                self.tabManager.selectedTab?.webView.load(URLRequest(url: URL.default))
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didInit() {
        self.tabManager.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchFl?.becomeFirstResponder()
        addObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchFl?.resignFirstResponder()
        removeObserver()
    }
    
    
    fileprivate func addObserver(){
        let nc = NotificationCenter.default
        
        nc.addObserver(self,
                       selector: #selector(keyboardWillShow(notification:)),
                       name: UIResponder.keyboardWillShowNotification,
                       object: nil)
        
        nc.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)),
                       name: UIResponder.keyboardWillHideNotification,
                       object: nil)
        
        nc.addObserver(self, selector: #selector(textFiledDidChange(notification:)),
                       name: UITextField.textDidChangeNotification,
                       object: nil)
        
        nc.addObserver(self,
                       selector: #selector(didEnterBackgroundNotification),
                       name: UIApplication.didEnterBackgroundNotification,
                       object: nil)
    }
    
    fileprivate  func removeObserver() {
        
        let nc = NotificationCenter.default
        
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        nc.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        nc.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        self.tableView.bounces = false
        self.tableView.showsHorizontalScrollIndicator = false
    }
    
    func setupUI() {
        view.backgroundColor = kThemeColor
        
        view.addSubview(searchBar)
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        view.addSubview(toolsBarView)
        searchFl = searchBar.textFiled
        searchFl?.delegate = self
        
        searchBar.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(kScreenW)
            make.top.equalToSuperview().offset(kStatusBarH)
            make.height.equalTo(51)
        }
        
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.bottom.equalTo(toolsBarView.snp.top).offset(-5)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toolsBarView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(49 + kBottomH)
        }
    }
    
    func setupData() {
        tabManager.restore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let kbSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        }
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        if let kbSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.tableView.contentInset = .zero
            self.tableView.scrollIndicatorInsets = .zero
        }
    }
    
    @objc func textFiledDidChange(notification:Notification) {
        if let obj = notification.object as? UITextField {
            if ((obj.text?.isEmpty) != nil) {
                self.results.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    @objc
    func didEnterBackgroundNotification() {
//        if let tab = tabManager.selectedTab {
//            var snapshot = tab.webView.snapshotImage(afterScreenUpdates: true)
//            if tab.url == nil {
//                snapshot = containerView.snapshotImage(afterScreenUpdates: true)
//            }
//            saveSnapshot(snapshot, tab.id)
//        }
    }
    
    lazy var containerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = .clear
        return cView
    }()
    
    lazy var tableView: UITableView = {
        let ctableView = UITableView.newTableViewGroupedWithTarget(target: self)
        ctableView.backgroundColor = .clear
        ctableView.rowHeight = 56
        ctableView.register(MDSearchResultCell.self, forCellReuseIdentifier: "MDSearchResultCell")
        ctableView.isScrollEnabled = true
        return ctableView
    }()
    
    lazy var searchBar: MDSearchBar = {
        let view = MDSearchBar(frame: .zero)
        view.delegate = self
        view.backgroundColor = kThemeColor
        return view
    }()
    
    lazy var toolsBarView: MDToolsBarView = {
        let toolBar = MDToolsBarView(frame: .zero)
        toolBar.backgroundColor = .white
        return toolBar
    }()
    
    @objc
    func hide() {
        if !(searchOngoing ?? true) {
            return
        }
        self.navigationController?.dismiss(animated: true)
        searchOngoing = false
    }
    
    func showErrorPage() {
        let pageRoot = documentsDirectory.appendingPathComponent("page")
        let connectRoot = pageRoot.appendingPathComponent("errorPage")
        let fileName = "errorPage"
        let pageFile = connectRoot.appendingPathComponent("index.html")
        
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: "zip") else {
            return
        }
        var pdfxPath = documentsDirectory.appendingPathComponent("private/\(fileName).zip")
        if !FileManager.default.fileExists(atPath: pdfxPath.path) {
            try? FileManager.default.copyItem(at: filePath, to: pdfxPath)
            pdfxPath = filePath
        }
        try? Zip.unzipFile(pdfxPath, destination: connectRoot, overwrite: true, password: nil, progress: { progress in
            if progress != 1.0 { return }
            self.tabManager.selectedTab?.webView.loadFileURL(pageFile, allowingReadAccessTo: pageRoot)
        })
    }
    
    fileprivate  func update(_ query: String?,_ isSearch: Bool?) {
        let query = query?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if query.isEmpty
            || lastQuery?.caseInsensitiveCompare(query) == .orderedSame {
            return
        }
        guard let request = self.constructRequest(query, autocomplete: true) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[\(String(describing: type(of: self)))] failed auto-completing: \(error)")
                return
            }
            if self.lastQuery != query {
                print("[\(String(describing: type(of: self)))] stale query results, ignoring")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("[\(String(describing: type(of: self)))] not a HTTP response")
                return
            }
            if response.statusCode != 200 {
                print("[\(String(describing: type(of: self)))] failed auto-completing, status \(response.statusCode)")
                return
            }
            if let data = data {
                if let contentType = (response.allHeaderFields["Content-Type"] as? String)?.lowercased(),
                   contentType.contains("javascript") || contentType.contains("json") {
                    if let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any],
                       result.count > 1 {
                        self.searchOngoing = true
                        self.results = result[1] as? [String] ?? []
                    }
                    else {
                        print("[\(String(describing: type(of: self)))] failed parsing JSON: \(data)")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        task.resume()
        
        lastQuery = query
    }
    
    func constructRequest(_ query: String?, autocomplete: Bool = false) -> URLRequest? {
        guard let se = MDSearchEngine.searchEngine.details,
              var searchUrl = autocomplete ? se.autocompleteUrl : se.searchUrl,
              let query = query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        var params: [String]?
        
        if let pp = se.postParams {
            params = []
            
            for item in pp {
                guard let key = item.key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    continue
                }
                params?.append([key, String(format: item.value, query)].joined(separator: "="))
            }
        }
        else {
            searchUrl = String(format: searchUrl, query)
        }
        guard let url = URL(string: searchUrl) else {
            return nil
        }
        var request = URLRequest(url: url)
        if let postParams = params?.joined(separator: "&") {
            request.httpMethod = "POST"
            request.httpBody = postParams.data(using: .utf8)
        }
        return request
    }
}

extension MDSearchViewController:MDSearchBarProtocol {
    func searchBarDoSearch(with bar: MDSearchBar) {
        let search = searchFl?.text
        DispatchQueue.main.async {
            self.searchFl?.resignFirstResponder()
            MDWebsiteStorage.shared.cleanup()
            if let url = self.parseSearch(search) {
                debugPrint("#textFieldShouldReturn url = \(url)")
                self.searchOngoing = false
                self.tabManager.selectedTab?.webView.load(URLRequest(url: url))
            } else {
                debugPrint("#textFieldShouldReturn search = \(String(describing: search))")
                self.tabManager.selectedTab?.webView.load(self.constructRequest(search) ?? URLRequest(url: URL.default))
            }
        }
    }
    
    func searchBarDoReload(with bar: MDSearchBar) {
        self.tabManager.selectedTab?.webView.reload()
    }
    
    func searchBarDoBack(with bar: MDSearchBar) {
        self.navigationController?.dismiss(animated: true)
    }
    
    func searchBarDoChooseEngnine(with bar: MDSearchBar) {
        let engnineVc = MDEngnineViewController.init()
        engnineVc.delegate = self
        navigationController?.pushViewController(engnineVc, animated: true)
    }
}

extension MDSearchViewController:MDEngnineViewControllerDelegate {
    func didSelectEngnine(_ engnine: SearchEngine) {
        if let view = searchFl?.leftView?.subviews.last as? UIButton {
            view.setImage(UIImage(named: engnine.details?.searchIcon ?? "baidu"), for: .normal)
            searchFl?.text = engnine.details?.homepageUrl
            MDSearchEngine.searchEngine = engnine
        }
    }
}

extension MDSearchViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        debugPrint("#textFieldDidBeginEditing")
        updateSearchField()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let search = textField.text
        self.searchOngoing = false
        if let url = self.parseSearch(search) {
            debugPrint("#textFieldShouldReturn url=\(url)")
            tabManager.selectedTab?.webView.load(URLRequest(url: url))
        } else {
            self.update(search, searchOngoing == true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let search = searchFl?.text
        DispatchQueue.main.async {
            textField.resignFirstResponder()
            MDWebsiteStorage.shared.cleanup()
            if let url = self.parseSearch(search) {
                debugPrint("#textFieldShouldReturn url = \(url)")
                self.searchOngoing = false
                self.tabManager.selectedTab?.webView.load(URLRequest(url: url))
            } else {
                debugPrint("#textFieldShouldReturn search = \(String(describing: search))")
                self.tabManager.selectedTab?.webView.load(self.constructRequest(search) ?? URLRequest(url: URL.default))
            }
        }
        return true
    }
    
    func updateSearchField() {
        //        if searchFl?.isFirstResponder ?? false {
        //            if searchFl?.textAlignment == .natural {
        //                return
        //            }
        ////            searchFl?.text = self.url?.absoluteString
        //        }
        //        else {
        //            searchFl?.text = self.prettyTitle(self.url)
        //            searchFl?.rightViewMode = searchFl?.text?.isEmpty ?? true ? .always : .never
        //            searchFl?.textAlignment = .center
        //        }
    }
    
    func prettyTitle(_ url: URL?) -> String {
        if let host = url?.host {
            return host.replacingOccurrences(of: #"^www\d*\."#, with: "", options: .regularExpression)
        }
        return url?.absoluteString ?? URL.default.absoluteString
    }
    
    public func parseSearch(_ search: String?) -> URL? {
        // Must not be empty, must not be the explicit blank page.
        if let search = search,
           !search.isEmpty {
            
            // blank page, return that.
            if search.caseInsensitiveCompare(URL.blank.absoluteString) == .orderedSame {
                return URL.blank
            }
            
            if search.range(of: #"\s+"#, options: .regularExpression) != nil
                || !search.contains(".") {
                // Search contains spaces or contains no dots. That's really a search!
                return nil
            }
            
            // We rely on URLComponents parsing style! *Don't* change to URL!
            if let urlc = URLComponents(string: search) {
                let scheme = urlc.scheme?.lowercased() ?? ""
                
                if scheme.isEmpty {
                    // Set missing scheme to HTTP.
                    return URL(string: "http://\(search)")
                }
                
                if scheme != "about" && scheme != "file" {
                    if urlc.host?.isEmpty ?? true
                        && urlc.path.range(of: #"^\d+"#, options: .regularExpression) != nil {
                        
                        // A scheme, no host, path begins with numbers. Seems like "example.com:1234" was parsed wrongly.
                        return URL(string: "http://\(search)")
                    }
                    return urlc.url
                }
            }
        }
        return URL.default
    }
}


extension MDSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDSearchResultCell")
        guard let newCell = cell as? MDSearchResultCell else { return cell! }
        newCell.contentView.backgroundColor = kThemeColor
        newCell.refreshUI(with: model)
        return newCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MDSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let search = results[indexPath.row]
        //        searchFl?.text = search
        DispatchQueue.main.async {
            if let url = self.parseSearch(search) {
                debugPrint("#textFieldShouldReturn url = \(url)")
                self.searchOngoing = false
                self.tabManager.selectedTab?.webView.load(URLRequest(url: url))
            } else {
                debugPrint("#textFieldShouldReturn search = \(String(describing: search))")
                self.searchOngoing = false
                self.tabManager.selectedTab?.webView.load(self.constructRequest(search) ?? URLRequest(url: URL.default))
            }
        }
    }
}

extension MDSearchViewController: MDTabManagerProtocol {
    
    func tabManager(_ tabManager: MDTabManager, didAddTab tab: MDTabModel) {
        tab.delegate = self
        
    }
    
    func tabManager(_ tabManager: MDTabManager, didSelectedTabChange selected: MDTabModel?, previous: MDTabModel?) {
        if let wv = previous?.webView {
            wv.endEditing(true)
            wv.removeFromSuperview()
        }
        if let tab = selected {
            if let url = url {
                tab.webView.load(URLRequest(url: url))
            }
            containerView.addSubview(tab.webView)
            tab.webView.frame = containerView.bounds
        }
    }
    
    func tabManager(_ tabManager: MDTabManager, didRemoveTab tab: MDTabModel?) {
        
    }
    
    func tabManagerDidRemoveAllTabs(_ tabManager: MDTabManager) {
        
    }
    
    func tabManagerUpdateCount(_ tabManager: MDTabManager, count: Int) {
        let title = "\(count)"
        toolsBarView.numBtn.setTitle(title, for: .normal)
    }
}

extension MDSearchViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        if name == "getAllImageHelper" {
            guard let json = message.body as? [String: Any],
                  let res = json["res"] as? String,
                  let imagse = res.convertToArray() as? [String] else {
                return
            }
            let vc = MDPageImagesViewController(imageUrls: imagse)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MDSearchViewController: MDTabProtocol {
    func tab(_ tab: MDTabModel, didCreateWebView webView: WKWebView) {
        webView.frame = containerView.frame
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        let userContentController = webView.configuration.userContentController
        let target = MDScriptMessageHandlerTarget(self)
        userContentController.add(target, name: "getAllImageHelper")
    }
    
    func tab(_ tab: MDTabModel, willDeleteWebView webView: WKWebView) {
        
    }
    
    func tab(_ tab: MDTabModel, urlChange url: URL) {
        if tab != tabManager.selectedTab {
            return
        }
        tab.url = url.absoluteString
        //        searchFl?.text = url.absoluteString
    }
    
    func tab(_ tab: MDTabModel, loadingStateChange state: Bool) {
        if tab != tabManager.selectedTab {
            return
        }
    }
}

extension MDSearchViewController:MDWebToolViewProtocol {
    func backAction() {
        if !(tabManager.selectedTab?.canGoBack ?? false) {
            //            multipleTab.isHidden = false
            //            topSearchView.textLab.text = ""
            return
        }
        tabManager.selectedTab?.goBack()
    }
    
    func reloadAction() {
        tabManager.selectedTab?.reload()
    }
    
    func forwardAction() {
        //        if multipleTab.isHidden == false && !(tabManager.selectedTab?.url?.isEmpty ?? false) {
        //            multipleTab.isHidden = true
        //            return
        //        }
        if !(tabManager.selectedTab?.canGoForward ?? false) {
            return
        }
        tabManager.selectedTab?.goForward()
    }
    
    func addTableAction() {
        tabManager.add()
        searchFl?.text = ""
    }
    
    func showTabsAction() {
//        if let tab = tabManager.selectedTab {
//            var snapshot = tab.webView.snapshotImage(afterScreenUpdates: true)
//            if tab.url == nil {
//                snapshot = containerView.snapshotImage(afterScreenUpdates: true)
//            }
//            saveSnapshot(snapshot, tab.id)
//        }
//        let gridVc =  MDGridViewController(tabManager: tabManager)
//        gridVc.modalPresentationStyle = .fullScreen
//        present(gridVc, animated: true)
    }
    
    private func saveSnapshot(_ image:UIImage?, _ name: String){
        guard let img = image else {
            return
        }
        if let imgData = img.pngData() {
            let folder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0].appendingPathComponent("snapshot")
            let snapshotPath = folder.appendingPathComponent("\(name).png")
            do {
                let ok = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
                ok[0] = true
                let val = ok
                let exists = FileManager.default.fileExists(atPath: folder.path, isDirectory: val)
                if !exists {
                    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
                }
                try imgData.write(to:snapshotPath, options: .atomic)
            }catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func moreAction() {
        let menuView = MDWebMenuView(frame: view.bounds, tab: tabManager.selectedTab)
        menuView.delegate = self
        menuView.show()
        view.addSubview(menuView)
    }
}

extension MDSearchViewController: MDWebMenuViewProtocol {
    func didSelected( _ menuView: MDWebMenuView, _ index: Int) {
        menuView.dismiss()
        Log.debug(index)
        switch index {
        case 0:
            toBookmark()
        case 1:
            toHistory()
        case 2:
            toDownload()
        case 3:
            addBookmark()
        case 4:
            toggleIncognitoState()
        case 5:
            tabManager.selectedTab?.reload()
            break
        case 6:
            noImageMode()
        case 7:
            imageMode()
        default:
            break
        }
    }
    
    func toDownload() {
        let engnineVc = MDEngnineViewController()
        navigationController?.pushViewController(engnineVc, animated: true)
        //        let vc = BPDownloadViewController()
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toSetPage() {
        //        let vc = BPSettingViewController()
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    func noImageMode() {
        var noImageMode = UserDefaults.standard.bool(forKey: "kNoImageMode")
        noImageMode = !noImageMode
        UserDefaults.standard.set(noImageMode, forKey: "kNoImageMode")
        UserDefaults.standard.synchronize()
        
        guard let tab = tabManager.selectedTab else {
            return
        }
        tabManager.tabs.forEach{$0.noImageMode = noImageMode}
        tab.reload()
    }
    
    func toggleIncognitoState() {
        var incognitoState = UserDefaults.standard.bool(forKey: "kIncognitoState")
        incognitoState = !incognitoState
        UserDefaults.standard.set(incognitoState, forKey: "kIncognitoState")
        UserDefaults.standard.synchronize()
    }
    
    func imageMode() {
        if let webView = tabManager.selectedTab?.webView {
            webView.evaluateJavaScript("window.getAllImageHandler()") { (result, error) in
                
            }
        }
    }
    
    func toBookmark() {
        let vc = MDBookmarkViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toHistory() {
        let vc = MDHistoryViewController()
        vc.didSelectBlock = { [weak self](model) in
            guard let sSelf = self,
                  let urlStr = model.url,
                  let url = URL(string: urlStr) else {
                return
            }
            let request = URLRequest(url: url)
            sSelf.tabManager.selectedTab?.loadRequest(request)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addBookmark() {
        guard let tab = tabManager.selectedTab else {
            return
        }
        let table = MDBookmarkTable()
        if table.isContain(url: tab.url), let url = tab.url {
            table.delete(with: url)
            return
        }
        
        let id = UUID().uuidString
        var model = MDBookmarkModel()
        model.id = id
        model.title = tabManager.selectedTab?.webView.title
        model.url = tabManager.selectedTab?.webView.url?.absoluteString
        model.path = "/\(id)"
        
        do {
            try table.insert(model)
            showSelectFolderTipView(model)
        }
        catch {
            Log.debug(error.localizedDescription)
        }
    }
    
    func showSelectFolderTipView(_ model: MDBookmarkModel) {
        
        let tipView = MDBookmarkSelectFolderTipView()
        tipView.backgroundColor = UIColor.hexColor(0x000000)
        tipView.layer.cornerRadius = 17.5
        let workItem = DispatchWorkItem { [weak tipView] in
            guard let sTipView = tipView else {
                return
            }
            sTipView.removeFromSuperview()
        }
        tipView.toSelectFolderBlock = { [weak self, weak tipView] in
            guard let sSelf = self,
                  let sTipView = tipView else {
                return
            }
            workItem.cancel()
            sTipView.removeFromSuperview()
            let vc = MDBookmarkFolderSelectViewController(moveModel: model)
            let nav = MDBrowserNavigtionViewController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            sSelf.navigationController?.present(nav, animated: true)
        }
        view.addSubview(tipView)
        tipView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-20)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: workItem)
    }
}

extension MDSearchViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
