//
//  ForgotPasswordTwoStepViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by 应剑 on 2017/2/21.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordTwoStepViewController: BaseHUDViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "忘记密码"
        
        setup()
    }
    
    var phone: String!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        self.view.addSubview(passwordTextFieldInsetView)
        passwordTextFieldInsetView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(5)
            make.height.equalTo(44)
        }
        
        self.view.addSubview(confirmPasswordTextFieldInsetView)
        confirmPasswordTextFieldInsetView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(passwordTextFieldInsetView.snp.bottom).offset(1)
            make.height.equalTo(44)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.top.equalTo(confirmPasswordTextFieldInsetView.snp.bottom).offset(20)
            make.height.equalTo(38)
        }
        
        
        Observable.combineLatest(passwordTextFieldInsetView.textField.rx.text.orEmpty, confirmPasswordTextFieldInsetView.textField.rx.text.orEmpty) { p1,p2 -> Bool in
            return (p1.characters.count > 0 && p2.characters.count > 0)
            }
            .shareReplay(1)
            .bindTo(submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // button tap
        submitButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.view.endEditing(true)
            
            guard let pwd = self?.passwordTextFieldInsetView.textField.text else {
                return
            }
            guard let conPwd = self?.confirmPasswordTextFieldInsetView.textField.text else {
                return
            }
            
            if !(pwd.regexPassword()) || !(conPwd.regexPassword()) {
                self?.showTipsHUD(text: "请输入正确的密码")
                return
            }
            if pwd.characters.count < 6 || conPwd.characters.count < 6 {
                self?.showTipsHUD(text: "密码需要至少6位字符")
                return
            }
            
            if pwd.characters.count > 20 || conPwd.characters.count > 20 {
                self?.showTipsHUD(text: "密码不能超过20位字符")
                return
            }
            if pwd != conPwd {
                self?.showTipsHUD(text: "两次密码输入不一致，请重试")
                return
            }
            
            self?.showHUD(text: nil)
            NetWorkTools.httpPost(url: ApiUrl.forgetUpdatePwdURL, parameters: ["phone":self!.phone,"newPassword":pwd.md5()], successCallback: { (netModel: NetModel) in
                self?.hideHUD()
                self?.showTipsHUD(text: netModel.msg!)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    _ = self?.navigationController?.popToRootViewController(animated: true)
                }
            }, failureCallback: { (msg) in
                self?.hideHUD()
                self?.showTipsHUD(text: msg as! String)
            })
        }).disposed(by: disposeBag)
    }

    lazy var passwordTextFieldInsetView: TextFieldInsetView = {
        let passwordTextFieldInsetView = TextFieldInsetView.init(placeholder: "输入密码", leftImageName: "password2")
        passwordTextFieldInsetView.textField.isSecureTextEntry = true
        
        return passwordTextFieldInsetView
    }()

    lazy var confirmPasswordTextFieldInsetView: TextFieldInsetView = {
        let confirmPasswordTextFieldInsetView = TextFieldInsetView.init(placeholder: "确认密码", leftImageName: "password2")
        confirmPasswordTextFieldInsetView.textField.isSecureTextEntry = true
        
        return confirmPasswordTextFieldInsetView
    }()

    lazy var submitButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_NQ1), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_NQ2), for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_D), for: .disabled)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2
        button.setTitle("完成", for: .normal)
        button.setTitleColor(color_A, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        return button
    }()
}
