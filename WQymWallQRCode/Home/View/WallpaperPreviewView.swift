//
//  WallpaperPreviewView.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/11.
//

import UIKit

class WallpaperPreviewView: UIView {
    
    var iconImage: UIImage
    var bgImage: UIImage
    var bgColor: UIColor
    var iconWidth: CGFloat
    var padding: CGFloat
    
    
    var iconImageViews: [UIImageView] = []
    var canvasView: UIView = UIView(frame: .zero)
    var bgImageView: UIImageView = UIImageView(frame: .zero)
    
    
    init(frame: CGRect, iconImage: UIImage, bgImage: UIImage, bgColor: UIColor, iconWidth: CGFloat, padding: CGFloat) {
        self.iconImage = iconImage
        self.bgImage = bgImage
        self.bgColor = bgColor
        self.iconWidth = iconWidth
        self.padding = padding
        super.init(frame: frame)
        setupView()
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // bg canvas
        
        
        canvasView = UIView(frame: frame)
        canvasView.clipsToBounds = true
        self.addSubview(canvasView)
        canvasView.backgroundColor = self.bgColor
        
        // bg Image view
        
        bgImageView = UIImageView(frame: frame)
        bgImageView.image = bgImage
        bgImageView.contentMode = .scaleAspectFill
        canvasView.addSubview(bgImageView)
        
        //
        
        
        let horCount: Int = Int(ceil(frame.size.width / (padding + iconWidth))) + 1
        let verCount: Int = Int(ceil(frame.size.height / (padding + iconWidth))) + 1
        
        iconImageViews = []
        
        for l in 0...verCount {
            for index in 0...horCount {
                let isJishu: Bool = (l % 2 == 1) ? true : false
                let isFlip: Bool = (l % 3 == 0) ? true : false
                let jishuOffset: CGFloat = isJishu ? (-(iconWidth + padding) / 2) : 0
                let x: CGFloat = (iconWidth + padding) * CGFloat(index) + jishuOffset
                let y: CGFloat = (iconWidth + padding) * CGFloat(l)
                let iconV = UIImageView(frame: CGRect(x: x, y: y, width: iconWidth, height: iconWidth))
                if isFlip {
                    iconV.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
                
                canvasView.addSubview(iconV)
                iconImageViews.append(iconV)
            }
        }
        
        updateContentIconImage(iconImage: iconImage)
        
    }
    
    func updateContentIconImage(iconImage: UIImage) {
        
        for iconImageV in iconImageViews {
            self.iconImage = iconImage
            iconImageV.image = iconImage
        }
    }
    
    func updateCanvasBgColor(color: UIColor) {
        canvasView.backgroundColor = color
    }
    
    func updateBgImage(image: UIImage) {
        bgImageView.image = image
    }
    
}
