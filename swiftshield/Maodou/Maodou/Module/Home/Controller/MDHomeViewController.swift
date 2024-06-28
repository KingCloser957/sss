//
//  MDHomeViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/11.
//

import UIKit
import MBProgressHUD

enum OOProxyState: Int {
    case connect
    case disconnect
}

enum OOConnectLineType: Int {
    case connect        //连接按钮
    case switchMode     //切换模式
    case switchLine     //切换线路
}

class MDHomeViewController: MDBaseViewController {
    var datas:[MDHomeVPNModel] = []
    var nodesArray:[MKNodeTempeleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupData()
        setDefaultLine()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupViews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: appNameView)
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: upgradeBtn)
        self.view.addSubview(homeContentView)
    }
    
    lazy var homeContentView: MDHomeCircleView = {
        let view = MDHomeCircleView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.vpnDeleagte = self
        return view
    }()
    
    func setupData() {
        nodesArray.removeAll()
        for node in self.getDatas() {
            guard let model = MDCoderTool.fromDict(MKNodeTempeleModel.self
                                                   , node) else {
                return
            }
            nodesArray.append(model)
        }
        
        if MDGuidanceManager.shared.needShow() {
            var guidanceOne = MDGuidanceModel()
            let guidanceOneView = MDGuidanceStepOneView(frame: self.view.bounds)
            guidanceOne.guidanceView = guidanceOneView
            MDGuidanceManager.shared.addGuidanceItem(item: guidanceOne)
            
            var guidanceTwo = MDGuidanceModel()
            let guidanceTwoView = MDGuidanceStepTwoView(frame: self.view.bounds)
            guidanceTwo.guidanceView = guidanceTwoView
            MDGuidanceManager.shared.addGuidanceItem(item: guidanceTwo)
            
            var guidanceThree = MDGuidanceModel()
            let guidanceThreeView = MDGuidanceStepThreeView(frame: self.view.bounds)
            guidanceThree.guidanceView = guidanceThreeView
            MDGuidanceManager.shared.addGuidanceItem(item: guidanceThree)
            
            MDGuidanceManager.shared.beginGuidance(with: self.view)
        }
        
        VPNManager.shared.loadManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusChange), name: .NEVPNStatusDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func statusChange() {
        guard let manager = VPNManager.shared.manager else {
            self.homeContentView.homeCircleView.refreshUI(.pausing, lastSelectType() ?? .global)
            return
        }
        switch manager.connection.status {
        case .connected:
            print("已连接")
            debugPrint("代理开启")
            self.homeContentView.homeCircleView.refreshUI(.running, lastSelectType() ?? .global)
            //            connectBtnConnectedUI()
            changeProxyConnectState(.connect)
        case .connecting:
            print("正在连接")
        case .disconnected:
            print("未连接")
            debugPrint("代理断开")
            self.homeContentView.homeCircleView.refreshUI(.pausing, lastSelectType() ?? .global)
            //            connectBtnDisconnectUI()
            changeProxyConnectState(.disconnect)
        case .disconnecting:
            print("正在断开连接")
        default:
            print("其他状态")
        }
    }
    
    lazy var appNameView: UILabel = {
        let cView = UILabel.init()
        cView.text = "Monkey Proxy"
        cView.textColor = UIColor.hexColor(0xFFFFFF)
        cView.font = UIFont.light(16)
        cView.textAlignment = .left
        return cView
    }()
    
    lazy var upgradeBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 26.0, height: 22.8)
        button.setImage(UIImage.init(named: "VIP"), for: .normal)
        button.setImage(UIImage.init(named: "VIP"), for: .selected)
        button.addTarget(self, action: #selector(upgradeAction), for: .touchUpInside)
        return button
    }()
}

extension MDHomeViewController {
    @objc
    private func upgradeAction() {
        //        let upgradeVc = MKUpgradeViewController()
        //        let navVc = MKBaseNavigationController.init(rootViewController: upgradeVc)
        //        self.present(navVc, animated: true, completion: nil)
    }
    
    func setDefaultLine() {
        guard var lineModel = self.getDefaultNode() else {
            if self.nodesArray.count > 0 {
                guard var model = self.nodesArray.first else { return }
                model.modeType = VPNModeType(rawValue: 0)
                homeContentView.refreshUI(with: model)
                self.homeContentView.homeCircleView.refreshUI(.pausing,.global)
            }
            return
        }
        lineModel.modeType = lastSelectType() ?? .global
        homeContentView.refreshUI(with: lineModel)
        self.homeContentView.homeCircleView.refreshUI(.pausing,lastSelectType() ?? .global)
    }
    
    private func lastSelectType() -> VPNModeType? {
        let userDefault = UserDefaults(suiteName: kGroupId)
        guard let modeIndex = userDefault?.value(forKey: kProxyMode) as? Int else {
            return nil
        }
        return VPNModeType(rawValue: modeIndex)
    }
}

extension MDHomeViewController {
    func proxyConnectState() -> OOProxyState {
        let userDefaults = UserDefaults(suiteName: kGroupId)
        let state = userDefaults?.bool(forKey: "kProxyConnectionState") ?? false
        return state ? .connect : .disconnect
    }
    
