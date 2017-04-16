//
//  NetModel.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/17.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import ObjectMapper

class NetModel: Mappable {
    // 返回码
    var status: Int?
    // 返回请求描述
    var msg: String?
    // 返回数据(可对象、数组、字符串)
    var data: Any?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}
