//
//  OOCountryCodeView.swift
//  Orchid
//
//  Created by 李白 on 2022/8/18.
//

import UIKit

struct MDCountyCodeListModel: Codable {
    let countryList: [MDCountyCodeModel]
}

struct MDCountyCodeModel: Codable {
    let en: String
    let zhHans: String
    let code: Int

    enum CodingKeys: String, CodingKey {
        case en
        case zhHans = "zh-Hans"
        case code
    }
}

class MDCountryCodeCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        titelLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.lessThanOrEqualToSuperview().offset(-50)
        }

        codeLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-36)
        }
    }

    lazy var titelLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont(name: "PingFangSC-Regular", size: 14)
        contentView.addSubview(lab)
        return lab
    }()

    lazy var codeLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont(name: "PingFangSC-Regular", size: 16)
        lab.textAlignment = .right
        contentView.addSubview(lab)
        return lab
    }()
}

class MDCountryCodeView: MDBasePopupView {

    var didSelectBlock: ((MDCountyCodeModel) -> Void)?

    var contentTop: CGFloat = 113

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.size.equalTo(CGSize(width: 254, height: 324))
            make.top.equalToSuperview().offset(contentTop)
        }
        iconImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(34)
            make.size.equalTo(CGSize(width: 17, height: 15))
        }
        tabelView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touche = touches.first else {
            return
        }
        let view = touche.view
        if view == self {
            dismiss()
        }
    }

    lazy var iconImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "up_arrow")
        contentView.addSubview(view)
        return view
    }()

    lazy var tabelView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.layer.cornerRadius = 20
        view.rowHeight = 40
        view.separatorStyle = .none
        view.backgroundColor = UIColor.hexColor(0x141421)
        view.register(MDCountryCodeCell.self, forCellReuseIdentifier: "OOCountryCodeCell")
        contentView.addSubview(view)
        return view
    }()

    lazy var model: MDCountyCodeListModel = {
        guard let url = Bundle.main.url(forResource: "country_code", withExtension: "json") else {
            return MDCountyCodeListModel(countryList: [])
        }
        guard let data = try? Data(contentsOf: url) else {
            return MDCountyCodeListModel(countryList: [])
        }
        let decode = JSONDecoder()

        guard let model = try? decode.decode(MDCountyCodeListModel.self, from: data) else {
            return model
        }

        return model
    }()

}

extension MDCountryCodeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if didSelectBlock != nil {
            let model = model.countryList[indexPath.row]
            didSelectBlock!(model)
            dismiss()
        }
    }
}

extension MDCountryCodeView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.countryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OOCountryCodeCell") as? MDCountryCodeCell else {
            let newCell = MDCountryCodeCell(style: .default, reuseIdentifier: "OOCountryCodeCell")
            return newCell
        }
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.hexColor(0x141421)
        } else {
            cell.contentView.backgroundColor = UIColor.hexColor(0x171724)
        }
        let codeModel = model.countryList[indexPath.row]
        if MDLocalized.shareInstance().currentLanguage() == "en" {
            cell.titelLab.text = codeModel.en
        } else {
            cell.titelLab.text = codeModel.zhHans
        }
        cell.codeLab.text = "+\(codeModel.code)"
        return cell
    }
}

extension MDCountryCodeView {
    public func selectFirstRow() -> String {
        return self.selectFirstRow(IndexPath(row: 0, section: 0))
    }
    
    public func selectFirstRow(_ indexPath:IndexPath) -> String {
        self.tabelView.selectRow(at:indexPath, animated:false, scrollPosition: .none)
        let model = model.countryList[indexPath.row]
        return "+\(model.code)"
    }
}
