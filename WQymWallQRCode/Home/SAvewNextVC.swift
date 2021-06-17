//
//  SAvewNextVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/11.
//

import UIKit
import Photos


class SAvewNextVC: UIViewController {
    
    var hightHDImg: UIImage
    let coinAlertView = CUIymCoinAlertView()
    var shouldCostCoin: Bool = false
    
    
    init(hightHDImg: UIImage) {
        self.hightHDImg = hightHDImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCoinAlertView()
        
    }
    
    
}

extension SAvewNextVC {
    func setupView() {
        //
        let bgImgV = UIImageView(image: UIImage(named: "home_background"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "edit_ic_back"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        //
        let width: CGFloat = UIScreen.main.bounds.width - (60 * 2)
        let height: CGFloat = width * (hightHDImg.size.height / hightHDImg.size.width)
        
        let previewImgV = UIImageView(image: hightHDImg)
        previewImgV.contentMode = .scaleAspectFit
        view.addSubview(previewImgV)
        previewImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(6)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            
        }
        //
        let saveBtnHD = UIButton(type: .custom)
        saveBtnHD.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        saveBtnHD.setTitle("Save HD Picture", for: .normal)
        saveBtnHD.setTitleColor(.white, for: .normal)
        saveBtnHD.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        view.addSubview(saveBtnHD)
        saveBtnHD.snp.makeConstraints {
            $0.width.equalTo(354)
            $0.height.equalTo(69)
            $0.top.equalTo(previewImgV.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
        }
        //
        let vipImgV = UIImageView(image: UIImage(named: "edit_ic_vip"))
        view.addSubview(vipImgV)
        vipImgV.snp.makeConstraints {
            $0.centerY.equalTo(saveBtnHD.snp.top)
            $0.right.equalTo(saveBtnHD)
            $0.width.height.equalTo(24)
        }
        saveBtnHD.addTarget(self, action: #selector(saveHDpictureBtnClick(sender:)), for: .touchUpInside)
        //
        let saveSmallBtn = UIButton(type: .custom)
        view.addSubview(saveSmallBtn)
        saveSmallBtn.addTarget(self, action: #selector(saveSmallpictureBtnClick(sender:)), for: .touchUpInside)
        saveSmallBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(saveBtnHD.snp.bottom).offset(8)
            $0.width.equalTo(saveBtnHD)
            $0.height.equalTo(50)
        }
        saveSmallBtn.setTitle("Save Small Pic", for: .normal)
        saveSmallBtn.setTitleColor(.white, for: .normal)
        saveSmallBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 18)
        
    }
    
    func setupCoinAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if WQCoinManag.default.coinCount >= WQCoinManag.default.coinCostCount {
                DispatchQueue.main.async {
                    self.shouldCostCoin = true
                    self.saveToAlbumPhotoAction(images: [self.hightHDImg])
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Not enough coins, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(SToreCOinVC())
                        }
                    }
                }
            }
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            }
        }
        coinAlertView.cancelBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            }
        }
    }
    
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func saveHDpictureBtnClick(sender: UIButton) {
        UIView.animate(withDuration: 0.35) {
            self.coinAlertView.alpha = 1
        }
    }
    @objc func saveSmallpictureBtnClick(sender: UIButton) {
        
        if let small = hightHDImg.sd_resizedImage(with: CGSize(width: 500, height: 500), scaleMode: .aspectFill) {
            debugPrint("small = \(small)")
            shouldCostCoin = false
            saveToAlbumPhotoAction(images: [small])
        }
        
    }
}

extension SAvewNextVC {
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
                        if self.shouldCostCoin {
                            WQCoinManag.default.costCoin(coin: WQCoinManag.default.coinCostCount)
                        }
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
