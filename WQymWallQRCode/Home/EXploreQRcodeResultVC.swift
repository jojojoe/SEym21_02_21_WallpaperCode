//
//  EXploreQRcodeResultVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/16.
//

import UIKit
import Photos
import DeviceKit

class EXploreQRcodeResultVC: UIViewController {
    let backBtn = UIButton(type: .custom)
    let nextBtn = UIButton(type: .custom)
    
    var contentImg: UIImage
    let bgCanvasView = UIView()
    let contentImgV = UIImageView(image: nil)
    
    init(image: UIImage) {
        self.contentImg = image
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
 
}

extension EXploreQRcodeResultVC {
    func setupView() {
        //
        let bgImgV = UIImageView(image: UIImage(named: "home_background"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "edit_ic_back"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        //
        view.addSubview(nextBtn)
        nextBtn.addTarget(self, action: #selector(nextBtnClick(sender:)), for: .touchUpInside)
        nextBtn.setImage(UIImage(named: "code_ic_share"), for: .normal)
        nextBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        //
        bgCanvasView.backgroundColor = .clear
        bgCanvasView.layer.borderWidth = 1
        bgCanvasView.layer.borderColor = UIColor.white.cgColor
        view.addSubview(bgCanvasView)
        
        
        var bgCanvasWidth: CGFloat = 372
        var cameraWidth: CGFloat = 352
        
        if Device.current.diagonal == 4.7 || Device.current.diagonal > 7 {
            bgCanvasWidth = 342
            cameraWidth = 322
        }
        
        
        bgCanvasView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(bgCanvasWidth)
        }
        
        //
        contentImgV.backgroundColor = UIColor.white
        contentImgV.contentMode = .scaleAspectFill
        bgCanvasView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.left.top.equalTo(6)
            $0.center.equalTo(bgCanvasView)
        }
        contentImgV.image = contentImg
        //
        let bgBottomView = UIView()
        bgBottomView.backgroundColor = .clear
        view.addSubview(bgBottomView)
        bgBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(contentImgV.snp.bottom)
        }
        //
        let okBtn = UIButton(type: .custom)
        bgBottomView.addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(354)
            $0.height.equalTo(69)
            $0.centerX.equalToSuperview()
        }
        okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        okBtn.setTitle("Save", for: .normal)
        okBtn.setTitleColor(.white, for: .normal)
        okBtn.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        okBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
    }
    
    
    
    
}

extension EXploreQRcodeResultVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func nextBtnClick(sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [contentImg], applicationActivities: nil)
        activityController.modalPresentationStyle = .fullScreen
        activityController.completionWithItemsHandler = {
            (type, flag, array, error) -> Void in
            if flag == true {
//                    分享成功
            } else {
//                    分享失败
            }
        }
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    @objc func okBtnClick(sender: UIButton) {
        saveToAlbumPhotoAction(images: [contentImg])
    }
}

extension EXploreQRcodeResultVC {
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
            }) { (finish, error) in
                if finish {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showSaveSuccessAlert()
                         
                    }
                } else {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        if error != nil {
                            let auth = PHPhotoLibrary.authorizationStatus()
                            if auth != .authorized {
                                self.showDenideAlert()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        HUD.success("Photo save successful.")
    }
    
    func showDenideAlert() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                DispatchQueue.main.async {
                    let url = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url, options: [:])
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
    
}
