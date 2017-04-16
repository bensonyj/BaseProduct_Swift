//
//  UserModel.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/17.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: Mappable {
    var phone: String = ""
    var userId: Int?
    var userName: String?
    var add_time: Int64?
    var fid: Int?
    var name: String?
    var contact_number: String?
    var address: String?

    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        phone <- map["phone"]
        userId <- map["id"]
        userName <- map["user_name"]
        add_time <- map["add_time"]
        fid <- map["fid"]
        name <- map["name"]
        contact_number <- map["contact_number"]
        address <- map["address"]
    }
}
