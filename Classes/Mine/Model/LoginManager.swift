//
//  LoginManager.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/17.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import CryptoSwift
import ObjectMapper

let localDataKey = "loginData"

class LoginManager {
    static let sharedInstance : LoginManager = {
        let instance = LoginManager()
        return instance
    }()
    
    init() {
        let data = UserDefaults.standard.object(forKey: localDataKey)
        if let loginData: [String : Any] = data as! [String : Any]? {
            logined = true
            token = loginData["token"] as! String
            uid = loginData["uid"] as! String
            let userString = loginData["user"]!
            user = Mapper<UserModel>().map(JSONObject: userString)
        }
    }
    
    var logined = false
    var token = ""
    var uid = ""
    
    var user: UserModel?
    
    
    // login
    func login(mobile: String, pwd: String, finishBlock: @escaping (_ error_msg: String) -> Void){
        NetWorkTools.httpPost(url: ApiUrl.loginURL, parameters: ["mobileNo": mobile, "password": pwd.md5()], successCallback: { [weak self] (result: NetModel) in
            let data = result.data as! Dictionary<String, Any>
            self?.logined = true
            self?.token = data["access_token"] as! String
            
//            // 保存信息
//            self.saveUser()
            finishBlock("")
            
            // 获取用户数据
            self?.getUserInfo(finishBlock: { (msg) in
                print("getUserInfo:\(msg)")
            })
        }, failureCallback: { (msg) in
            finishBlock(msg as! String)
        })
    }
    
    // get user info
    func getUserInfo(finishBlock: @escaping (_ error_msg: String) -> Void){
        NetWorkTools.httpGet(url: ApiUrl.getUserInfoURL, parameters: ["token":self.token], successCallback: {  [weak self] (NetModel: NetModel) in
            let data = NetModel.data as! Dictionary<String, Any>
            self?.logined = true
            self?.user = Mapper<UserModel>().map(JSON: data)
            
            // 保存信息
            self?.saveUser()
            finishBlock("")
        }, failureCallback: { (msg) in
            finishBlock(msg as! String)
        })
    }
    
    // logout
    func loginOut(finishBlock: @escaping (_ error_msg: String) -> Void) {
        NetWorkTools.httpPost(url: ApiUrl.logoutURL, parameters: ["token": self.token], successCallback: { [weak self] (NetModel: NetModel) in
            self?.clean()
            finishBlock("")
        }, failureCallback: { (msg) in
            finishBlock(msg as! String)
        })
    }
    
    func saveUser() {
        // 保存信息到本地
        let data = ["token": token, "uid": uid, "user": user!.toJSON()] as [String : Any]
        UserDefaults.standard.set(data, forKey: localDataKey)
        UserDefaults.standard.synchronize()
    }
    
    func clean() {
        // 清楚用户信息
        if user != nil {
            logined = false
            token = ""
            uid = ""
            user = nil
            UserDefaults.standard.removeObject(forKey: localDataKey)
            UserDefaults.standard.synchronize()
        }
    }
}
