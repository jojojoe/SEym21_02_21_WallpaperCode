//
//  WQCoinManag.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/10.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import Adjust
import NoticeObserveKit


class StoreItem {
    var id: Int = 0
    var iapId: String = ""
    var coin: Int  = 0
    var price: String = ""
    var color: String = ""
    init(id: Int, iapId: String, coin: Int, price: String, color: String) {
        self.id = id
        self.iapId = iapId
        self.coin = coin
        self.price = price
        self.color = color
        
    }
}


extension Notice.Names {
    
    static let pi_noti_coinChange = Notice.Name<Any?>(name: "pi_noti_coinChange")
    static let pi_noti_priseFetch = Notice.Name<Any?>(name: "pi_noti_priseFetch")
    
    
//    Notice.Center.default.post(name: Notice.Names.receiptInfoDidChange, with: nil)
//    NotificationCenter.default.nok.observe(name: .keyboardWillShow) { keyboardInfo in
//        print(keyboardInfo)
//    }
//    .invalidated(by: pool)
}



class WQCoinManag {
    var coinCount: Int
    var coinIpaItemList: [StoreItem]
    
    static let `default` = WQCoinManag()
    
    let coinFirst: Int = 100
    let coinCostCount: Int = 50
    
    let k_localizedPriceList = "StoreItem.localizedPriceList"
    
    init() {
        // coin count
        
        #if DEBUG
        KeychainSaveManager.removeKeychainCoins()
        #endif
        
        if KeychainSaveManager.isFirstSendCoin() {
            coinCount = coinFirst
        } else {
            coinCount = KeychainSaveManager.readCoinFromKeychain()
        }
        
        // iap items list
        
        let iapItem0 = StoreItem.init(id: 0, iapId: "com.Moncreation.FancyiIns.listone", coin: 100, price: "$1.99", color: "#FFDCEC")
        let iapItem1 = StoreItem.init(id: 1, iapId: "com.Moncreation.FancyiIns.listtwo", coin: 300, price: "$2.99", color: "#C9FFEE")
        let iapItem2 = StoreItem.init(id: 2, iapId: "com.Moncreation.FancyiIns.listthree", coin: 600, price: "$4.99", color: "#FFDCEC")
        let iapItem3 = StoreItem.init(id: 3, iapId: "com.Moncreation.FancyiIns.listfour", coin: 1000, price: "$6.99", color: "#C9FFEE")
        let iapItem4 = StoreItem.init(id: 4, iapId: "com.Moncreation.FancyiIns.listfive", coin: 1500, price: "$9.99", color: "#FFDCEC")
        let iapItem5 = StoreItem.init(id: 5, iapId: "com.Moncreation.FancyiIns.listsix", coin: 2000, price: "$12.99", color: "#C9FFEE")
        let iapItem6 = StoreItem.init(id: 6, iapId: "com.Moncreation.FancyiIns.listseven", coin: 3000, price: "$15.99", color: "#FFDCEC")
        let iapItem7 = StoreItem.init(id: 7, iapId: "com.Moncreation.FancyiIns.listeight", coin: 4000, price: "$19.99", color: "#C9FFEE")
        
        
        coinIpaItemList = [iapItem0, iapItem1, iapItem2, iapItem3, iapItem4, iapItem5, iapItem6, iapItem7]
        loadCachePrice()
        fetchPrice()
        
    }
    
    func costCoin(coin: Int) {
        coinCount -= coin
        saveCoinCountToKeychain(coinCount: coinCount)
    }
    
    func addCoin(coin: Int) {
        coinCount += coin
        saveCoinCountToKeychain(coinCount: coinCount)
    }
    
    func saveCoinCountToKeychain(coinCount: Int) {
        KeychainSaveManager.saveCoinToKeychain(iconNumber: "\(coinCount)")
        
        Notice.Center.default.post(name: .pi_noti_coinChange, with: nil)
        
    }
    
    func loadCachePrice() {
        
        if let localizedPriceDict = UserDefaults.standard.object(forKey: k_localizedPriceList) as?  [String: String] {
            for item in self.coinIpaItemList {
                if let price = localizedPriceDict[item.iapId] {
                    item.price = price
                }
            }
        }
    }
    
    func fetchPrice() {
        
        
        let iapList = coinIpaItemList.compactMap { $0.iapId }
        SwiftyStoreKit.retrieveProductsInfo(Set(iapList)) { [weak self] result in
            guard let `self` = self else { return }
            let priceList = result.retrievedProducts.compactMap { $0 }
            var localizedPriceList: [String: String] = [:]
            
            for (index, item) in self.coinIpaItemList.enumerated() {
                let model = priceList.filter { $0.productIdentifier == item.iapId }.first
                if let price = model?.localizedPrice {
                    self.coinIpaItemList[index].price = price
                    localizedPriceList[item.iapId] = price
                }
            }

            //TODO: 保存 iap -> 本地price
            UserDefaults.standard.set(localizedPriceList, forKey: self.k_localizedPriceList)
            
            Notice.Center.default.post(name: .pi_noti_priseFetch, with: nil)
        }
    }
    
    func purchaseIapId(iap: String, completion: @escaping ((Bool, String?)->Void)) {
        SwiftyStoreKit.purchaseProduct(iap) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint("self\(self)")
            switch result {
            case .success:
                Adjust.trackEvent(ADJEvent(eventToken: AdjustKey.AdjustKeyAppCoinsBuy.rawValue))
                completion(true, nil)
            case let .error(error):
//                HUD.error(error.localizedDescription)
                completion(false, error.localizedDescription)
            }
        }
    }
    
}
