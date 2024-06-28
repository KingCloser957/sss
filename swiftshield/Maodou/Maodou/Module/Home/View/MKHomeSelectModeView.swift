//
//  MKHomeSelectModeView.swift
//  MonkeyKing
//
//  Created by huangrui on 2023/3/16.
//

import UIKit

class MKHomeSelectModeView: UIView {
    
    let viewHeight:CGFloat = 374.0
    var datas: [MDHomeVPNModel] = []
    var selectModel: MDHomeVPNModel?
    var selectVPNModeBlock:((VPNModeType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewInit()
        setDataInit()
        setDefaultType()
    }
    
    func setViewInit() {
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
        control.backgroundColor = .clear
    }
    
    func setDataInit() {
        var section: [MDHomeVPNModel] = []
        for dict in self.config() {
            guard let model = MDCoderTool.fromDict(MDHomeVPNModel.self, dict) else {
                break
            }
            section.append(model)
        }
        datas = section
        tableView.reloadData()
    }
    
    func setDefaultType() {
        guard let selectModel = lastSelectTypeModel() else{
            datas[0].selectStatus = true
            self.selectModel = datas[0]
            tableView.selectRow(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: .none)
            return
        }
        for dict in self.config() {
            guard let model = MDCoderTool.fromDict(MDHomeVPNModel.self, dict) else {
                break
            }
            if selectModel.modeIndex == model.modeIndex {
                datas[selectModel.modeIndex].selectStatus = true
                self.selectModel = datas[selectModel.modeIndex]
                tableView.selectRow(at: IndexPath.init(row: selectModel.modeIndex, section: 0), animated: true, scrollPosition: .none)
                return
            }
        }
    }
    
    private func lastSelectTypeModel() -> MDHomeVPNModel? {
        let userDefault = UserDefaults(suiteName: kGroupId)
        guard let info = userDefault?.value(forKey: kSelectModeType) as? String else {
            return nil
        }
        let model = MDCoderTool.fromDict(MDHomeVPNModel.self, info.convertToDictionary())
        return model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(26)
            make.height.equalTo(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom).offset(23)
        }
    }
    
    lazy var control: UIControl = {
        let c = UIControl.init(frame: UIApplication.shared.currentWindow?.bounds ?? self.bounds)
        c.addTarget(self, action: #selector(dismissAnimation), for: .touchUpInside)
        addSubview(c)
        return c
    }()
    
    lazy var contentView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: kScreenH - viewHeight, width: kScreenW, height: viewHeight))
        view.backgroundColor = UIColor.hexColor(hexColor: 0x222536, alpha: 1.0)
        let bezierPath = UIBezierPath.init(
            roundedRect: view .bounds,
            byRoundingCorners: [.topLeft,.topRight],
            cornerRadii: CGSize.init(width: 37, height: 37))
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = bezierPath.cgPath
        view.layer.mask = shapeLayer
        view.isUserInteractionEnabled = true
        addSubview(view)
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let cView = UILabel.init()
        cView.text = "HOME_PROXY_SELECT_TITLE_TIPS".localizable()
        cView.textColor = UIColor.hexColor(0xFFFFFF)
        cView.font = UIFont.medium(14)
        cView.textAlignment = .center
        contentView.addSubview(cView)
        return cView
    }()
    
    lazy var tableView: UITableView = {
        let ctableView = UITableView.newTableViewGroupedWithTarget(target: self)
        ctableView.backgroundColor = UIColor.hexColor(hexColor: 0x222536, alpha: 1.0)
        ctableView.register(MKHomeSelectModeViewCell.self, forCellReuseIdentifier: "MKHomeSelectModeViewCellID")
        ctableView.isScrollEnabled = false
        contentView.addSubview(ctableView)
        return ctableView
    }()
}

extension MKHomeSelectModeView:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectModel?.selectStatus = false
        datas[indexPath.row].selectStatus = true
        self.selectModel = datas[indexPath.row]
        let userDefault = UserDefaults(suiteName: kGroupId)
        let json = MDCoderTool.toJson(datas[indexPath.row])
        userDefault?.set(json, forKey: kSelectModeType)
        userDefault?.set(datas[indexPath.row].modeIndex, forKey: kProxyMode)
        userDefault?.synchronize()
        if let cell = tableView.cellForRow(at: indexPath) as? MKHomeSelectModeViewCell  {
            cell.refreshData(datas[indexPath.row])
        }
        if let block = selectVPNModeBlock {
            block(datas[indexPath.row].modeType)
        }
        dismissAnimation()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MKHomeSelectModeView:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MKHomeSelectModeViewCellID", for: indexPath)
        guard let cell = cell as? MKHomeSelectModeViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let model = datas[indexPath.row]
        cell.backgroundColor = UIColor.hexColor(hexColor: 0x222536, alpha: 1.0)
        cell.refreshData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension MKHomeSelectModeView {
    @objc
    private func dismissAnimation() {
        self.frame = CGRect.init(x: 0, y: 0 , width: kScreenW, height: kScreenH)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
            self.frame = CGRect.init(x: 0, y: kScreenH, width: kScreenW, height: kScreenH)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    public func showAnimation() {
        self.frame = CGRect.init(x: 0, y: kScreenH, width: kScreenW, height: kScreenH)
        UIView.animate(withDuration: 0.25) {
            self.frame = CGRect.init(x: 0, y: 0 , width: kScreenW, height: kScreenH)
            let window = UIApplication.shared.currentWindow
            self.frame = window?.bounds ?? .zero
            window?.addSubview(self)
        } completion: { _ in
            
        }
    }
    
    public func config() -> [[String: Any]] {
        [
            ["title": "HOME_PROXY_MODE_GLOBAL".localizable(), "icon": "ico_all", "modeType": 0, "modeIndex": 0, "modeTypeDec": "全局模式","status" : "HOME_PROXY_GLOBEL_TIPS".localizable(), "selectStatus": false],
            ["title": "HOME_PROXY_MODE_GAME".localizable(), "icon": "ico_game", "modeType": 1, "modeIndex": 1, "modeTypeDec": "游戏模式","status" : "HOME_PROXY_GAMES_TIPS".localizable(), "selectStatus": false],
            ["title": "HOME_PROXY_MODE_VIDEO".localizable(), "icon": "ico_yy", "modeType": 2, "modeIndex": 2, "modeTypeDec": "影音模式","status" : "HOME_PROXY_VIDEO_TIPS".localizable(),"selectStatus": false]
        ]
    }
}
