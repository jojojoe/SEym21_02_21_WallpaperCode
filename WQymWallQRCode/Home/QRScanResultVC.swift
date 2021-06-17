//
//  QRScanResultVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/16.
//

import UIKit
import DeviceKit

class QRScanResultVC: UIViewController {

    var codeResult: LBXScanResult?
    
    
    let contentTextView: UITextView = UITextView()
    let homeBtn = UIButton(type: .custom)
    let backBtn = UIButton(type: .custom)
    let bgCanvasView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
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
        bgCanvasView.backgroundColor = .clear
        bgCanvasView.layer.borderWidth = 1
        bgCanvasView.layer.borderColor = UIColor.white.cgColor
        view.addSubview(bgCanvasView)
        
        var bgCanvasWidth: CGFloat = 372
        if Device.current.diagonal == 4.7 || Device.current.diagonal > 7 {
            bgCanvasWidth = 342
        }
        
        bgCanvasView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(bgCanvasWidth)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-240)
        }
    
        //
        bgCanvasView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.center.equalTo(bgCanvasView)
            $0.left.top.equalTo(6)
        }
        contentTextView.textAlignment = .center
        contentTextView.font = UIFont(name: "Avenir-Black", size: 22)
        contentTextView.isEditable = false
        contentTextView.text = codeResult?.strScanned
        
        
        //
        let bgBottomView = UIView()
        bgBottomView.backgroundColor = .clear
        view.addSubview(bgBottomView)
        bgBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(bgCanvasView.snp.bottom)
        }
        //
        bgBottomView.addSubview(homeBtn)
        homeBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(354)
            $0.height.equalTo(69)
            $0.centerX.equalToSuperview()
        }
        homeBtn.addTarget(self, action: #selector(homeBtnClick(sender:)), for: .touchUpInside)
        homeBtn.setTitle("Home", for: .normal)
        homeBtn.setTitleColor(.white, for: .normal)
        homeBtn.setBackgroundImage(UIImage(named: "edit_button"), for: .normal)
        homeBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
    }

     
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func homeBtnClick(sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
