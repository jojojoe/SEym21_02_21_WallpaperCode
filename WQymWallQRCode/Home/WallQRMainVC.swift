//
//  WallQRMainVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/10.
//

import UIKit
import AVFoundation

class WallQRMainVC: UIViewController {
    let homeView = HOmeView()
    var settingView: SEttingView?
    let storeView = SToreView()
    
    let bottomHomeBtn = UIButton(type: .custom)
    let bottomSettingBtn = UIButton(type: .custom)
    let bottomStoreBtn = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setupView()
        
        bottomHomeBtnClick(sender: bottomHomeBtn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.settingView?.updateUserAccountStatus()
    }
    
}

extension WallQRMainVC {
    func setupView() {
        setupContentView()
        setupBottomBtn()
        
    }
    
    func setupContentView() {
        view.backgroundColor = UIColor(hexString: "#131217")
        view.addSubview(homeView)
        homeView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        homeView.exploreNowBtnBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.exploreNowAction()
            }
        }
        homeView.gotoCreatorBtnBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.goCreatorAction()
            }
        }
        homeView.codeScanBtnBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.qrCodeScanAction()
            }
        }
        
        //
        self.settingView = SEttingView()
        self.settingView?.upVC = self
        self.settingView?.isHidden = true
        
        self.view.addSubview(self.settingView!)
        self.settingView?.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        //
        
        storeView.upVC = self
        storeView.isHidden = true
        view.addSubview(storeView)
        storeView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        
    }
    
    func setupBottomBtn() {
        bottomHomeBtn.setImage(UIImage(named: "setting_ic_home_unselect"), for: .normal)
        bottomHomeBtn.setImage(UIImage(named: "home_ic_home_select"), for: .selected)
        view.addSubview(bottomHomeBtn)
        bottomHomeBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            $0.width.height.equalTo(212/2)
        }
        bottomHomeBtn.addTarget(self, action: #selector(bottomHomeBtnClick(sender:)), for: .touchUpInside)
        //
        
        bottomSettingBtn.setImage(UIImage(named: "home_ic_setting_unselect"), for: .normal)
        bottomSettingBtn.setImage(UIImage(named: "setting_ic_setting_select"), for: .selected)
        view.addSubview(bottomSettingBtn)
        bottomSettingBtn.snp.makeConstraints {
            $0.right.equalTo(bottomHomeBtn.snp.left).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            $0.width.height.equalTo(212/2)
        }
        bottomSettingBtn.addTarget(self, action: #selector(bottomSettingBtnClick(sender:)), for: .touchUpInside)
        //
        
        bottomStoreBtn.setImage(UIImage(named: "home_ic_store_unselect"), for: .normal)
        bottomStoreBtn.setImage(UIImage(named: "store_ic_store_select"), for: .selected)
        view.addSubview(bottomStoreBtn)
        bottomStoreBtn.snp.makeConstraints {
            $0.left.equalTo(bottomHomeBtn.snp.right).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            $0.width.height.equalTo(212/2)
        }
        bottomStoreBtn.addTarget(self, action: #selector(bottomStoreBtnClick(sender:)), for: .touchUpInside)
    }
    
    @objc func bottomHomeBtnClick(sender: UIButton) {
        bottomHomeBtn.isSelected = true
        bottomSettingBtn.isSelected = false
        bottomStoreBtn.isSelected = false
        homeView.isHidden = false
        settingView?.isHidden = true
        storeView.isHidden = true
    }
    @objc func bottomSettingBtnClick(sender: UIButton) {
        bottomSettingBtn.isSelected = true
        bottomHomeBtn.isSelected = false
        bottomStoreBtn.isSelected = false
        homeView.isHidden = true
        settingView?.isHidden = false
        storeView.isHidden = true
    }
    @objc func bottomStoreBtnClick(sender: UIButton) {
        bottomStoreBtn.isSelected = true
        bottomSettingBtn.isSelected = false
        bottomHomeBtn.isSelected = false
        homeView.isHidden = true
        settingView?.isHidden = true
        storeView.isHidden = false
    }
}

extension WallQRMainVC {
    func exploreNowAction() {
        func showVC() {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                let vc = GTCreatorCameraVC(isUserWallpaperStatus: false)
                self.navigationController?.pushViewController(vc)
            }

        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showVC()
            break
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    if !granted {
                        // not notAuthorized
                        self.showSettingAlertVC()
                    }
    //                Authorized
                    showVC()
                }
            })
        default:
        // not notAuthorized
            showSettingAlertVC()
            break
        }
    }
    
    func goCreatorAction() {
        let vc = GCTotoCreatorHOmeVC()
        self.navigationController?.pushViewController(vc)
    }
    
    func qrCodeScanAction() {
        func showVC() {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                let vc = QRCodeScanVC()
                self.navigationController?.pushViewController(vc)
            }
        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showVC()
            break
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    if !granted {
                        // not notAuthorized
                        self.showSettingAlertVC()
                    }
                    //                Authorized
                    showVC()
                }
            })
        default:
            // not notAuthorized
            showSettingAlertVC()
            break
        }
    }
    
    
    func showSettingAlertVC() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let alert = UIAlertController(title: "Oops", message: "You have declined access to camera, please active it in Settings>Privacy>Camera.", preferredStyle: .alert)
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
