//
//  MKqrcodeTextInputView.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/16.
//

import UIKit

class MKqrcodeTextInputView: UIView {

    var okBtnClickBlock: ((String)->Void)?
    var cancelBtnClickBlock: (()->Void)?
    var textInpuView = UITextField()
    
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
            $0.top.equalTo(44)
            $0.width.equalTo(372)
            $0.height.equalTo(300)
        }
         //
        let contentImgV = UIImageView(image: UIImage(named: "background"))
        contentBgView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont(name: "Avenir-Black", size: 22)
        contentLabel.textColor = UIColor.white
        contentLabel.text = "Make QRcode"
        contentLabel.textAlignment = .center
        contentBgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(56)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let textBgView = UIView()
        textBgView.backgroundColor = UIColor.white
        textBgView.layer.cornerRadius = 35
        contentBgView.addSubview(textBgView)
        textBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentLabel.snp.bottom).offset(26)
            $0.width.equalTo(355)
            $0.height.equalTo(70)
        }
        //
        textBgView.addSubview(textInpuView)
        textInpuView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalTo(40)
            $0.top.equalTo(22)
        }
        textInpuView.font = UIFont(name: "Avenir-Black", size: 18)
        textInpuView.textColor = .black
        textInpuView.placeholder = "Put in your text..."
        
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
        textInpuView.resignFirstResponder()
        okBtnClickBlock?(textInpuView.text ?? "")
    }
    @objc func cancelBtnClick(sender: UIButton) {
        textInpuView.resignFirstResponder()
        cancelBtnClickBlock?()
    }
}