    func changeProxyConnectState(_ state: OOProxyState) {
        let isConnect = state == .connect ? true : false
        let userDefaults = UserDefaults(suiteName: kGroupId)
        userDefaults?.set(isConnect, forKey: "kProxyConnectionState")
        userDefaults?.synchronize()
    }
    
    private func getDefaultNode() -> MKNodeTempeleModel? {
        let userDefault = UserDefaults(suiteName: kGroupId)
        guard let info = userDefault?.value(forKey: kProxyLineInfo) as? String else {
            if self.nodesArray.count > 0 {
                return self.nodesArray.first
            }
            return nil
        }
        debugPrint("缓存线路信息 >>> \(info)")
        let model = MDCoderTool.fromJson(MKNodeTempeleModel.self, info.convertToDictionary())
        return model
    }
    
    private func setDefaultNode(_ model: MKNodeTempeleModel?) {
        guard let model = model else {
            return
        }
        guard let json = MDCoderTool.toJson(model) else {
            return
        }
        let userDefault = UserDefaults(suiteName: kGroupId)
        userDefault?.setValue(json, forKey: kProxyLineInfo)
        userDefault?.synchronize()
    }
    
    fileprivate func connectLine(_ type: OOConnectLineType, hud: MBProgressHUD?) {
        VPNManager.shared.connect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.homeContentView.homeCircleView.refreshUI(.running, self.lastSelectType() ?? .global)
        }
    }
    
    @objc func stopVPN() {
        VPNManager.shared.disconnect()
    }
    
    //    func connectVPN(_ userInfo: MKUserInfo, _ data: [String: Any],  _ type: OOConnectLineType) {
    //
    //    }
    
    @objc
    func toUpgradeAction() {
        //        let vc = MKUpgradeViewController.init()
        //        let nav = MKBaseNavigationController.init(rootViewController: vc)
        //        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    func showModeView() {
        let modeView = MKHomeSelectModeView.init(frame: view.bounds)
        modeView.selectVPNModeBlock = { vpnMode  in
            var node = self.getDefaultNode()
            node?.modeType = vpnMode
            self.setDefaultNode(node)
            self.homeContentView.refreshUI(with: node!)
            self.stopProxy()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                self.startProxy()
            }
        }
        modeView.showAnimation()
    }
}

extension MDHomeViewController:MDHomeVPNConnectDelegate {
    @objc func stopProxy() {
        stopVPN()
        self.homeContentView.homeCircleView.refreshUI(.pausing, lastSelectType() ?? .global)
    }
    
    @objc func startProxy() {
        guard let model = getDefaultNode() else {
            let lineVc = MDLinesViewController.init(nodes: self.nodesArray)
            lineVc.didSelectLineBlock = { lineModel in
                self.selectLineAction(lineModel)
                self.datas[1].status = lineModel.title
            }
            self.navigationController?.pushViewController(lineVc, animated: true)
            return
        }
        self.homeContentView.homeCircleView.refreshUI(.loading, lastSelectType() ?? .global)
        connectLine(.connect, hud: nil)
    }
    
    func selectLineAction(_ model:MKNodeTempeleModel) {
        setDefaultNode(model)
        stopVPN()
        self.homeContentView.homeCircleView.refreshUI(.pausing, lastSelectType() ?? .global)
        
        if proxyConnectState() == .connect {
            self.homeContentView.homeCircleView.refreshUI(.pausing, lastSelectType() ?? .global)
            self.homeContentView.homeCircleView.beginLoadingAnimation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                self?.connectLine(.switchLine, hud: nil)
            }
        } else {
            self.homeContentView.homeCircleView.refreshUI(.pausing, lastSelectType() ?? .global)
            self.homeContentView.homeCircleView.beginLoadingAnimation()
        }
    }
}

extension MDHomeViewController:MDHomeCircleViewDelegate {
    func changeNodeRegion() {
        let lineVc = MDLinesViewController(nodes: self.nodesArray)
        lineVc.didSelectLineBlock = { lineModel in
            self.homeContentView.homeNodeView.refreshUI(with: lineModel)
            self.stopProxy()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                self.startProxy()
            }
        }
        let navVc = MDBaseNavigationController(rootViewController: lineVc)
        self.navigationController?.present(navVc, animated: true)
    }
    
    func changeNodeMode() {
        showModeView()
    }
}

extension MDHomeViewController:MDHomeAnimationViewDelegate {
    func switchNodeStatus() {
        if self.proxyConnectState() == .disconnect {
            self.startProxy()
        } else {
            self.stopProxy()
        }
    }
}

