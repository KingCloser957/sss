//
//  MDFeedbackDetailViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import Photos
import PhotosUI
import MBProgressHUD

protocol MDFeedbackToolDelegate {
    func selectImage()
    func sendTextMessage(_ text: String?)
}


class MDFeedbackDetailViewController: MDBaseViewController {
    
    private var id: String!
    private var model: MDFeedbackDetailModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init(_ id: String) {
        self.init(nibName: nil, bundle: nil)
        self.id = id
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        addKeywordObserver()
    }

    private func setupUI() {
        title = "FEEDBACK_DETAIL_MESSAGE_TITLE_TIPS".localizable()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: kNavBarH, left: 0, bottom: 0, right: 0))
        }
        view.addSubview(toolView)
        toolView.frame = CGRect(x: 0, y: view.height - 81, width: view.width, height: 81)
    }

    private func setupData() {
        requestDetail()
    }

    private func addKeywordObserver() {
        NotificationCenter.default.addObserver(self, selector:
                                                #selector(keywordShowAndHide(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector:
                                                #selector(keywordShowAndHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc
    private func keywordShowAndHide(_ notification: Notification) {
        guard let info = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let rect = info.cgRectValue
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.toolView.bottom = rect.origin.y
        }
    }

    private func uploadMessage(params: [String: Any], _ image: UIImage? = nil) {
        let hud = MBProgressHUD.showLoading(view)
        var images: [UIImage] = []
        if let image = image {
            images.append(image)
        }
        MDNetworkTool.feedbackResend(params, images: images) { [weak self](response, error) in
            hud.hide(animated: true)
            guard let result = response as? [String: Any] else { return }
            guard let data = result["data"] as? [String: Any] else { return }
            let jsonDecode = JSONDecoder()
            guard let newData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
                return
            }
            guard let model = try? jsonDecode.decode(MDFeedbackRecordModel.self, from: newData) else {
                return
            }
            let row = (self?.model?.record?.count ?? 0) + 1
            let indexPath = IndexPath(item: row, section: 0)
            self?.model?.record?.append(model)
            self?.tableView.insertRows(at: [indexPath], with: .none)
            self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    private func requestDetail() {
        let params = ["feedback_id": id]
        MDNetworkTool.feedbackDetail(params){[weak self](response, _) in
            guard let result = response as? [String: Any] else {
                return
            }
            guard let data = result["data"] as? [String: Any] else {
                return
            }
            let jsonDecode = JSONDecoder()
            guard let data = try? JSONSerialization.data(withJSONObject: data, options: []) else {
                return
            }
            self?.model = try? jsonDecode.decode (MDFeedbackDetailModel.self, from: data)
            if self?.model?.state == 0 {
                self?.toolView.isHidden = false
            } else {
                self?.toolView.isHidden = true
            }
            switch self?.model?.state {
            case 1:
                self?.footerView.refreshText("—— 反馈已结束 ——")
                self?.tableView.tableFooterView = self?.footerView
            case 2:
                self?.footerView.refreshText("—— 反馈已采纳 ——")
                self?.tableView.tableFooterView = self?.footerView
            default:
                self?.tableView.tableFooterView = nil
            }
            self?.tableView.reloadData()
            let row = (self?.model?.record?.count ?? 0)
            let indexPath = IndexPath(item: row, section: 0)
            self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    lazy var tableView: UITableView = {
        let tabView = UITableView()
        tabView.backgroundColor = view.backgroundColor
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        tabView.estimatedRowHeight = 400
        tabView.rowHeight = UITableView.automaticDimension
        tabView.register(MDFeedbackInfoCell.self, forCellReuseIdentifier: "MDFeedbackInfoCell")
        tabView.register(MDFeedbackRecordCell.self, forCellReuseIdentifier: "MDFeedbackRecordCell")
        tabView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 81, right: 0)
        return tabView
    }()

    lazy var toolView: MDFeedbackDetailToolView = {
        let toolView = MDFeedbackDetailToolView()
        toolView.backgroundColor = UIColor.hexColor(0x2D3343)
        toolView.isHidden = true
        return toolView
    }()

    lazy var footerView: MDFeedbackDetailFooterView = {
        let footerView = MDFeedbackDetailFooterView()
        footerView.size = CGSize(width: tableView.width, height: 30)
        return footerView
    }()
}

extension MDFeedbackDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else {
            return 0
        }

        return (model.record?.count ?? 0) + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier:
                                                                                "MDFeedbackInfoCell",
                                                                             for: indexPath) as? MDFeedbackInfoCell
            guard tableViewCell == tableViewCell else {
                return  UITableViewCell()
            }
            tableViewCell?.refreshUI(model?.feedbackVo as Any)
            return tableViewCell ?? UITableViewCell()
        } else {
            let item = model?.record?[indexPath.row - 1]
//            if item?.userType == 0 {
//                let tableViewCell = tableView.dequeueReusableCell(withIdentifier:
//                                                                                    "OOFeedbackGuestCell",
//                                                                                 for: indexPath) as? OOFeedbackGuestCell
//                tableViewCell?.contentView.backgroundColor = kNormalViewColor
//                guard tableViewCell == tableViewCell else {
//                    return  UITableViewCell()
//                }
//                tableViewCell?.refreshUI(item)
//                return tableViewCell ?? UITableViewCell()
//            } else {

            let tableViewCell = MDFeedbackRecordCell()
            guard tableViewCell == tableViewCell else {
                return  UITableViewCell()
            }
            tableViewCell.refreshUI(item)
            return tableViewCell
//            }
        }
    }
}

