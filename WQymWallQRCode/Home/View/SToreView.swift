//
//  SToreView.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/10.
//

import UIKit
import NoticeObserveKit
 
class SToreView: UIView {
    private var pool = Notice.ObserverPool()
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    var backBtn = UIButton(type: .custom)
    
    var upVC: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
         
        setupView()
        setupCollection()
        addNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "\(WQCoinManag.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        .invalidated(by: pool)
    }

}

extension SToreView {
    
   
    func setupView() {
        backgroundColor = UIColor(hexString: "#100F14")
        let bgImgV = UIImageView(image: UIImage(named: "home_background"))
        bgImgV.contentMode = .scaleAspectFill
        addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        //
        let settingLabel = UILabel()
        settingLabel.font = UIFont(name: "Avenir-Black", size: 22)
        settingLabel.textColor = .white
        settingLabel.text = "Store"
        addSubview(settingLabel)
        settingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(18)
            $0.width.height.greaterThanOrEqualTo(1)
        }
         
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "\(WQCoinManag.default.coinCount)"
        topCoinLabel.textColor = UIColor(hexString: "#FFFFFF")
        topCoinLabel.font = UIFont(name: "Avenir-Black", size: 18)
        addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(settingLabel)
            $0.right.equalTo(-18)
            $0.height.greaterThanOrEqualTo(35)
            $0.width.greaterThanOrEqualTo(25)
        }
        
        let coinImageV = UIImageView()
        coinImageV.image = UIImage(named: "icon_vip")
        coinImageV.contentMode = .scaleAspectFit
        addSubview(coinImageV)
        coinImageV.snp.makeConstraints {
            $0.centerY.equalTo(topCoinLabel)
            $0.right.equalTo(topCoinLabel.snp.left).offset(-4)
            $0.width.height.equalTo(28)
        }
        
        
    }
    
    func setupCollection() {
         
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.layer.cornerRadius = 35
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(topCoinLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(snp.bottom)
        }
        collection.register(cellWithClass: IHymStoreCell.self)
        
    }
    
    func selectCoinItem(item: StoreItem) {
        WQCoinManag.default.purchaseIapId(iap: item.iapId) { (success, errorString) in
            
            if success {
                WQCoinManag.default.addCoin(coin: item.coin)
                self.upVC?.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.upVC?.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
}


extension SToreView {
     
}


extension SToreView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: IHymStoreCell.self, for: indexPath)
        let item = WQCoinManag.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "\(item.coin)"
        cell.priceLabel.text = item.price
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WQCoinManag.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SToreView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 704/2, height: 228/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = ((UIScreen.main.bounds.width - (704/2) - 1) / 2)
        return UIEdgeInsets(top: 30, left: left, bottom: 30, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
}

extension SToreView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = WQCoinManag.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class IHymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        //
        bgImageV.backgroundColor = .clear
        bgImageV.contentMode = .scaleAspectFit
        bgImageV.image = UIImage(named: "store_button_background")
//        bgImageV.layer.masksToBounds = true
//        bgImageV.layer.cornerRadius = 27
//        bgImageV.layer.borderColor = UIColor.black.cgColor
//        bgImageV.layer.borderWidth = 4
        bgView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        //
        let iconImgV = UIImageView(image: UIImage(named: "store_ic_heart"))
        iconImgV.contentMode = .scaleAspectFit
        bgView.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(35)
            $0.width.height.equalTo(38)
        }
        
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel.textColor = UIColor.white
        coinCountLabel.numberOfLines = 1
        coinCountLabel.textAlignment = .center
        coinCountLabel.font = UIFont(name: "Avenir-Black", size: 22)
        coinCountLabel.adjustsFontSizeToFitWidth = true
        bgView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(90)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        coverImageV.image = UIImage(named: "home_button")
        coverImageV.contentMode = .center
        bgView.addSubview(coverImageV)
//
        //
        priceLabel.textColor = UIColor(hexString: "#FFFFFF")
        priceLabel.font = UIFont(name: "Avenir-Black", size: 20)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
//        priceLabel.backgroundColor = UIColor(hexString: "#4AD0EF")
        
//        priceLabel.cornerRadius = 30
        priceLabel.adjustsFontSizeToFitWidth = true
//        priceLabel.layer.borderWidth = 2
//        priceLabel.layer.borderColor = UIColor.white.cgColor
        priceLabel.snp.makeConstraints {
            $0.width.equalTo(135)
            $0.height.equalTo(54)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-20)
        }
        
        coverImageV.snp.makeConstraints {
            $0.center.equalTo(priceLabel.snp.center)
            $0.width.equalTo(135)
            $0.height.equalTo(54)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                
            } else {
                
            }
        }
    }
}
