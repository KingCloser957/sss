//
//  MDLinesViewController.swift
//  MonkeyKing
//
//  Created by huangrui on 2024/5/22.
//

import UIKit
import QuartzCore
import SceneKit

class MDLinesViewController: MDBaseViewController {
    
    var swiftGlobe = MKGlobelMap(alignment: .dayNightTerminator)
    
    var didSelectLineBlock: ((MKNodeTempeleModel) -> Void)?
    var nodesArray:[MKNodeTempeleModel] = []
    var preNode:MKNodeTempeleModel?
    
    init(nodes:[MKNodeTempeleModel]) {
        self.nodesArray = nodes
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstrains()
        setupDatas()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        guard let touchPoint = touch?.location(in: sceneView) else { return }
        let hitResults = sceneView.hitTest(touchPoint)
        if hitResults.count > 0 {
            if let hit = hitResults.first {
                for (index,var model) in nodesArray.enumerated() {
                    if hit.node.name == model.id {
                        model.isSelected = true
                        self.preNode?.isSelected = false
                        self.preNode = model
                        nodesArray[index] = model
                        self.contentView.refreshUI(with: model)
                    }
                }
            }
        }
    }
    
    func setupViews() {
        self.title = "HOME_PROXY_SELECT_LINE_TITLE".localizable()
        self.view.backgroundColor = UIColor.hexColor(0x222536)
        
        let leftItem = UIBarButtonItem.init(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftItem
        
        self.view.addSubview(sceneView)
        sceneView.addSubview(contentView)
        sceneView.addSubview(statusLabel)
    }
    
    func setupConstrains() {
        self.sceneView.snp.makeConstraints { make in
            make.edges.top.equalToSuperview().offset(64)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(160)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupDatas() {
        swiftGlobe.setupInSceneView(self.sceneView,forARKit: false,enableAutomaticSpin: true)
        swiftGlobe.addDemoMarkers(with: self.nodesArray)
        
        if let model = getDefaultNode() {
            self.preNode = model
            self.contentView.refreshUI(with: model)
        }
    }
    
    private func getDefaultNode() -> MKNodeTempeleModel? {
        let userDefault = UserDefaults(suiteName: kGroupId)
        guard let info = userDefault?.value(forKey: kProxyLineInfo) as? String else {
            if nodesArray.count > 0 {
                debugPrint("缓存线路信息为空,读取默认的第一条线路")
                return nodesArray.first
            }
            return nil
        }
        debugPrint("缓存线路信息 >>> \(info)")
        let model = MDCoderTool.fromJson(MKNodeTempeleModel.self, info.convertToDictionary())
        return model
    }
    
    private func savaSelectedNode(node:MKNodeTempeleModel?) {
        guard let block = didSelectLineBlock else {
            return
        }
        guard let node = node else {
            return
        }
        if let json = MDCoderTool.toJson(node) {
            let userDefault = UserDefaults(suiteName: kGroupId)
            userDefault?.setValue(json, forKey: kProxyLineInfo)
            userDefault?.synchronize()
        }
        if self.presentingViewController != nil {
            self.navigationController?.dismiss(animated: true, completion: {
                block(node)
            })
        } else {
            block(node)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    lazy var backButton: UIButton = {
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage.init(named: "back"), for: .normal)
        backBtn.size = CGSize.init(width: 44.0, height: 44.0)
        backBtn.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        return backBtn
    }()
    
    lazy var statusLabel: UILabel = {
        let cView = UILabel.init()
        cView.text = "Tips:\("HOME_PROXY_SELECT_LINE_TIPS".localizable())"
        cView.textColor = UIColor.hexColor(0xF9F9F9)
        cView.numberOfLines = 0
        cView.lineBreakMode = .byCharWrapping
        cView.font = UIFont.medium(14)
        cView.textAlignment = .center
        return cView
    }()
    
    lazy var sceneView: SCNView = {
        let view = SCNView(frame: .zero)
        view.backgroundColor = UIColor.black
        return view
    }()
    
    lazy var contentView: MKNodeDetailView = {
        let cView = MKNodeDetailView()
        cView.backgroundColor = .clear
        cView.layer.cornerRadius = 8.0
        cView.layer.masksToBounds = true
        cView.delegate = self
        return cView
    }()
    
}

extension MDLinesViewController {
   @objc private func navBackAction() {
       if self.presentingViewController != nil {
           self.navigationController?.dismiss(animated: true, completion: nil)
       } else {
           self.navigationController?.popViewController(animated: true)
       }
    }
}

extension MDLinesViewController:MKNodeConnectViewDelegate {
    func didConnectNode(with node: MKNodeTempeleModel?) {
        self.savaSelectedNode(node: node)
    }
}
