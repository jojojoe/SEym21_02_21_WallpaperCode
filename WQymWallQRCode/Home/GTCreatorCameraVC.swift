//
//  GTCreatorCameraVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/15.
//

import UIKit
import DeviceKit

class GTCreatorCameraVC: UIViewController {

    let backBtn = UIButton(type: .custom)
    var cameraView: WQCameraView?
    var stickerOverlayerImgV = UIImageView()
    
    var isUserWallpaperStatus: Bool
    
    
    init(isUserWallpaperStatus: Bool = false) {
        self.isUserWallpaperStatus = isUserWallpaperStatus
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotification()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraView?.checkAuthorizedStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cameraView?.stopCameraSessionRunning()
    }
    

}

extension GTCreatorCameraVC {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector:#selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        //注册进入后台的通知
        NotificationCenter.default.addObserver(self, selector:#selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)
    }
    @objc
    func becomeActive(noti:Notification){
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.cameraView?.checkAuthorizedStatus()
                
        }
        debugPrint("进入前台")
    }
    @objc
    func becomeDeath(noti:Notification){
        self.cameraView?.stopCameraSessionRunning()
        debugPrint("进入后台")
    }
}

extension GTCreatorCameraVC {
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
        let bgCanvasView = UIView()
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
        let canvasView = UIView()
        canvasView.backgroundColor = UIColor.white
        view.addSubview(canvasView)
        canvasView.snp.makeConstraints {
            $0.width.height.equalTo(cameraWidth)
            $0.center.equalTo(bgCanvasView)
        }
        //
        let cameraView = WQCameraView(frame: CGRect(x: 0, y: 0, width: cameraWidth, height: cameraWidth))
        canvasView.addSubview(cameraView)
        cameraView.delegate = self
        self.cameraView = cameraView
        //
        if isUserWallpaperStatus {
            let cameraShapeView = UIImageView(image: UIImage(named: "cameraOverlayer"))
            cameraShapeView.contentMode = .scaleAspectFill
            canvasView.addSubview(cameraShapeView)
            cameraShapeView.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
            //
            canvasView.addSubview(stickerOverlayerImgV)
            stickerOverlayerImgV.image = UIImage(named: "sticker_big2")
            stickerOverlayerImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
        }
        
        //
        let bottomBgImgV = UIImageView(image: UIImage(named: "camera_background"))
        view.addSubview(bottomBgImgV)
        bottomBgImgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-230)
        }
        //
        let takePhotoBtn = UIButton(type: .custom)
        view.addSubview(takePhotoBtn)
        takePhotoBtn.setImage(UIImage(named: "camera_ic_takephoto"), for: .normal)
        takePhotoBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomBgImgV.snp.top).offset(56)
            $0.width.height.equalTo(88)
        }
        takePhotoBtn.addTarget(self, action: #selector(takePhotoBtnClick(sender:)), for: .touchUpInside)
        //
        let rotateCameraBtn = UIButton(type: .custom)
        view.addSubview(rotateCameraBtn)
        rotateCameraBtn.setImage(UIImage(named: "camera_ic_turn"), for: .normal)
        rotateCameraBtn.snp.makeConstraints {
            $0.left.equalTo(takePhotoBtn.snp.right).offset(24)
            $0.top.equalTo(takePhotoBtn.snp.top)
            $0.width.height.equalTo(28)
        }
        rotateCameraBtn.addTarget(self, action: #selector(rotateCameraBtnClick(sender:)), for: .touchUpInside)
        //
        let takePhotoLabel = UILabel()
        takePhotoLabel.font = UIFont(name: "Avenir-Black", size: 20)
        takePhotoLabel.textColor = UIColor.white
        takePhotoLabel.text = "Take Photo"
        view.addSubview(takePhotoLabel)
        takePhotoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(takePhotoBtn.snp.bottom).offset(30)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        if isUserWallpaperStatus {
            let randomStickerBtn = UIButton(type: .custom)
            view.addSubview(randomStickerBtn)
            randomStickerBtn.setImage(UIImage(named: "camera_ic_random"), for: .normal)
            randomStickerBtn.snp.makeConstraints {
                $0.width.height.equalTo(40)
                $0.top.equalTo(bgCanvasView.snp.bottom).offset(20)
                $0.right.equalTo(canvasView)
            }
            randomStickerBtn.addTarget(self, action: #selector(randomStickerBtnClick(sender:)), for: .touchUpInside)
        }
        
    }
    
    
    
}

extension GTCreatorCameraVC {
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func takePhotoBtnClick(sender: UIButton) {
        self.cameraView?.takePhoto()
    }
    @objc func rotateCameraBtnClick(sender: UIButton) {
        self.cameraView?.rotateCamera()
    }
    @objc func randomStickerBtnClick(sender: UIButton) {
        let item = WQDataM.default.stickerItemList.randomElement()
        
        stickerOverlayerImgV.image = UIImage(named: item?.bigName ?? "")
    }
    
    
}



extension GTCreatorCameraVC: CameraViewControllerDelegate {
     
    func didFinishProcessingPhoto(_ image: UIImage) {
        debugPrint(image)
        
        if isUserWallpaperStatus {
            showWallpaerVC(image: image)
        } else {
            showExploreNowEditVC(image: image)
        }
        
    }
    
    func showExploreNowEditVC(image: UIImage) {
        let editVC = EXploreNowEditShapeVC(image: image, isPro: false)
        self.navigationController?.pushViewController(editVC)
    }
    
    
    func showWallpaerVC(image: UIImage) {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024))
        let imgV = UIImageView(image: image)
        bgView.addSubview(imgV)
        //
        let cameraShapeView = UIImageView(image: UIImage(named: "cameraOverlayer"))
        cameraShapeView.contentMode = .scaleAspectFill
        bgView.addSubview(cameraShapeView)
        cameraShapeView.frame = CGRect(x: 0, y: 0, width: 1024, height: 1024)
        //
        let stickerImgV = UIImageView(image: self.stickerOverlayerImgV.image)
        stickerImgV.frame = CGRect(x: 0, y: 0, width: 1024, height: 1024)
        bgView.addSubview(stickerImgV)
        
        if let result = bgView.screenshot {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                let wallpaperVC = EMEmojiStickerMakerVC(itemList: [], defaulIconImg: result)
                self.navigationController?.pushViewController(wallpaperVC)
            }
        }
        
        
        
    }
    
}

