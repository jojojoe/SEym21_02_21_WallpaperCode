//
//  COinAlertView.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/11.
//

import UIKit


class CUIymCoinAlertView: UIView {

    var okBtnClickBlock: (()->Void)?
    var cancelBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
//         724 × 704
        let contentBgView = UIView()
        contentBgView.backgroundColor = .clear
        addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(372)
            $0.height.equalTo(331)
        }
        //
        let contentImgV = UIImageView(image: UIImage(named: "cost_background"))
        contentBgView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont(name: "Avenir-Black", size: 22)
        contentLabel.textColor = UIColor.white
        
        contentLabel.text = "Use Paid items will be deducted \(WQCoinManag.default.coinCostCount) coins."
        
//        "Because you are using a paid item,\(WQCoinManag.default.coinCostCount) coins will be charged when saving"
        contentLabel.textAlignment = .center
        contentBgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(117)
            $0.left.equalToSuperview().offset(35)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let okBtn = UIButton(type: .custom)
        contentBgView.addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-24)
            $0.width.equalTo(354)
            $0.height.equalTo(69)
            $0.centerX.equalToSuperview()
        }
        okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        okBtn.setTitle("OK", for: .normal)
        okBtn.setTitleColor(.white, for: .normal)
        okBtn.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        okBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        //
        let cancelBtn = UIButton(type: .custom)
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints {
            $0.top.equalTo(contentBgView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "cost_ic_close"), for: .normal)
        
        
    }
    
    @objc func okBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
    @objc func cancelBtnClick(sender: UIButton) {
        cancelBtnClickBlock?()
    }
}
