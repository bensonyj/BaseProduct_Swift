//
//  ProductModel.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/24.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductModel: Mappable {
    var product_id: Int?
    var name: String?
    var sale_price: Double?
    var sale_price_string: String {
        return String.init(format: "%.2f", sale_price!)
    }
    var discount_price: Double?
    var discount_price_string: String {
        return String.init(format: "%.2f", discount_price!)
    }

    var img_src: String?
    var img_src_encoding: String {
        if img_src != nil {
            return img_src!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
        
        return ""
    }

    var number: Int?
    var item_id: Int?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        product_id <- map["product_id"]
        name <- map["name"]
        sale_price <- map["sale_price"]
        img_src <- map["img_src"]
        number <- map["num"]
        item_id <- map["item_id"]
        discount_price <- map["discount_price"]
    }
}
