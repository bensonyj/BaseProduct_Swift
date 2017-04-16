//
//  NetWorkTools.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/16.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum NetType {
    case NONet
    case WiFiNet
    case WwanNet
}

struct NetInfo {
    var type: NetType
    var netTypeString: String
}

class NetWorkTools {
    static let instance: NetWorkTools = NetWorkTools()
    var netInfo = NetInfo(type: .WiFiNet, netTypeString: "WIFI")
    
    
    func shareManager() -> NetWorkTools {
        return .instance
    }
    
    func startMonitoringNet() {
        var manager: NetworkReachabilityManager?
        manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            switch status {
            case .notReachable:
                self.netInfo.type = .NONet
                self.netInfo.netTypeString = "网络已断开"
            case .unknown:
                self.netInfo.type = .NONet
                self.netInfo.netTypeString = "其他情况"
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                self.netInfo.type = .WwanNet
                self.netInfo.netTypeString = "2G/3G/4G"
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                self.netInfo.type = .WiFiNet
                self.netInfo.netTypeString = "WIFI"
            }

            print("Network Status Changed: \(status)")
        }
        manager?.startListening()
    }
    
    static let alamofireManager = httpManager()
    static func httpManager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        return Alamofire.SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: nil)
    }
    
    
    // get
    static func httpGet(url: String, parameters: [String : Any]? = nil, successCallback: @escaping (_ result : NetModel) -> (), failureCallback: @escaping (_ result : Any) -> ()) {
        if NetWorkTools.instance.netInfo.type == .NONet {
            failureCallback("您的网络不给力，请重试！")
            return
        }
        
        var urlString = url
        if urlString != ApiUrl.forgetUpdatePwdURL {
            urlString = kApiUrl + urlString
        }
        print("url:\(urlString),parameter:\(String(describing: parameters))")

        self.alamofireManager.request(urlString, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("url:\(urlString).get_success:\(value)")
                let json = Mapper<NetModel>().map(JSONObject: value)
                if json?.status == 0 {
                    successCallback(json!)
                }else {
                    failureCallback(json!.msg ?? "数据异常")
                    if json?.status == 3 {
                        // 登录超时
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TokenTimeOut), object: nil)
                    }
                }
            case .failure(let error):
                print("url:\(urlString).get_failure:\(error)")
                failureCallback(error.localizedDescription)
            }
        }
    }
    
    // post 
    static func httpPost(url: String, parameters: [String : Any]? = nil, successCallback: @escaping (_ result : NetModel) -> (), failureCallback: @escaping (_ result : Any) -> ()) {
        if NetWorkTools.instance.netInfo.type == .NONet {
            failureCallback("您的网络不给力，请重试！")
            return
        }
        
        var urlString = url
        if urlString != ApiUrl.forgetUpdatePwdURL {
            urlString = kApiUrl + urlString
        }
        print("url:\(urlString),parameter:\(String(describing: parameters))")
        
        self.alamofireManager.request(urlString, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("url:\(urlString).post_success:\(value)")

                let json = Mapper<NetModel>().map(JSONObject: value)
                if json?.status == 0 {
                    successCallback(json!)
                }else {
                    failureCallback(json!.msg ?? "数据异常")
                    if json?.status == 3 {
                        // 登录超时
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TokenTimeOut), object: nil)
                    }
                }
            case .failure(let error):
                print("url:\(urlString).post_failure:\(error)")
                failureCallback(error.localizedDescription)
            }
        }
    }
    
}

