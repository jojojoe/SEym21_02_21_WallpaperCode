//
//  HOmeView.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/10.
//

import UIKit

class HOmeView: UIView {

    let scrollView = UIScrollView()
    var exploreNowBtnBlock: (()->Void)?
    var gotoCreatorBtnBlock: (()->Void)?
    var codeScanBtnBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        backgroundColor = UIColor(hexString: "#100F14")
        let bgImgV = UIImageView(image: UIImage(named: "home_background"))
        bgImgV.contentMode = .scaleAspectFill
        addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        
        addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(snp.width)
//            $0.height.equalTo(800)
        }
        
        //
        let topLabel1 = UILabel()
        topLabel1.font = UIFont(name: "Avenir-Black", size: 28)
        topLabel1.textColor = .white
        topLabel1.text = "Create Epic Photo"
        scrollView.addSubview(topLabel1)
        topLabel1.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(18)
            $0.left.equalTo(40)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let topLabel2 = UILabel()
        topLabel2.font = UIFont(name: "Avenir-Black", size: 28)
        topLabel2.textColor = .white
        topLabel2.text = "&"
        scrollView.addSubview(topLabel2)
        topLabel2.snp.makeConstraints {
            $0.top.equalTo(topLabel1.snp.bottom).offset(1)
            $0.left.equalTo(topLabel1)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let topLabel3 = UILabel()
        topLabel3.font = UIFont(name: "Avenir-Black", size: 28)
        topLabel3.textColor = UIColor(hexString: "#786BFD")
        topLabel3.text = " Wallpapers"
        scrollView.addSubview(topLabel3)
        topLabel3.snp.makeConstraints {
            $0.top.equalTo(topLabel2.snp.top)
            $0.left.equalTo(topLabel2.snp.right)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        setupExploreNowBtn()
        setupGotoCreatorBtn()
        setupCodeScannerBtn()
        
    }
    
    func setupExploreNowBtn() {
        //
        let exploreNowBtnBgView = UIView()
        exploreNowBtnBgView.backgroundColor = .clear
        scrollView.addSubview(exploreNowBtnBgView)
        exploreNowBtnBgView.snp.makeConstraints {
            $0.width.equalTo(708/2)
            $0.height.equalTo(364/2)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top).offset(115)
        }
        let exploreNowBtnImgV = UIImageView(image: UIImage(named: "home_background_1"))
        exploreNowBtnImgV.contentMode = .scaleAspectFit
        exploreNowBtnBgView.addSubview(exploreNowBtnImgV)
        exploreNowBtnImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let exploreNowBtnLabel1 = UILabel()
        exploreNowBtnLabel1.font = UIFont(name: "Avenir-Black", size: 22)
        exploreNowBtnLabel1.text = "Take New One"
        exploreNowBtnLabel1.textColor = .white
        exploreNowBtnBgView.addSubview(exploreNowBtnLabel1)
        exploreNowBtnLabel1.snp.makeConstraints {
            $0.left.equalTo(34)
            $0.top.equalTo(32)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let exploreNowBtnLabel2 = UILabel()
        exploreNowBtnLabel2.font = UIFont(name: "Avenir-Medium", size: 14)
        exploreNowBtnLabel2.text = "Record The Beauty"
        exploreNowBtnLabel2.textColor = .white
        exploreNowBtnBgView.addSubview(exploreNowBtnLabel2)
        exploreNowBtnLabel2.snp.makeConstraints {
            $0.left.equalTo(exploreNowBtnLabel1)
            $0.top.equalTo(exploreNowBtnLabel1.snp.bottom).offset(1)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let starNowImgV = UIImageView(image: UIImage(named: "home_button"))
        exploreNowBtnBgView.addSubview(starNowImgV)
        starNowImgV.snp.makeConstraints {
            $0.left.equalTo(exploreNowBtnLabel1)
            $0.top.equalTo(exploreNowBtnLabel2.snp.bottom).offset(18)
            $0.width.equalTo(266/2)
            $0.height.equalTo(108/2)
        }
        //
        let starNowLabel = UILabel()
        starNowLabel.font = UIFont(name: "Avenir-Black", size: 20)
        starNowLabel.text = "Start now"
        starNowLabel.textColor = .white
        exploreNowBtnBgView.addSubview(starNowLabel)
        starNowLabel.snp.makeConstraints {
            $0.center.equalTo(starNowImgV)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        //
        let btn = UIButton(type: .custom)
        exploreNowBtnBgView.addSubview(btn)
        btn.addTarget(self, action: #selector(exploreNowBtnClick(sender:)), for: .touchUpInside)
        btn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setupGotoCreatorBtn() {
        //
        let exploreNowBtnBgView = UIView()
        exploreNowBtnBgView.backgroundColor = .clear
        scrollView.addSubview(exploreNowBtnBgView)
        exploreNowBtnBgView.snp.makeConstraints {
            $0.width.equalTo(708/2)
            $0.height.equalTo(364/2)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top).offset(325)
        }
        let exploreNowBtnImgV = UIImageView(image: UIImage(named: "home_background_2"))
        exploreNowBtnImgV.contentMode = .scaleAspectFit
        exploreNowBtnBgView.addSubview(exploreNowBtnImgV)
        exploreNowBtnImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let exploreNowBtnLabel1 = UILabel()
        exploreNowBtnLabel1.font = UIFont(name: "Avenir-Black", size: 22)
        exploreNowBtnLabel1.text = "Go to Create"
        exploreNowBtnLabel1.textColor = .white
        exploreNowBtnBgView.addSubview(exploreNowBtnLabel1)
        exploreNowBtnLabel1.snp.makeConstraints {
            $0.left.equalTo(34)
            $0.top.equalTo(32)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let exploreNowBtnLabel2 = UILabel()
        exploreNowBtnLabel2.font = UIFont(name: "Avenir-Medium", size: 14)
        exploreNowBtnLabel2.text = "Unleash Your Creativity"
        exploreNowBtnLabel2.textColor = .white
        exploreNowBtnBgView.addSubview(exploreNowBtnLabel2)
        exploreNowBtnLabel2.snp.makeConstraints {
            $0.left.equalTo(exploreNowBtnLabel1)
            $0.top.equalTo(exploreNowBtnLabel1.snp.bottom).offset(1)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let starNowImgV = UIImageView(image: UIImage(named: "home_button"))
        exploreNowBtnBgView.addSubview(starNowImgV)
        starNowImgV.snp.makeConstraints {
            $0.left.equalTo(exploreNowBtnLabel1)
            $0.top.equalTo(exploreNowBtnLabel2.snp.bottom).offset(18)
            $0.width.equalTo(266/2)
            $0.height.equalTo(108/2)
        }
        //
        let starNowLabel = UILabel()
        starNowLabel.font = UIFont(name: "Avenir-Black", size: 20)
        starNowLabel.text = "Start now"
        starNowLabel.textColor = .white
        exploreNowBtnBgView.addSubview(starNowLabel)
        starNowLabel.snp.makeConstraints {
            $0.center.equalTo(starNowImgV)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let btn = UIButton(type: .custom)
        exploreNowBtnBgView.addSubview(btn)
        btn.addTarget(self, action: #selector(gotoCreatorBtnClick(sender:)), for: .touchUpInside)
        btn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
        
    }
    
    func setupCodeScannerBtn() {
        let exploreNowBtnBgView = UIView()
        exploreNowBtnBgView.backgroundColor = .clear
        scrollView.addSubview(exploreNowBtnBgView)
        exploreNowBtnBgView.snp.makeConstraints {
            $0.width.equalTo(716/2)
            $0.height.equalTo(212/2)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top).offset(535)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-20)
        }
        let exploreNowBtnImgV = UIImageView(image: UIImage(named: "home_background3"))
        exploreNowBtnImgV.contentMode = .scaleAspectFit
        exploreNowBtnBgView.addSubview(exploreNowBtnImgV)
        exploreNowBtnImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let exploreNowBtnLabel1 = UILabel()
        exploreNowBtnLabel1.font = UIFont(name: "Avenir-Black", size: 22)
        exploreNowBtnLabel1.text = "Code Scanner"
        exploreNowBtnLabel1.textColor = .white
        exploreNowBtnBgView.addSubview(exploreNowBtnLabel1)
        exploreNowBtnLabel1.snp.makeConstraints {
            $0.left.equalTo(80)
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let imgV = UIImageView(image: UIImage(named: "home_ic_code"))
        exploreNowBtnBgView.addSubview(imgV)
        imgV.snp.makeConstraints {
            $0.width.height.equalTo(52/2)
            $0.left.equalTo(37)
            $0.centerY.equalToSuperview()
        }
        //
        let imgVa = UIImageView(image: UIImage(named: "home_ic_next"))
        imgVa.contentMode = .scaleAspectFit
        exploreNowBtnBgView.addSubview(imgVa)
        imgVa.snp.makeConstraints {
            $0.width.height.equalTo(36/2)
            $0.right.equalTo(-26)
            $0.centerY.equalToSuperview()
        }
        //
        let btn = UIButton(type: .custom)
        exploreNowBtnBgView.addSubview(btn)
        btn.addTarget(self, action: #selector(codeScanBtnClick(sender:)), for: .touchUpInside)
        btn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
}

extension HOmeView {
    
    @objc func exploreNowBtnClick(sender: UIButton) {
        exploreNowBtnBlock?()
    }
    @objc func gotoCreatorBtnClick(sender: UIButton) {
        gotoCreatorBtnBlock?()
    }
    @objc func codeScanBtnClick(sender: UIButton) {
        codeScanBtnBlock?()
    }
}
