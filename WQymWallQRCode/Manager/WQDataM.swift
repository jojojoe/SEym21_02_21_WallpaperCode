//
//  WQDataM.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/10.
//

import UIKit

class WQDataM {
    var shapeItemList: [CreatorEmojiStickerItem] = []
    var stickerItemList: [CreatorEmojiStickerItem] = []
    var backgroundItemList: [CreatorEmojiStickerItem] = []
    var creatorEmojiItemList: [CreatorEmojiStickerItem] = []
    var creatorStickerItemList: [CreatorEmojiStickerItem] = []
    
    static let `default` = WQDataM()
    
    init() {
        loadData()
    }
    
    func loadData() {
        shapeItemList = loadJson([CreatorEmojiStickerItem].self, name: "ShapeList") ?? []
        stickerItemList = loadJson([CreatorEmojiStickerItem].self, name: "StickerList") ?? []
        backgroundItemList = loadJson([CreatorEmojiStickerItem].self, name: "BackgroundList") ?? []
        
        creatorEmojiItemList = loadJson([CreatorEmojiStickerItem].self, name: "CreatorEmojiItemList") ?? []
        creatorStickerItemList = loadJson([CreatorEmojiStickerItem].self, name: "CreatorStickerItemList") ?? []
        
    }
    
    
}


extension WQDataM {
    func loadJson<T: Codable>(_:T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}



struct CreatorEmojiStickerItem: Codable, Identifiable, Hashable {
    static func == (lhs: CreatorEmojiStickerItem, rhs: CreatorEmojiStickerItem) -> Bool {
        return lhs.id == rhs.id && lhs.thumbName == rhs.thumbName
    }
    var id: Int = 0
    var thumbName: String = ""
    var bigName: String = ""
    var isPro: Bool = false
     
}

 

//
//
//struct ShapeItem: Codable, Identifiable, Hashable {
//    static func == (lhs: ShapeItem, rhs: ShapeItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//struct StickerItem: Codable, Identifiable, Hashable {
//    static func == (lhs: StickerItem, rhs: StickerItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//struct BackgroundItem: Codable, Identifiable, Hashable {
//    static func == (lhs: BackgroundItem, rhs: BackgroundItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//
