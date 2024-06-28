//
//  MDGridViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit

class MDGridViewController: MDBaseViewController {
    
    private var table: MDTabTable = MDTabTable()
    let tabManager: MDTabManager!

    init(tabManager: MDTabManager) {
        self.tabManager = tabManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.bottom.equalTo(toolView.snp.top)
        }
        toolView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(49 + kBottomH)
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (CGRectGetWidth(view.bounds) - 46) * 0.5,
                                 height: 194)
        layout.minimumLineSpacing = 10
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.backgroundColor = UIColor.hexColor(0xF5F5F5)
        cView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        cView.register(MDGridCollectionViewCell.self, forCellWithReuseIdentifier: "MDGridCollectionViewCell")
        cView.delegate = self
        cView.dataSource = self
        view.addSubview(cView)
        return cView
    }()

    lazy var toolView: MDGridToolView = {
        let tView = MDGridToolView()
        tView.backgroundColor = .white
        view.addSubview(tView)
        return tView
    }()
}

extension MDGridViewController: MDGridToolViewProtocol {

    func closeAllTableAction() {
        tabManager.clear()
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.dismiss(animated: true)
        }
    }

    func newTableAction() {
        tabManager.add()
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.dismiss(animated: true)
        }
    }

    func backAction() {
        dismiss(animated: true)
    }

}

extension MDGridViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabManager.normalTabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MDGridCollectionViewCell", for: indexPath) as! MDGridCollectionViewCell
        let model = tabManager.normalTabs[indexPath.item]
        if indexPath.row == tabManager.selectedIndex {
            item.contentView.layer.borderColor = UIColor.hexColor(0x0044FF).cgColor
            item.contentView.layer.borderWidth = 2.0
        } else {
            item.contentView.layer.borderColor = UIColor.white.cgColor
            item.contentView.layer.borderWidth = 0
        }
        item.closeBlock = { [weak self] (closeTab) in
            guard let sSelf = self, let tab = closeTab else { return }
            sSelf.tabManager.remove(tab: tab)
            sSelf.collectionView.reloadData()
            self?.dismiss(animated: true)
        }
        item.refreshUI(model)
        return item
    }
}

extension MDGridViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tab = tabManager.normalTabs[indexPath.item]
        tabManager.select(tab: tab)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute:{
            self.dismiss(animated: true)
        })
    }
}
