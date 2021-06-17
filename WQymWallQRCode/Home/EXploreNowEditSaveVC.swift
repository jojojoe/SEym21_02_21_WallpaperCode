//
//  EXploreNowEditSaveVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/15.
//

import UIKit
import Photos


class EXploreNowEditSaveVC: UIViewController {

    let backBtn = UIButton(type: .custom)
    let contentImgV = UIImageView(image: nil)
    let contentImg: UIImage?
    let contentIsPro: Bool
    
    let coinAlertView = CUIymCoinAlertView()
    let qrcodeInputAlertView = MKqrcodeTextInputView()
    
    var isSavePhotoBtnClick: Bool = false
    
    init(image: UIImage?, isPro: Bool = false) {
        self.contentImg = image
        self.contentIsPro = isPro
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCoinAlertView()
        setupQRcodeInputAlertView()
    }
    
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
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.image = contentImg
        view.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(354)
        }
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
        let savePhotoBtn = UIButton(type: .custom)
        view.addSubview(savePhotoBtn)
        savePhotoBtn.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        savePhotoBtn.setTitle("Save Photo", for: .normal)
        savePhotoBtn.setTitleColor(.white, for: .normal)
        savePhotoBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        savePhotoBtn.addTarget(self, action: #selector(savePhotoBtnClick(sender:)), for: .touchUpInside)
        savePhotoBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(354)
            $0.height.equalTo(69)
            $0.bottom.equalTo(bgBottomView.snp.centerY).offset(-14)
        }
        //
        //
        let makeQRcode = UIButton(type: .custom)
        view.addSubview(makeQRcode)
        makeQRcode.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        makeQRcode.setTitle("Make QRcode", for: .normal)
        makeQRcode.setTitleColor(.white, for: .normal)
        makeQRcode.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        makeQRcode.addTarget(self, action: #selector(makeQRcodeClick(sender:)), for: .touchUpInside)
        makeQRcode.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(354)
            $0.height.equalTo(69)
            $0.top.equalTo(bgBottomView.snp.centerY).offset(14)
        }
        
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
                    if self.isSavePhotoBtnClick {
                        if let img = self.contentImg {
                            self.saveToAlbumPhotoAction(images: [img])
                        }
                    } else {
                        self.showQRTextInputAlertView()
                    }
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
    
    @objc func savePhotoBtnClick(sender: UIButton) {
        if contentIsPro {
            isSavePhotoBtnClick = true
            UIView.animate(withDuration: 0.35) {
                self.coinAlertView.alpha = 1
            }
        } else {
            if let img = self.contentImg {
                self.saveToAlbumPhotoAction(images: [img])
            }
        }
    }
    
    @objc func makeQRcodeClick(sender: UIButton) {
        if contentIsPro {
            isSavePhotoBtnClick = false
            UIView.animate(withDuration: 0.35) {
                self.coinAlertView.alpha = 1
            }
        } else {
            self.showQRTextInputAlertView()
        }
    }

    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


extension EXploreNowEditSaveVC {
    func qrResultImage(text: String, iconImg: UIImage) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        
        let canvasView = UIView()
        canvasView.frame = frame
        canvasView.backgroundColor = .white
        
        let qrImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: text, size: frame.size, qrColor: UIColor.black, bkColor: UIColor.white)

        let qrImageView = UIImageView()
        let padding: CGFloat = 10
        qrImageView.frame = CGRect(x: padding, y: padding, width: frame.size.width - padding * 2, height: frame.size.height - padding * 2)
        qrImageView.image = qrImg
        canvasView.addSubview(qrImageView)
        
        let addImageView = UIImageView()
        addImageView.frame = CGRect(x: 0, y: 0, width: 62, height: 62)
        addImageView.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addImageView.image = iconImg
        canvasView.addSubview(addImageView)
        
        return canvasView.screenshot ?? UIImage()
    }
}

extension EXploreNowEditSaveVC {
    
    func setupQRcodeInputAlertView() {
        
        qrcodeInputAlertView.alpha = 0
        view.addSubview(qrcodeInputAlertView)
        qrcodeInputAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        qrcodeInputAlertView.okBtnClickBlock = {
            [weak self] string in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                if let img = self.contentImg {
                    WQCoinManag.default.costCoin(coin: WQCoinManag.default.coinCostCount)
                    let result = self.qrResultImage(text: string, iconImg: img)
                    let qrResultVC = EXploreQRcodeResultVC(image: result)
                    self.navigationController?.pushViewController(qrResultVC)
                }
            }
            
            UIView.animate(withDuration: 0.25) {
                self.qrcodeInputAlertView.alpha = 0
            }
        }
        qrcodeInputAlertView.cancelBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.qrcodeInputAlertView.alpha = 0
            }
        }
    }
     
    func showQRTextInputAlertView() {
        UIView.animate(withDuration: 0.35) {
            self.qrcodeInputAlertView.alpha = 1
            self.qrcodeInputAlertView.textInpuView.becomeFirstResponder()
        }
    }
}



extension EXploreNowEditSaveVC {
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
                        if self.contentIsPro {
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
