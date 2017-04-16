//
//  MineTableViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by 应剑 on 2017/2/22.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import RxSwift

class MineTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "个人中心"
        self.cellIdentifier = "userCellIdentifier"
        
        setup()        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 获取用户数据
        if LoginManager.sharedInstance.logined {
            LoginManager.sharedInstance.getUserInfo(finishBlock: { (error) in
                if error.isEmpty {
                    self.tableView.reloadData()
                }else{
                    self.showTipsHUD(text: error)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        self.tableView.estimatedRowHeight = 45
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = color_D
        
        self.dataList = [["用户名","汽修厂","地址","注册时间"],["修改密码"]]
        
        let bottomView = UIView.init()
        bottomView.backgroundColor = self.tableView.backgroundColor
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.height.equalTo(110)
        }
        
        bottomView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(15)
            make.right.equalTo(bottomView).offset(-15)
            make.bottom.equalTo(bottomView).offset(-20)
            make.height.equalTo(38)
        }
        
        bottomView.addSubview(serviceTelLabel)
        serviceTelLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottomView)
            make.bottom.equalTo(logoutButton.snp.top).offset(-34)
        }
        
        self.tableView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-110)
        }
        
        // 监听 user

        
        // tap
        logoutButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.showHUD(text: nil)
            LoginManager.sharedInstance.loginOut(finishBlock: { [weak self] (error) in
                self?.hideHUD()
                if error.isEmpty {
                    UIApplication.shared.keyWindow?.rootViewController = BaseNavigationViewController(rootViewController: LoginViewController())
//                    self?.present(LoginViewController(), animated: true, completion: { 
//                        let _ = self?.navigationController?.popToRootViewController(animated: true)
//                    })
                }else{
                    self?.showTipsHUD(text: error)
                }
            })
            
        }).disposed(by: disposeBag)
        
    }

    override func tableStyle() -> UITableViewStyle {
        return .grouped
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataList[section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: self.cellIdentifier)
            if indexPath.section == 0 {
                cell?.accessoryView = UIImageView.init()
                cell?.selectionStyle = .none
            }else {
                cell?.accessoryView = UIImageView.init(image: UIImage.init(named: "my_arrow_r"))
                cell?.selectionStyle = .default
            }
            cell?.textLabel?.textColor = color_E
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.textColor = color_G
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.numberOfLines = 0
        }
        
        let tempArray = self.dataList[indexPath.section] as! [AnyObject]
        cell?.textLabel?.text = tempArray[indexPath.row] as? String
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell?.detailTextLabel?.text = LoginManager.sharedInstance.user?.userName
            case 1:
                cell?.detailTextLabel?.text = LoginManager.sharedInstance.user?.name
            case 2:
                cell?.detailTextLabel?.text = LoginManager.sharedInstance.user?.address
            case 3:
                cell?.detailTextLabel?.text = Date.getStringWithTimeStamp(timeStamp: LoginManager.sharedInstance.user?.add_time, format: "yyyy-MM-dd")
            default:
                cell?.detailTextLabel?.text = nil
            }
        default:
            cell?.detailTextLabel?.text = nil
        }
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            self.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
        }
    }
    
    lazy var logoutButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_NQ1), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_NQ2), for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_D), for: .disabled)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2
        button.setTitle("退出登录", for: .normal)
        button.setTitleColor(color_A, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        return button
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