extension MDHomeViewController {
    public func getDatas() -> [[String: Any]] {
        return [
            [
                "id": "0",
                "title": "HongKong",
                "icon": "hongkong",
                "flag_icon": "hongkong_flag",
                "type": 0,
                "x": 114.109497,
                "y": 22.396428,
                "isSelected": true,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-HongKong",
                "mark":"supported Chat-gpt",
                "adress":"43.135.22.204"
            ],
            [
                "id": "1",
                "title": "Taiwan",
                "icon": "taiwan",
                "flag_icon": "taiwan_flag",
                "type": 0,
                "x": 121.566667,
                "y": 25.033333,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-Taiwan",
                "mark":"supported Chat-gpt",
                "adress":"220.130.213.85"
            ],
            [
                "id": "2",
                "title": "Japan",
                "icon": "japan",
                "flag_icon": "japan_flag",
                "type": 0,
                "x": 139.691711,
                "y": 35.689487,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-Japan",
                "mark":"supported Chat-gpt",
                "adress":"43.153.177.12"
                
            ],
            [
                "id": "3",
                "title": "Korea",
                "icon": "south-korea",
                "flag_icon": "south-korea_flag",
                "type": 0,
                "x": 126.977969,
                "y": 37.566535,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-Korea",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            [
                "id": "4",
                "title": "India",
                "icon": "bolivia",
                "flag_icon": "bolivia_flag",
                "type": 0,
                "x": 77.12,
                "y": 28.36,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-India",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            [
                "id": "5",
                "title": "America",
                "icon": "united-states-america",
                "flag_icon": "united-states-america_flag",
                "type": 0,
                "x": -77.036873,
                "y": 38.907192,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"North America - United States",
                "mark":"supported Chat-gpt",
                "adress":"43.153.103.97"
            ],
            [
                "id": "6",
                "title": "Vietnam",
                "icon": "vietnam",
                "flag_icon": "vietnam_flag",
                "type": 0,
                "x": 105.854167,
                "y": 21.028333,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-Vietnam",
                "mark":"supported Chat-gpt",
                "adress":"43.134.31.147"
            ],
            [
                "id": "7",
                "title": "Singapore",
                "icon": "singapore",
                "flag_icon": "singapore_flag",
                "type": 0,
                "x": 103.851959,
                "y": 1.290270,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-Singapore",
                "mark":"supported Chat-gpt",
                "adress":"43.134.31.147"
            ],
            [
                "id": "9",
                "title": "Brazil",
                "icon": "brazil",
                "flag_icon": "brazil_flag",
                "type": 0,
                "x": 47.882778,
                "y": -15.794444,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"South America-Brazil",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            [
                "id": "10",
                "title": "Australia",
                "icon": "australia",
                "flag_icon": "australia_flag",
                "type": 0,
                "x": 149.07,
                "y": 35.18,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-Australia",
                "mark":"supported Chat-gpt",
                "adress":"95.111.219.37"
            ],
            [
                "id": "11",
                "title": "France",
                "icon": "france",
                "flag_icon": "france_flag",
                "type": 0,
                "x": 2.352222,
                "y": 48.856614,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Europe-France",
                "mark":"supported Chat-gpt",
                "adress":"115.97.125.56"
            ],
            [
                "id": "12",
                "title": "Tonga",
                "icon": "france",
                "flag_icon": "france_flag",
                "type": 0,
                "x": 175.10,
                "y": 21.10,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Oceania-Tonga",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            [
                "id": "13",
                "title": "England",
                "icon": "England",
                "flag_icon": "England_flag",
                "type": 0,
                "x": -0.1278,
                "y": 51.5074,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Europe-England",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            [
                "id": "14",
                "title": "Italy",
                "icon": "italy",
                "flag_icon": "italy_flag",
                "type": 0,
                "x": 12.4964,
                "y": 41.9028,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Europe-Italy",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            [
                "id": "15",
                "title": "Russia",
                "icon": "russia",
                "flag_icon": "russia_flag",
                "type": 0,
                "x": 37.6176,
                "y": 55.7558,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Europe-Russia",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            [
                "id": "16",
                "title": "Argentina",
                "icon": "argentina",
                "flag_icon": "argentina_flag",
                "type": 0,
                "x": -58.3816,
                "y": -34.6037,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"South America-Russia",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            [
                "id": "17",
                "title": "Morocco",
                "icon": "morocco",
                "flag_icon": "morocco_flag",
                "type": 0,
                "x": 31.2357,
                "y": 30.0444,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Africa-Morocco",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
            //            [
            //                "id": "18",
            //                "title": "利比亚",
            //                "icon": "france",
            //                "flag_icon": "france_flag",
            //                "type": 0,
            //                "x": 13.1973,
            //                "y": 32.8872,
            //                "isSelected": false,
            //                "ping":Int.random(in: 50..<200),
            //                "subTitle":"非洲-利比亚节点",
            //                "mark":"支持Chat-gpt",
            //                "adress":"103.140.136.101"
            //            ],
            [
                "id": "19",
                "title": "Mongolia",
                "icon": "neimeng",
                "flag_icon": "neimeng_flag",
                "type": 0,
                "x": 106.55,
                "y": 47.5513,
                "isSelected": false,
                "ping":Int.random(in: 50..<200),
                "subTitle":"Asia-Mongolia",
                "mark":"supported Chat-gpt",
                "adress":"103.140.136.101"
            ],
        ]
    }
}
