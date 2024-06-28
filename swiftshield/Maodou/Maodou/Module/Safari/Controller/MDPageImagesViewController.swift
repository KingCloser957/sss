//
//  MDPageImagesViewController.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import UIKit
import KKImageBrowser

class MDPageImagesViewController: MDBaseViewController {
    
    private var imageUrls: [String] = []

    init(imageUrls: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.imageUrls = imageUrls
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
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupData() {
        collectionView.reloadData()
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 4) / 3.0
        layout.itemSize = CGSizeMake( width, width)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.register(MDPageImagesCell.self, forCellWithReuseIdentifier: "MDPageImagesCell")
        cView.dataSource = self
        cView.delegate = self
        view.addSubview(cView)
        return cView
    }()
}

extension MDPageImagesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDPageImagesCell", for: indexPath) as! MDPageImagesCell
        let url = URL(string: imageUrls[indexPath.item])
        cell.imageView.sd_setImage(with: url)
        return cell
    }
}

extension MDPageImagesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = Array<KKImageBrowserModel>()
        for i in 0..<imageUrls.count {
            let imgUrl = imageUrls[i]
            let index = IndexPath(item: i, section: 0)
            if let url = URL(string: imgUrl)  {
                let model = KKImageBrowserModel()
                model.url = url
                let cell = collectionView.cellForItem(at: index)
                model.toView = cell
                images.append(model)
            }
        }
        let vc = KKImageBrowser()
        vc.images = images
        vc.index = indexPath.item
        present(vc, animated: true)
    }
}

class MDPageImagesCell: UICollectionViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    lazy var imageView: UIImageView = {
        let imgView = UIImageView()

        contentView.addSubview(imgView)
        return imgView
    }()
}
