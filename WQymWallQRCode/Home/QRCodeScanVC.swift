//
//  QRCodeScanVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/16.
//

import UIKit

class QRCodeScanVC: LBXScanViewController {
    let backBtn = UIButton(type: .custom)
    let bgCanvasView = UIView()
    //相册
    var albumBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
        
        setupView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(albumBtn)
        view.bringSubviewToFront(backBtn)
    }
     
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
            }
        }
        let result: LBXScanResult = arrayResult[0]
        let vc = QRScanResultVC()
        vc.codeResult = result
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension QRCodeScanVC {
    
}

extension QRCodeScanVC {
    func setupView() {
        //
//        let bgImgV = UIImageView(image: UIImage(named: "home_background"))
//        bgImgV.contentMode = .scaleAspectFill
//        view.addSubview(bgImgV)
//        bgImgV.snp.makeConstraints {
//            $0.left.right.top.bottom.equalToSuperview()
//        }
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
        //
//        bgCanvasView.backgroundColor = .clear
//        bgCanvasView.layer.borderWidth = 1
//        bgCanvasView.layer.borderColor = UIColor.white.cgColor
//        view.addSubview(bgCanvasView)
//        bgCanvasView.snp.makeConstraints {
//            $0.top.equalTo(backBtn.snp.bottom).offset(10)
//            $0.centerX.equalToSuperview()
//            $0.width.height.equalTo(372)
//        }
        
        //
        let bgBottomView = UIView()
        bgBottomView.backgroundColor = .clear
        view.addSubview(bgBottomView)
        bgBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(200)
        }
        //
        albumBtn.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        albumBtn.setTitle("Album", for: .normal)
        albumBtn.setTitleColor(.white, for: .normal)
        albumBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        view.addSubview(albumBtn)
        albumBtn.snp.makeConstraints {
            $0.centerY.equalTo(bgBottomView)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(354)
            $0.height.equalTo(70)
        }
        albumBtn.addTarget(self, action: #selector(albumBtnClick(sender:)), for: .touchUpInside)
    }
    
    
}

extension QRCodeScanVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func albumBtnClick(sender: UIButton) {
        LBXPermissions.authorizePhotoWith { [weak self] success in
            if success {
                let picker = UIImagePickerController()
                picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true, completion: nil)
            } else {
                self?.showAlert(title: "Oops!", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", buttonTitles: ["Cancel", "Ok"], highlightedButtonIndex: 0) { (index) in
                    if index == 0 {
                        
                    } else {
                        self?.openSettingPage()
                    }
                }
            }
        }
    }
    
    
}


