//
//  OrderModel.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/24.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderModel: Mappable {
    var order_id: Int?
    var order_no: String?
    var price: Double?
    var deliver_fee: Double?
    var pay_price: Double?
    var pay_price_string: String {
        return String.init(format: "%.2f", pay_price!)
    }

    var discount: Double?
    var status: Int?
    var statusString: String {
        switch status! {
        case 0:
            return "待付款"
        case 1:
            return "待发货"
        case 2:
            return "已发货"
        case 3:
            return "待安装"
        case 10:
            return "已完成"
        case 11:
            return "已取消"
        case 99:
            return "已删除"
        default:
            return "已取消"
        }
    }

    var statusStringColor: UIColor {
        switch status! {
        case 0:
            return color_G
        case 1:
            return color_G
        case 2:
            return color_G
        case 3:
            return color_NQ1
        case 10:
            return color_E
        case 11:
            return color_E
        case 99:
            return color_E
        default:
            return color_E
        }
    }

    var uid: Int?
    var fid: Int?
    var phone: String?
    var pay_time: Int64?
    var deliver_time: Int64?
    var finish_time: Int64?

    
    var add_time: Int64?
    var invoice_title: String?
    var user_remark: String?

    var items: [ProductModel]?
    var total_num: Int {
        var num = 0
        for product in items! {
            num += product.number!
        }
        return num
    }
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        order_id <- map["id"]
        order_no <- map["order_no"]
        price <- map["price"]
        deliver_fee <- map["deliver_fee"]
        pay_price <- map["pay_price"]
        discount <- map["discount"]
        status <- map["status"]
        add_time <- map["add_time"]
        invoice_title <- map["invoice_title"]
        items <- map["items"]
        
        user_remark <- map["user_remark"]
        uid <- map["uid"]
        fid <- map["fid"]
        phone <- map["phone"]
        pay_time <- map["pay_time"]
        deliver_time <- map["deliver_time"]
        finish_time <- map["finish_time"]
    }
}
