//
//  SToreCOinVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/11.
//

import UIKit

class SToreCOinVC: UIViewController {

    let storeView = SToreView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "edit_ic_back"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        //
        storeView.upVC = self
        view.addSubview(storeView)
        storeView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
    
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
        self.navigationController?.popViewController()
        } else {
        self.dismiss(animated: true, completion: nil)
        }
    }

}
