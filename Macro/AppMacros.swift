//
//  AppMacros.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/16.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import ObjectMapper

let publish = 1

var kApiUrl: String {
    if publish == 1{
        // 正式环境
        return "https://www.xxx.com/xxx/"
    }else{
        // 测试环境
        return "http://127.0.0.1:8080/xxx/"
    }
}

let NQP_PHONE = "400-xxxxxx"

// 通知
let RefreshOrderList = "refreshOrderList"
let TokenTimeOut = "tokenTimeOut"
