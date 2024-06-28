//
//  MDFeedbackViewController.swift
//  Maodou
//
//  Created by KingCloser on 2024/5/25.
//

import UIKit
import MBProgressHUD
import PhotosUI

class MDFeedbackViewController: MDBaseViewController {
    
    var feedbackBlock: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }

    private func setupUI() {
        title = "反馈密码"
        let leftItem = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = leftItem

        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarH)
        }
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
            make.width.equalTo(kScreenW)
        }
        typeTitleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().offset(29)
        }
        typeView.snp.makeConstraints { make in
            make.top.equalTo(typeTitleLab.snp.bottom).offset(19)
            make.left.right.equalToSuperview()
        }
        contentTitleLab.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom).offset(19)
            make.left.equalToSuperview().offset(29)
        }
        infoView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(29)
            make.right.equalToSuperview().offset(-29)
            make.top.equalTo(contentTitleLab.snp.bottom).offset(19)
            make.height.equalTo(175)
        }
        contactTitleLab.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(19)
            make.left.equalToSuperview().offset(29)
        }
        contactTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(29)
            make.right.equalToSuperview().offset(-29)
            make.top.equalTo(contactTitleLab.snp.bottom).offset(19)
            make.height.equalTo(42)
        }
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(contactTextField.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(29)
            make.right.equalToSuperview().offset(-29)
            make.height.equalTo(42)
            make.bottom.equalToSuperview()
        }
    }

    func addObserver() {
        let name = UITextField.textDidChangeNotification.rawValue
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChange(_:)),
                                               name: Notification.Name.init(name),
                                               object: nil)
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        return scrollView
    }()

    lazy var contentView: UIView = {
        let contentView = UIView()
        scrollView.addSubview(contentView)
        return contentView
    }()

    lazy var typeTitleLab: UILabel = {
        let lab = UILabel()
        lab.text = "选择反馈类型"
        lab.textColor = UIColor.hexColor(0x7A7D89)
        lab.font = UIFont.regular(14)
        contentView.addSubview(lab)
        return lab
    }()

    lazy var typeView: MDFeedbackTypeSelectView = {
        let typeView = MDFeedbackTypeSelectView()
        typeView.backgroundColor = UIColor.clear
        typeView.setupDatas()
        contentView.addSubview(typeView)
        return typeView
    }()

    lazy var contentTitleLab: UILabel = {
        let lab = UILabel()
        lab.text = "反馈内容"
        lab.textColor = UIColor.hexColor(0x7A7D89)
        lab.font = UIFont.regular(14)
        contentView.addSubview(lab)
        return lab
    }()

    lazy var infoView: MDFeedbackContentView = {
        let infoV = MDFeedbackContentView()
        infoV.layer.cornerRadius = 20
        infoV.layer.borderWidth = 0.5
        infoV.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        infoV.backgroundColor = UIColor.hexColor(0x2D3343)
        contentView.addSubview(infoV)
        return infoV
    }()

    lazy var contactTitleLab: UILabel = {
        let lab = UILabel()
        lab.text = "SETTING_CONTACTUS_CONTACT_TITLE".localizable()
        lab.textColor = UIColor.hexColor(0x7A7D89)
        lab.font = UIFont.regular(14)
        contentView.addSubview(lab)
        return lab
    }()

    lazy var contactTextField: MDFeedbackContactTextField = {
        let textField = MDFeedbackContactTextField()
        textField.placeholder = "SETTING_CONTACTUS_CONNECT_TYPE".localizable()
        textField.font = UIFont.regular(12)
        textField.textColor = .white
        let color = UIColor.hexColor(0x979DAD)
        textField.setValue(color, forKeyPath: "placeholderLabel.textColor")
        textField.layer.cornerRadius = 21
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.hexColor(0x7A7D89).cgColor
        textField.returnKeyType = .done
        contentView.addSubview(textField)
        return textField
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 20
        btn.layer.borderColor =  UIColor.hexColor(0x494C5A).cgColor
        btn.layer.borderWidth = 1.0
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.regular(14)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("SETTING_CONTACTUS_SEND".localizable(), for: .normal)
        if let normalColor = UIColor.hexColor(0x3D404F),
            let normalImg = UIImage.image(color:normalColor) {
            btn.setBackgroundImage(normalImg, for: .normal)
        }
        if let disabledImg = UIImage.image(color:UIColor.clear) {
            btn.setBackgroundImage(disabledImg, for: .disabled)
        }
        btn.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        contentView.addSubview(btn)
        return btn
    }()

    lazy var backBtn: UIButton = {
        let backBtn = UIButton.init(type: .custom)
        var imgName = "close"
        backBtn.setImage(UIImage(named: imgName), for: .normal)
        backBtn.size = CGSize.init(width: 44.0, height: 44.0)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return backBtn
    }()
}

extension MDFeedbackViewController {

    @objc
    func textFieldDidChange(_ notification: Notification) {
        if infoView.text?.isEmpty ?? true {
            confirmBtn.isEnabled = false
        } else {
            confirmBtn.isEnabled = true
        }
    }

