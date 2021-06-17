 //
//  GCTotoCreatorHOmeVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/11.
//

import UIKit
import AVFoundation
 
class GCTotoCreatorHOmeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setupView()
        
    }
    
    func setupView() {
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
        let btnBgView = UIView()
        view.addSubview(btnBgView)
        btnBgView.snp.makeConstraints {
            $0.height.equalTo(470)
            $0.width.equalTo(360)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            
        }
        //
        let emojiMakerBtn = GCCreatorToolBtn(frame: .zero, bgImgName: "creator_background1", iconImgName: "creator_emoji", nameStr: "Emoji Maker")
        btnBgView.addSubview(emojiMakerBtn)
        emojiMakerBtn.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(144)
        }
        emojiMakerBtn.addTarget(self, action: #selector(emojiMakerBtnClick(sender:)), for: .touchUpInside)
        //
        let stickerMakerBtn = GCCreatorToolBtn(frame: .zero, bgImgName: "creator_background2", iconImgName: "creator_sticker", nameStr: "Sticker Maker")
        btnBgView.addSubview(stickerMakerBtn)
        stickerMakerBtn.snp.makeConstraints {
            $0.top.equalTo(emojiMakerBtn.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(144)
        }
        stickerMakerBtn.addTarget(self, action: #selector(stickerMakerBtnClick(sender:)), for: .touchUpInside)
        //
        let photoMakerBtn = GCCreatorToolBtn(frame: .zero, bgImgName: "creator_background1", iconImgName: "creator_photo", nameStr: "Photo Maker")
        btnBgView.addSubview(photoMakerBtn)
        photoMakerBtn.snp.makeConstraints {
            $0.top.equalTo(stickerMakerBtn.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(144)
        }
        photoMakerBtn.addTarget(self, action: #selector(photoMakerBtnClick(sender:)), for: .touchUpInside)
        
    }

}
 
 extension GCTotoCreatorHOmeVC {
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

extension GCTotoCreatorHOmeVC {
    
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func emojiMakerBtnClick(sender: UIButton) {
        let wallpaperVC = EMEmojiStickerMakerVC(itemList: WQDataM.default.creatorEmojiItemList, defaulIconName: WQDataM.default.creatorEmojiItemList.first?.thumbName ?? "")
        self.navigationController?.pushViewController(wallpaperVC)
        
    }
    @objc func stickerMakerBtnClick(sender: UIButton) {
        let wallpaperVC = EMEmojiStickerMakerVC(itemList: WQDataM.default.creatorStickerItemList, defaulIconName: WQDataM.default.creatorStickerItemList.first?.thumbName ?? "")
        self.navigationController?.pushViewController(wallpaperVC)
    }
    @objc func photoMakerBtnClick(sender: UIButton) {
        
        func showUserPhotoCameraVC() {
            let vc = GTCreatorCameraVC(isUserWallpaperStatus: true)
            self.navigationController?.pushViewController(vc)
        }
        
        
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // 允许
            DispatchQueue.main.async {
                showUserPhotoCameraVC()
            }
            
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] granted in
                guard let `self` = self else {return}
                if !granted {
                    // 不允许
                    DispatchQueue.main.async {
                        self.showSettingAlertVC()
                    }
                } else {
                    // 允许
                    DispatchQueue.main.async {
                        showUserPhotoCameraVC()
                    }
                }
            })
            break
        default:
            // 不允许
            
            DispatchQueue.main.async {
                self.showSettingAlertVC()
            }

            break
        }
        
        
    }
    
    
}
 
 
 class GCCreatorToolBtn: UIButton {
    
    var bgImgName: String
    var iconImgName: String
    var nameStr: String
    
    
    init(frame: CGRect, bgImgName: String, iconImgName: String, nameStr: String) {
        self.bgImgName = bgImgName
        self.iconImgName = iconImgName
        self.nameStr = nameStr
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
         
        //
        let bgImageV = UIImageView()
        bgImageV.backgroundColor = .clear
        bgImageV.contentMode = .scaleAspectFit
        bgImageV.image = UIImage(named: bgImgName)
        addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        //
        let iconImgV = UIImageView(image: UIImage(named: iconImgName))
        iconImgV.contentMode = .scaleAspectFit
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(10)
            $0.left.equalTo(54)
            $0.width.height.equalTo(40)
        }
        
        //
        let nameLabel = UILabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = nameStr
        nameLabel.textColor = UIColor.white
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Avenir-Black", size: 22)
        nameLabel.adjustsFontSizeToFitWidth = true
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImgV)
            $0.left.equalTo(107)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
         
    }
 }
