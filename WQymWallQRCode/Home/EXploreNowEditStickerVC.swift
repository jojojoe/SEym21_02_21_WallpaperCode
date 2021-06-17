//
//  EXploreNowEditStickerVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/15.
//

import UIKit
import DeviceKit
class EXploreNowEditStickerVC: UIViewController {

    let backBtn = UIButton(type: .custom)
    let nextBtn = UIButton(type: .custom)
    
    var contentImg: UIImage?
    var shapeImg: UIImage?
    var contentIsPro: Bool
    
    let bgCanvasView = UIView()
    let canvasView = UIView()
    let userImgV = UIImageView(image: nil)
    let overlayerImgV = UIView()//UIImageView(image: nil)
    let shapeImgV = UIImageView(image: nil)
    let stickerImgV = UIImageView(image: nil)
    
    var collection: UICollectionView!
    
    var dataList: [CreatorEmojiStickerItem] = []
    var currentSelectItem: CreatorEmojiStickerItem?
    var currentIsVip: Bool = false
    
    
    init(image: UIImage?, shapeImg: UIImage?, isPro: Bool = false) {
        self.contentImg = image
        self.shapeImg = shapeImg
        self.contentIsPro = isPro
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupView()
        setupCanvasView()
        setupDefaultImgs()
        setupCollection()
    }
    

     

}


extension EXploreNowEditStickerVC {
    func loadData() {
        dataList = WQDataM.default.stickerItemList
        currentSelectItem = dataList.first
        currentIsVip = false
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
    }
    
    func setupCanvasView() {
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

        canvasView.backgroundColor = UIColor.white
        view.addSubview(canvasView)
        canvasView.snp.makeConstraints {
            $0.width.height.equalTo(cameraWidth)
            $0.center.equalTo(bgCanvasView)
        }
        //

        userImgV.contentMode = .scaleAspectFill
        canvasView.addSubview(userImgV)
        userImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        overlayerImgV.backgroundColor = .white
        canvasView.addSubview(overlayerImgV)
        overlayerImgV.frame = CGRect(x: 0, y: 0, width: cameraWidth, height: cameraWidth)
        //

        shapeImgV.backgroundColor = .clear
        canvasView.addSubview(shapeImgV)
        shapeImgV.frame = CGRect(x: 0, y: 0, width: cameraWidth, height: cameraWidth)
        
//
        //
        stickerImgV.backgroundColor = .clear
        canvasView.addSubview(stickerImgV)
        stickerImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let randomBtn = UIButton(type: .custom)
        view.addSubview(randomBtn)
        randomBtn.setImage(UIImage(named: "camera_ic_random"), for: .normal)
        randomBtn.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.bottom.equalTo(canvasView.snp.bottom).offset(-10)
            $0.right.equalTo(canvasView.snp.right).offset(-10)
        }
        randomBtn.addTarget(self, action: #selector(randomBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    func setupDefaultImgs() {
        userImgV.image = contentImg
        shapeImgV.image = shapeImg
        stickerImgV.image = UIImage(named: currentSelectItem?.bigName ?? "")
        
        overlayerImgV.mask = shapeImgV
    }
    
    func setupCollection() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(bgCanvasView.snp.bottom).offset(24)
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: EXEditToolCollectionCell.self)
    }
    
}

extension EXploreNowEditStickerVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func nextBtnClick(sender: UIButton) {
        var isPro = false
        if contentIsPro || currentIsVip {
            isPro = true
        }
        
        let bgVC = EXploreNowEditBgVC(image: userImgV.image, shapeImg: shapeImgV.image, stickerImg: stickerImgV.image, isPro: isPro)
        self.navigationController?.pushViewController(bgVC)
        
    }
    
    @objc func randomBtnClick(sender: UIButton) {
        
        if let item = dataList.randomElement() {
            stickerImgV.image = UIImage(named: item.bigName)
            currentSelectItem = item
            collection.reloadData()
            if let index = dataList.firstIndex(of: item) {
                if index <= 3 {
                    currentIsVip = false
                } else {
                    currentIsVip = true
                }
            }
        }
    }
}

extension EXploreNowEditStickerVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: EXEditToolCollectionCell.self, for: indexPath)
        let item = dataList[indexPath.item]
        cell.contentImgV.image = UIImage(named: item.thumbName)
        if item.thumbName == currentSelectItem?.thumbName {
            cell.selectBgImgV.isHidden = false
        } else {
            cell.selectBgImgV.isHidden = true
        }
        if indexPath.item <= 3 {
            cell.vipImgV.isHidden = true
        } else {
            cell.vipImgV.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension EXploreNowEditStickerVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = (UIScreen.main.bounds.width - (74 * 4)) / 5
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = (UIScreen.main.bounds.width - (74 * 4)) / 5
        return padding - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = (UIScreen.main.bounds.width - (74 * 4)) / 5
        return padding - 1
    }
    
}

extension EXploreNowEditStickerVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataList[indexPath.item]
        stickerImgV.image = UIImage(named: item.bigName)
        if indexPath.item <= 3 {
            currentIsVip = false
        } else {
            currentIsVip = true
        }
        currentSelectItem = item
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

 







