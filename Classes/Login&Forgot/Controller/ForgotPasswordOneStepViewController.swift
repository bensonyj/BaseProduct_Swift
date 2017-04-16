//
//  ForgotPasswordOneStepViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by 应剑 on 2017/2/21.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordOneStepViewController: BaseHUDViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "忘记密码"
        
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
            make.top.equalTo(self.view).offset(5)
            make.height.equalTo(44)
        }

        let viewA = UIView.init()
        viewA.backgroundColor = color_A
        self.view.addSubview(viewA)
        viewA.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(phoneTextFieldInsetView.snp.bottom).offset(1)
            make.height.equalTo(44)
        }
        
        viewA.addSubview(codeTextField)
        viewA.addSubview(codeButton)
        codeButton.snp.makeConstraints { (make) in
            make.right.equalTo(viewA).offset(-15)
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.centerY.equalTo(viewA.snp.centerY)
        }
        
        codeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(viewA).offset(15)
            make.top.equalTo(viewA).offset(0)
            make.bottom.equalTo(viewA).offset(0)
            make.right.equalTo(codeButton.snp.left).offset(-15)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.top.equalTo(viewA.snp.bottom).offset(20)
            make.height.equalTo(38)
        }

        // 监听
        phoneTextFieldInsetView.textField.rx.text.orEmpty.map({ value -> Bool in
           return (value.characters.count > 0 && self.codeButton.isUserInteractionEnabled)
        }).shareReplay(1)
        .bindTo(codeButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(phoneTextFieldInsetView.textField.rx.text.orEmpty, codeTextField.rx.text.orEmpty) { tel,code -> Bool in
            return (tel.characters.count > 0 && code.characters.count > 0)
            }
            .shareReplay(1)
            .bindTo(submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // button tap
        codeButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.view.endEditing(true)
            
            if !((self?.phoneTextFieldInsetView.textField.text?.isTelephone())!) {
                self?.showTipsHUD(text: "请输入正确的手机号码")
                return
            }
            // request code
            self?.showHUD(text: nil)
            NetWorkTools.httpPost(url: ApiUrl.verifycodeURL, parameters: ["mobileNo":self!.phoneTextFieldInsetView.textField.text!,"type":2], successCallback: { [weak self] (netmodel) in
                self?.hideHUD()
                self?.codeButton.startTime(timeout: 59, title: "重新发送", waitTitle: "已发送")
            }, failureCallback: { (error_msg) in
                self?.hideHUD()
                self?.showTipsHUD(text: error_msg as! String)
            })
        }).disposed(by: disposeBag)
        
        submitButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.view.endEditing(true)
            
            if !((self?.phoneTextFieldInsetView.textField.text?.isTelephone())!) {
                self?.showTipsHUD(text: "请输入正确的手机号码")
                return
            }
            
            // request code
            self?.showHUD(text: nil)
            NetWorkTools.httpPost(url: ApiUrl.forgetPwdURL, parameters: ["mobileNo":self!.phoneTextFieldInsetView.textField.text!,"verifyCode":self!.codeTextField.text!], successCallback: { [weak self] (netmodel) in
                self?.hideHUD()
                let vc = ForgotPasswordTwoStepViewController()
                vc.phone = self!.phoneTextFieldInsetView.textField.text!
                self?.navigationController?.pushViewController(vc, animated: true)
                }, failureCallback: { (error_msg) in
                    self?.hideHUD()
                    self?.showTipsHUD(text: error_msg as! String)
            })
        }).disposed(by: disposeBag)

    }

    lazy var phoneTextFieldInsetView: TextFieldInsetView = {
        let phoneTextFieldInsetView = TextFieldInsetView.init(placeholder: "输入手机号", leftImageName: "home_tab_my")
        phoneTextFieldInsetView.textField.keyboardType = UIKeyboardType.numberPad
        
        return phoneTextFieldInsetView
    }()

    lazy var codeTextField: UITextField = {
        let textField = UITextField.init()
        textField.textColor = color_F
        textField.placeholder = "输入验证码"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.keyboardType = UIKeyboardType.numberPad
        textField.leftView = TextFieldInsetView.setupTextFieldLeftView(imageName:"password")
        textField.leftViewMode = .always
        
        return textField
    }()
    
    lazy var codeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_NQ1), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_NQ2), for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_D), for: .disabled)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2
        button.setTitle("发送验证码", for: .normal)
        button.setTitleColor(color_A, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return button
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_NQ1), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_NQ2), for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_D), for: .disabled)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2
        button.setTitle("提交", for: .normal)
        button.setTitleColor(color_A, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        return button
    }() 
}