    @objc
    private func confirmAction(_ sender: UIButton) {
        guard let content = infoView.text else {
            MBProgressHUD.showToast(text: "SETTING_CONTACTUS_LEAST_FIVE_CHARACTERS_TIP".localizable())
            return
        }
        if content.count < 5 && content.count <= 500 {
            MBProgressHUD.showToast(text: "SETTING_CONTACTUS_LEAST_FIVE_CHARACTERS_TIP".localizable())
            return
        }
        var params = ["kind": "\(typeView.type)",
                      "content": content]
        if let contact = contactTextField.text {
            params["contact_info"] = contact
        }
        let hud = MBProgressHUD.showLoading(view)
        MDNetworkTool.feedback(params, images: infoView.image ?? []) { [weak self](response, error) in
            hud.hide(animated: true)
            self?.backAction()
            guard let block = self?.feedbackBlock else {
                return
            }
            block()
        }
    }
    @objc
    private func backAction() {
        dismiss(animated: true)
    }
}

extension MDFeedbackViewController: MDFeedbackContentViewProtocol {
    func selectImage(_ sender: UIButton) {
        let alertVc = UIAlertController(title: nil,
                                        message: nil,
                                        preferredStyle: .actionSheet)
        alertVc.popoverPresentationController?.sourceView = sender
        alertVc.popoverPresentationController?.sourceRect = CGRect(x: sender.x,
                                                                   y: sender.bottom,
                                                                   width: 300,
                                                                   height: 300)
        alertVc.popoverPresentationController?.permittedArrowDirections = .left
        let cameraAction = UIAlertAction(title: "SETTING_CONTACTUS_CAMERA".localizable(), style: .default) {_  in
            MDPhotoCameraPermisionManager.shareInstance().getCameraPermision { finish in
                if finish {
                    let imagePickerVc = UIImagePickerController()
                    imagePickerVc.sourceType = .camera
                    imagePickerVc.mediaTypes = ["public.image"]
                    imagePickerVc.delegate = self
                    imagePickerVc.allowsEditing = false
                    imagePickerVc.modalPresentationStyle = .fullScreen
                    self.present(imagePickerVc, animated: true, completion: nil)
                } else {
                    MBProgressHUD.showToast(text: "SETTING_CONTACTUS_CAMERA_PERMISSION_TIP".localizable())
                }
            }
        }
        let photoAction = UIAlertAction(title: "SETTING_CONTACTUS_PHOTO".localizable(), style: .default) { _  in
            MDPhotoCameraPermisionManager.shareInstance().getPhotoPermision { finish in
                if finish == "1" {
                    DispatchQueue.main.async {
                        let pickerVC = UIImagePickerController()
                        pickerVC.delegate = self
                        pickerVC.sourceType = .photoLibrary
                        self.present(pickerVC, animated: true, completion: nil)
                    }
                } else if finish == "limite" {
                    if #available(iOS 14.0, *) {
                            var configuration = PHPickerConfiguration.init()
                            configuration.filter = PHPickerFilter.any(of: [PHPickerFilter.images,PHPickerFilter.videos,PHPickerFilter.livePhotos])
                            configuration.selectionLimit = 1

                            let picker = PHPickerViewController.init(configuration: configuration)
                            picker.delegate = self
                            picker.view.backgroundColor = UIColor.blue
                            picker.modalPresentationStyle = .fullScreen
                            self.present(picker, animated: true) {

                            }
                    }
                } else {
                    MBProgressHUD.showToast(text: "SETTING_CONTACTUS_PHOTO_PERMISSION_TIP".localizable())
                }
            }
        }
        let cancelAction = UIAlertAction(title: "SETTING_CONTACTUS_CANCEL".localizable(), style: .default) {_  in
            self.dismiss(animated: true, completion: nil)
        }
        alertVc.addAction(cameraAction)
        alertVc.addAction(photoAction)
        alertVc.addAction(cancelAction)
        self.present(alertVc, animated: true, completion: nil)
    }
}

extension MDFeedbackViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        infoView.image = [image]
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MDFeedbackViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension MDFeedbackViewController: PHPickerViewControllerDelegate {

    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //在回调中调用消失方法
        picker.dismiss(animated: true) {

        }

        if results.count == 0 {
            return
        }

        let itemProvider = results.first?.itemProvider
        if itemProvider?.canLoadObject(ofClass: UIImage.classForCoder() as! NSItemProviderReading.Type) == true {

            itemProvider?.loadObject(ofClass: UIImage.classForCoder() as! NSItemProviderReading.Type, completionHandler: { [weak self](object, error) in

                print(object as Any)
                guard let image = object as? UIImage else { return }
                DispatchQueue.main.async {
                    self?.infoView.image = [image]
                }
            })

        }

    }

}

class MDFeedbackContactTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 17, y: 0, width: bounds.width - 34, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 17, y: 0, width: bounds.width - 34, height: bounds.height)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 17, y: 0, width: bounds.width - 34, height: bounds.height)
    }
    
}
