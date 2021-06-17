//
//  STickerCollectionView.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/11.
//

import UIKit

class STickerCollectionView: UIView {
    var contentItemlist: [CreatorEmojiStickerItem]
    var collection: UICollectionView!
    var clickItemBlock: ((CreatorEmojiStickerItem)->Void)?
    var closeBtnBlock: (()->Void)?
    
    var currentStickerName: String = ""
    
    
    init(frame: CGRect, itemList: [CreatorEmojiStickerItem]) {
        contentItemlist = itemList
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension STickerCollectionView {
    func setupView() {
        backgroundColor = .clear
        let bgBtn = UIButton(type: .custom)
        addSubview(bgBtn)
        bgBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        bgBtn.addTarget(self, action: #selector(closeBtnClick(sender:)), for: .touchUpInside)
        
        //
        let bottomView = UIView()
        bottomView.backgroundColor = .black
        addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-418)
        }
        bottomView.layer.cornerRadius = 33
        //
        let overView = UIView()
        overView.backgroundColor = .black
        addSubview(overView)
        overView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(34)
        }
        //
        let closeBtn = UIButton(type: .custom)
        addSubview(closeBtn)
        closeBtn.setImage(UIImage(named: "emoji_ic_close"), for: .normal)
        closeBtn.snp.makeConstraints {
            $0.right.equalTo(-30)
            $0.width.height.equalTo(42)
            $0.top.equalTo(bottomView).offset(20)
        }
        closeBtn.addTarget(self, action: #selector(closeBtnClick(sender:)), for: .touchUpInside)
        
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(closeBtn.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: STickerCollectionCell.self)
        
    }
    
    
    
    
}
extension STickerCollectionView {
    @objc func closeBtnClick(sender: UIButton) {
        closeBtnBlock?()
    }
}




extension STickerCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: STickerCollectionCell.self, for: indexPath)
        let item = contentItemlist[indexPath.item]
        
        if currentStickerName == item.thumbName {
            cell.selectImgV.isHidden = false
        } else {
            cell.selectImgV.isHidden = true
        }
        cell.stickerImgV.image = UIImage(named: item.thumbName)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentItemlist.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension STickerCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = (UIScreen.main.bounds.width - (72 * 4) - 1) / 5
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = (UIScreen.main.bounds.width - (72 * 4) - 1) / 5
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = (UIScreen.main.bounds.width - (72 * 4) - 1) / 5
        return padding
    }
    
}

extension STickerCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = contentItemlist[indexPath.item]
        clickItemBlock?(item)
        currentStickerName = item.thumbName
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}








class STickerCollectionCell: UICollectionViewCell {
    let bgImgV = UIImageView()
    let selectImgV = UIImageView()
    let stickerImgV = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        //
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        bgImgV.contentMode = .scaleAspectFit
        bgImgV.image = UIImage(named: "edit_background")
        //
        contentView.addSubview(selectImgV)
        selectImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        selectImgV.contentMode = .scaleAspectFit
        selectImgV.image = UIImage(named: "edit_select")
        //
        contentView.addSubview(stickerImgV)
        stickerImgV.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(4)
            $0.right.bottom.equalToSuperview().offset(-4)
        }
        stickerImgV.contentMode = .scaleAspectFit
        
        
    }
    
    
    
}