extension MDFeedbackDetailViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toolView.endEditing(true)
    }
}

extension MDFeedbackDetailViewController: MDFeedbackToolDelegate {

    func sendTextMessage(_ text: String?) {
        guard let id = self.id, let newText = text else  {
            return
        }
        uploadMessage(params: ["content": newText, "userFeedbackId": id])
    }

    func selectImage() {
        MDPhotoCameraPermisionManager.shareInstance().getPhotoPermision { finish in
//            if finish == "1" {
//                self.getCemeraPhoto()
//            } else if finish == "limite" {
//                DispatchQueue.main.async {
//                    let pickerLimitVc = OOPickerLimitPhotoViewController()
//                    pickerLimitVc.modalPresentationStyle = .fullScreen
//                    let nav = OOBaseNavigationViewController(rootViewController: pickerLimitVc)
//                    pickerLimitVc.photoSelectBlock = { photos in
//                        if let image = photos.first, let id = self.id {
//                            self.uploadMessage(params :["userFeedbackId": id], image)
//                        }
//                    }
//                    self.present(nav, animated: true, completion: nil)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    OOProgressHUD.showErrorMessage(message: "SETTING_CONTACTUS_PHOTO_PERMISSION_TIP".localizable())
//                }
//            }
        }
    }

    func getCemeraPhoto () {
//        DispatchQueue.main.async {
//            if #available(iOS 14, *) {
//                var configuration = PHPickerConfiguration(photoLibrary: .shared())
//                let filter = PHPickerFilter.any(of: [.images,.livePhotos])
//                configuration.filter = filter
//                configuration.selectionLimit = 1
//                configuration.preferredAssetRepresentationMode = .automatic
//                let pickerVc = PHPickerViewController(configuration: configuration)
//                pickerVc.delegate = self
//                self.present(pickerVc, animated: true, completion: nil)
//            } else {
//                let imagePickerVc = UIImagePickerController()
//                imagePickerVc.sourceType = .photoLibrary
//                imagePickerVc.mediaTypes = ["public.image"]
//                imagePickerVc.delegate = self
//                imagePickerVc.allowsEditing = false
//                imagePickerVc.modalPresentationStyle = .fullScreen
//                self.present(imagePickerVc, animated: true, completion: nil)
//            }
//        }
    }
    
}

extension MDFeedbackDetailViewController: UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image:UIImage? = info[.originalImage] as? UIImage , let id = self.id else {
            return
        }
        uploadMessage(params: ["userFeedbackId": id], image)
    }
}

extension MDFeedbackDetailViewController: PHPickerViewControllerDelegate {

    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var images: [UIImage] = []
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        for asset in results {
            group.enter()
            queue.async(group: group) {
                asset.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if (error == nil && object != nil) {
                        if (object?.isKind(of: UIImage.self) == true) {
                            let origImage:UIImage? = object as? UIImage
                            guard let origImage = origImage else {
                                return
                            }
                            images.append(origImage)
                            group.leave()
                        }
                    }
                }
            }
        }
        group.notify(queue: DispatchQueue.main) { [weak self] in
            if let image = images.first, let id = self?.id {
                self?.uploadMessage(params :["userFeedbackId": id], image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
