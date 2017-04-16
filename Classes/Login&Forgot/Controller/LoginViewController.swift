//
//  LoginViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/17.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseHUDViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "登录"
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func setup(){
        self.view.addSubview(phoneTextFieldInsetView)
        phoneTextFieldInsetView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(passwordTextFieldInsetView)
        
        passwordTextFieldInsetView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(phoneTextFieldInsetView.snp.bottom).offset(1)
            make.height.equalTo(44)
        }
        
        view.addSubview(forgotButton)
        forgotButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.top.equalTo(passwordTextFieldInsetView.snp.bottom).offset(11)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.top.equalTo(forgotButton.snp.bottom).offset(25)
            make.height.equalTo(38)
        }
        
        view.addSubview(serviceTelLabel)
        serviceTelLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-93)
        }
        
        // 监听login button
        Observable.combineLatest(phoneTextFieldInsetView.textField.rx.text.orEmpty, passwordTextFieldInsetView.textField.rx.text.orEmpty) { tel,pwd -> Bool in
                return (tel.characters.count > 0 && pwd.characters.count > 0)
        }
            .shareReplay(1)
            .bindTo(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // button tap
        forgotButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.view.endEditing(true)
            self?.navigationController?.pushViewController(ForgotPasswordOneStepViewController(), animated: true)
        }).disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            
            if !((self?.phoneTextFieldInsetView.textField.text?.isTelephone())!) {
                self?.showTipsHUD(text: "请输入正确的手机号码")
                return
            }
            
            if (self?.passwordTextFieldInsetView.textField.text?.characters.count)! < 6 {
                self?.showTipsHUD(text: "密码需要至少6位字符")
                return
            }

            if (self?.passwordTextFieldInsetView.textField.text?.characters.count)! > 20 {
                self?.showTipsHUD(text: "密码不能超过20位字符")
                return
            }
            
            self?.showHUD(text: nil)
            LoginManager.sharedInstance.login(mobile: self!.phoneTextFieldInsetView.textField.text!, pwd: self!.passwordTextFieldInsetView.textField.text!, finishBlock: { [weak self] (error) in
                self?.hideHUD()
                if error.isEmpty {
                    let nvc = BaseNavigationViewController(rootViewController: OrderListViewController())
                    UIApplication.shared.keyWindow?.rootViewController = nvc
                }else{
                    self?.showTipsHUD(text: error)
                }
            })
            
        }).disposed(by: disposeBag)
    }
    
    lazy var phoneTextFieldInsetView: TextFieldInsetView = {
       let phoneTextFieldInsetView = TextFieldInsetView.init(placeholder: "输入手机号", leftImageName: "home_tab_my")
        phoneTextFieldInsetView.textField.keyboardType = UIKeyboardType.numberPad
        
        return phoneTextFieldInsetView
    }()
    
    lazy var passwordTextFieldInsetView: TextFieldInsetView = {
        let passwordTextFieldInsetView = TextFieldInsetView.init(placeholder: "输入密码", leftImageName: "password2")
        passwordTextFieldInsetView.textField.isSecureTextEntry = true
        
        return passwordTextFieldInsetView
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton.init(type: .custom)
        loginButton.setBackgroundImage(UIImage.imageWithColor(color: color_NQ1), for: .normal)
        loginButton.setBackgroundImage(UIImage.imageWithColor(color: color_NQ2), for: .highlighted)
        loginButton.setBackgroundImage(UIImage.imageWithColor(color: color_D), for: .disabled)
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 2
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(color_A, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        return loginButton
    }()
    
    lazy var forgotButton: UIButton = {
        let forgotButton = UIButton.init(type: .custom)
        forgotButton.setTitle("忘记密码", for: .normal)
        forgotButton.setTitleColor(color_E, for: .normal)
        forgotButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return forgotButton
    }()
    
    lazy var serviceTelLabel: ActiveLabel = {
        let serviceTelLabel = ActiveLabel()
        let customType = ActiveType.custom(pattern: "\\s\(NQP_PHONE)\\b") //Looks for "NQP_PHONE"
        serviceTelLabel.enabledTypes = [customType]
        serviceTelLabel.customize { serviceTelLabel in
            serviceTelLabel.text = "客服电话： \(NQP_PHONE)  "

            serviceTelLabel.textColor = color_G
            serviceTelLabel.font = UIFont.systemFont(ofSize: 12)
            //Custom types
            
            serviceTelLabel.customColor[customType] = color_Y2
            serviceTelLabel.customSelectedColor[customType] = color_Y2
            
            serviceTelLabel.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSFontAttributeName] = isSelected ? UIFont.systemFont(ofSize: 12) : UIFont.systemFont(ofSize: 12)
                    atts[NSUnderlineStyleAttributeName] =  NSUnderlineStyle.styleSingle.rawValue
                    atts[NSUnderlineColorAttributeName] = color_Y2
                default: ()
                }
                
                return atts
            }
            
            serviceTelLabel.handleCustomTap(for: customType) {_ in
                self.alert(title: nil,message: NQP_PHONE,leftActionTitle: "取消",rightActionTitle: "拨打")
            }
        }

        return serviceTelLabel
    }()
    
    // alert
    func alert(title: String?, message: String?, leftActionTitle: String?, rightActionTitle: String?){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let leftAlertAction = UIAlertAction.init(title: leftActionTitle, style: UIAlertActionStyle.cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(leftAlertAction)
        
        let rightAlertAction = UIAlertAction.init(title: rightActionTitle, style: UIAlertActionStyle.default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            guard let url = URL.init(string: "tel:\(NQP_PHONE)") else{
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        alert.addAction(rightAlertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
