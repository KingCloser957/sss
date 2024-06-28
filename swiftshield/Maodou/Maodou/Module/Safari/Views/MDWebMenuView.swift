//
//  MDWebMenuView.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

protocol MDWebMenuViewProtocol: NSObject {
    func didSelected(_ menuView: MDWebMenuView, _ index: Int)
}

class MDWebMenuView: UIView {
    
    weak var delegate: MDWebMenuViewProtocol?
    var tab: MDTabModel?
    init(frame: CGRect, tab: MDTabModel?) {
        super.init(frame: frame)
        self.tab = tab
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath(roundedRect: contentView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 10, height: 10))
        maskLayer.path = path.cgPath
        contentView.layer.mask = maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(kBottomH + 204)
            make.top.equalTo(snp.bottom)
        }
        colletionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(180)
        }
    }

    open func show() {
        contentView.transform = .identity
        UIView.animate(withDuration: 0.25) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -(kBottomH + 204))
            self.backgroundColor = UIColor.hexColor(hexColor: 0x000000, alpha: 0.3)
        }
    }

    open func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.contentView.transform = .identity
            self.backgroundColor = UIColor.hexColor(hexColor: 0x000000, alpha: 0)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss()
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        Log.debug(contentView.frame)
    }

    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        addSubview(view)
        return view
    }()

    lazy var colletionView: HjzItemsView = {
        let cView = HjzItemsView(frame: .zero)
        // 行数
        cView.flowLayout.row = 2
        // 列数
        cView.flowLayout.column = 5
        // 图片和文字间隔
        cView.spacing = 5
        // 文字字号
        cView.fontSize = 14
        // 当前分页的指示器颜色
        cView.currentPageColor = .purple
        // 点击回调
        cView.tapClosure = { [weak self](index, model) in

            guard let sSelf = self,
                  let target = sSelf.delegate else {
                return
            }
            target.didSelected( sSelf, index)
        }
        let incognitoState = UserDefaults.standard.bool(forKey: "kIncognitoState")
        let noImageMode = UserDefaults.standard.bool(forKey: "kNoImageMode")
        let table = MDBookmarkTable()
        let isContain = table.isContain(url: tab?.url)
//        let incognitoState = UserDefaults.standard.bool(forKey: "kIncognitoState")
        cView.data = [["image": "bookmark",
                       "name": "BROWER_SEARCH_MENU_BOOKMARKS".localizable()
                      ],
                      ["image": "history",
                       "name": "BROWER_SEARCH_MENU_HISTORY".localizable()
                      ],
                      ["image": "identifier",
                       "name": "BROWER_SEARCH_MENU_MARK".localizable()
                      ],
                      ["image": isContain ? "delete" : "add",
                       "name": isContain ? "BROWER_SEARCH_MENU_BOOKMARKS_DELETE".localizable() : "BROWER_SEARCH_MENU_BOOKMARKS_ADD".localizable()
                      ],
                      ["image": incognitoState ? "incognito_on" : "incognito_off",
                       "name": "BROWER_SEARCH_MENU_NO_HISTORY".localizable()
                      ],
                      ["image": "refresh",
                       "name": "BROWER_SEARCH_MENU_RELOAD".localizable()
                      ],
                      ["image": noImageMode ? "no_image_on" : "no_image_off",
                       "name": "BROWER_SEARCH_MENU_NO_PHOTO".localizable()
                      ],
                      ["image": "image",
                       "name": "BROWER_SEARCH_MENU_HAVA_PHOTO".localizable()
                      ],
//                      ["image": "share",
//                       "name": "分享"
//                      ]
                    ].map {
                        Log.debug($0)
            return HjzItemModel(image: "menu_\($0["image"] ?? "")_icon", name: $0["name"] ?? "")
                     }
        contentView.addSubview(cView)
        return cView
    }()

    lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
}

extension MDWebMenuView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        item.contentView.backgroundColor = .red
        return item
    }
}

extension MDWebMenuView: UICollectionViewDelegate {

}
