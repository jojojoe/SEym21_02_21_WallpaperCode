//
//  SEttingView.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/10.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit
import DeviceKit


let AppName: String = "Glister"
let purchaseUrl = ""
let TermsofuseURLStr = "http://violet-amount.surge.sh/Terms_of_use.html"
let PrivacyPolicyURLStr = "http://doubtful-relation.surge.sh/Facial_Privacy_Policy.html"

let feedbackEmail: String = "adriaveans@protonmail.ch"
let AppAppStoreID: String = ""



class SEttingView: UIView {
    var upVC: UIViewController?
    
    let loginBtn = UIButton(type: .custom)
    let userNameLabel = UILabel()
    let feedbackBtn = SettingContentBtn(frame: .zero, name: "Feedback", iconImage: UIImage(named: "setting_ic_feedback")!)
    let privacyLinkBtn = SettingContentBtn(frame: .zero, name: "Privacy Policy", iconImage: UIImage(named: "setting_ic_privacy")!)
    let termsBtn = SettingContentBtn(frame: .zero, name: "Terms of use", iconImage: UIImage(named: "setting_ic_term")!)
    let logoutBtn = SettingContentBtn(frame: .zero, name: "Log out", iconImage: UIImage(named: "setting_ic_log")!)
    let userIconImgV = UIImageView(image: UIImage(named: "setting_profile"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
         
        setupView()
        setupContentView()
        updateUserAccountStatus()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension SEttingView {
    func setupView() {
        backgroundColor = UIColor(hexString: "#100F14")
        let bgImgV = UIImageView(image: UIImage(named: "setting_background"))
        bgImgV.contentMode = .scaleAspectFill
        addSubview(bgImgV)
        
        bgImgV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * (1792/828))
        }
        //
        let settingLabel = UILabel()
        settingLabel.font = UIFont(name: "Avenir-Black", size: 22)
        settingLabel.textColor = .white
        settingLabel.text = "Setting"
        addSubview(settingLabel)
        settingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(18)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        userIconImgV.contentMode = .scaleAspectFit
        addSubview(userIconImgV)
        if Device.current.diagonal == 4.7 || Device.current.diagonal > 7 {
            userIconImgV.snp.makeConstraints {
                $0.width.height.equalTo(74)
                $0.left.equalTo(45)
                $0.top.equalTo(settingLabel.snp.bottom).offset(15)
            }
        } else {
            userIconImgV.snp.makeConstraints {
                $0.width.height.equalTo(74)
                $0.left.equalTo(45)
                $0.top.equalTo(settingLabel.snp.bottom).offset(35)
            }
        }
        
        //
        userNameLabel.font = UIFont(name: "Avenir-Black", size: 26)
        userNameLabel.textColor = .white
        userNameLabel.textAlignment = .left
        userNameLabel.text = "Log in"
        addSubview(userNameLabel)
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.snp.makeConstraints {
            $0.left.equalTo(userIconImgV)
            $0.top.equalTo(userIconImgV.snp.bottom).offset(15)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        addSubview(loginBtn)
        loginBtn.setImage(UIImage(named: ""), for: .normal)
        loginBtn.snp.makeConstraints {
            $0.top.equalTo(userIconImgV.snp.top)
            $0.bottom.equalTo(userNameLabel.snp.bottom)
            $0.left.right.equalTo(userNameLabel)
        }
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        
        
    }
    //
    func setupContentView() {
        
        // feedback
        addSubview(feedbackBtn)
        feedbackBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.feedback()
        }
        
        if Device.current.diagonal == 4.7 || Device.current.diagonal > 7 {
            feedbackBtn.snp.makeConstraints {
                $0.width.equalTo(357)
                $0.height.equalTo(64)
                $0.top.equalTo(userNameLabel.snp.bottom).offset(27)
                $0.centerX.equalToSuperview()
            }
        } else {
            feedbackBtn.snp.makeConstraints {
                $0.width.equalTo(357)
                $0.height.equalTo(64)
                $0.top.equalTo(userNameLabel.snp.bottom).offset(37)
                $0.centerX.equalToSuperview()
            }
        }
        
        // privacy link
        addSubview(privacyLinkBtn)
        privacyLinkBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
        }
        privacyLinkBtn.snp.makeConstraints {
             
            $0.width.equalTo(357)
            $0.height.equalTo(64)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
        // terms
        
        addSubview(termsBtn)
        termsBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: TermsofuseURLStr)
        }
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(357)
            $0.height.equalTo(64)
            $0.top.equalTo(privacyLinkBtn.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
        // logout
        
        addSubview(logoutBtn)
        logoutBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            LoginManage.shared.logout()
            self.updateUserAccountStatus()
        }
        logoutBtn.snp.makeConstraints {
            
            $0.width.equalTo(357)
            $0.height.equalTo(64)
            $0.top.equalTo(termsBtn.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
         
    }
    
    
}

extension SEttingView {
    
    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
        
    }
    
    func showLoginVC() {
        if LoginManage.currentLoginUser() == nil {
            let loginVC = LoginManage.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.upVC?.present(loginVC, animated: true) {
            }
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginManage.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : AppName
            logoutBtn.isHidden = false
            loginBtn.isUserInteractionEnabled = false
            
        } else {
            userNameLabel.text = "Login"
            logoutBtn.isHidden = true
            loginBtn.isUserInteractionEnabled = true
            
        }
    }
}

extension SEttingView: MFMailComposeViewControllerDelegate {
    func feedback() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            //获取系统版本号
            let systemVersion = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            
            let infoDic = Bundle.main.infoDictionary
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
            // 获取App的名称
            let appName = "\(AppName)"

            
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("\(appName) Feedback")
            //设置收件人
            // FIXME: feed back email
            controller.setToRecipients([feedbackEmail])
            //设置邮件正文内容（支持html）
         controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
            
            //打开界面
            self.upVC?.present(controller, animated: true, completion: nil)
        }else{
            HUD.error("The device doesn't support email")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
 }

class SettingContentBtn: UIButton {
    var clickBlock: (()->Void)?
    var nameTitle: String
    var iconImage: UIImage
    init(frame: CGRect, name: String, iconImage: UIImage) {
        self.nameTitle = name
        self.iconImage = iconImage
        super.init(frame: frame)
        setupView()
        addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
    }
    
    @objc func clickAction(sender: UIButton) {
        clickBlock?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
//        self.layer.cornerRadius = 17
//        self.layer.borderWidth = 4
//        self.layer.borderColor = UIColor.black.cgColor
        //
        let iconImgV = UIImageView(image: iconImage)
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(24)
        }
        //
        func makeLabel() -> UILabel {
            let label = UILabel()
            label.font = UIFont(name: "Avenir-Black", size: 20)
            label.textColor = UIColor(hexString: "#FFFFFF")
            label.text = nameTitle
            label.textAlignment = .center
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.backgroundColor = .clear
            return label
        }
        var label = UILabel()
        label = makeLabel()
        addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconImgV.snp.right).offset(20)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        let arrowImgV = UIImageView(image: UIImage(named: "setting_ic_next"))
        addSubview(arrowImgV)
        arrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-26)
            $0.width.equalTo(10)
            $0.height.equalTo(18)
        }
        
    }
    
}
