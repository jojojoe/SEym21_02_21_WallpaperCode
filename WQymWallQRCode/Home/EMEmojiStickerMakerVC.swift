//
//  EMEmojiStickerMakerVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/11.
//

import UIKit

class EMEmojiStickerMakerVC: UIViewController {

    var contentItemlist: [CreatorEmojiStickerItem]
    let backBtn = UIButton(type: .custom)
    let nextBtn = UIButton(type: .custom)
    var stickerView: STickerCollectionView?
    var wallpaper: WallpaperPreviewView?
    var defaulIconName: String = ""
    var defaulIconImg: UIImage?
    
    init(itemList: [CreatorEmojiStickerItem], defaulIconName: String = "", defaulIconImg: UIImage? = nil) {
        contentItemlist = itemList
        self.defaulIconName = defaulIconName
        self.defaulIconImg = defaulIconImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setupView()
        setupPreview()
        setupStickerCollection()
        
    }
    
    func previewWidth() -> CGFloat {
        UIScreen.main.bounds.width - 30 * 2
    }
    
    func previewHeight() -> CGFloat {
        UIScreen.main.bounds.height - 180
    }
     

}

extension EMEmojiStickerMakerVC {
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
        //
        
        view.addSubview(nextBtn)
        nextBtn.addTarget(self, action: #selector(nextBtnClick(sender:)), for: .touchUpInside)
        nextBtn.setImage(UIImage(named: "edit_ic_next"), for: .normal)
        nextBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.right.equalTo(-10)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        //
    }
    
    func setupPreview() {
        var iconImg = UIImage()
        if let iconImg_m = self.defaulIconImg {
            iconImg = iconImg_m
        }
        if let iconImg_m = UIImage(named: defaulIconName) {
            iconImg = iconImg_m
        }
        let bgImg = UIImage()
        let emojiIconWidth: CGFloat = 60
        let emojiPadding: CGFloat = 20
        
        //
        let borderView = UIView()
        borderView.backgroundColor = UIColor(hexString: "#141218")
        borderView.layer.borderWidth = 1.5
        borderView.layer.borderColor = UIColor(hexString: "#FFFFFF")?.cgColor
        view.addSubview(borderView)
        
        //
        wallpaper = WallpaperPreviewView(frame: CGRect(x: 0, y: 0, width: previewWidth(), height: previewHeight()), iconImage: iconImg, bgImage: bgImg, bgColor: UIColor.white, iconWidth: emojiIconWidth, padding: emojiPadding)
        view.addSubview(wallpaper!)
        wallpaper?.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(previewWidth())
            $0.height.equalTo(previewHeight())
        }
        
        borderView.snp.makeConstraints {
            $0.center.equalTo(wallpaper!)
            $0.left.equalTo(wallpaper!.snp.left).offset(-7)
            $0.top.equalTo(wallpaper!.snp.top).offset(-7)
        }
        //
        let btn = UIButton(type: .custom)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(borderView)
        }
        btn.addTarget(self, action: #selector(contentBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    func setupStickerCollection() {
        stickerView = STickerCollectionView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), itemList: contentItemlist)
        stickerView?.currentStickerName = defaulIconName
        view.addSubview(stickerView!)
        stickerView?.closeBtnBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.showStickerStatus(isShow: false)
            }
        }
        stickerView?.clickItemBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateContentSticker(item: item)
            }
        }
    }

    
    func showStickerStatus(isShow: Bool) {
        if isShow {
            UIView.animate(withDuration: 0.35) {
                [weak self] in
                guard let `self` = self else {return}
                self.stickerView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        } else {
            UIView.animate(withDuration: 0.35) {
                [weak self] in
                guard let `self` = self else {return}
                self.stickerView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
        
        
    }
    func updateContentSticker(item: CreatorEmojiStickerItem) {
        if let img = UIImage(named: item.thumbName) {
            self.wallpaper?.updateContentIconImage(iconImage: img)
        }
    }
}



extension EMEmojiStickerMakerVC {
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func nextBtnClick(sender: UIButton) {
        let scale: CGFloat = 2
        
        let view = WallpaperPreviewView(frame: CGRect(x: 0, y: 0, width: previewWidth() * scale, height: previewHeight() * scale), iconImage: wallpaper!.iconImage, bgImage: wallpaper!.bgImage, bgColor: wallpaper!.bgColor, iconWidth: wallpaper!.iconWidth * scale, padding: wallpaper!.padding * scale)
        if let img = view.screenshot {
            debugPrint(img)
            
            let nextVC = SAvewNextVC(hightHDImg: img)
            self.navigationController?.pushViewController(nextVC)   
        }
        
        
    }
    
    @objc func contentBtnClick(sender: UIButton) {
        if contentItemlist.count >= 1 {
            showStickerStatus(isShow: true)
        }
        
    }
    
}
