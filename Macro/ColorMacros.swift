//
//  ColorMacros.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/16.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // MARK:- 遍历构造器
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    // MARK:- 随机色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}

// 定义全局颜色
let color_A = UIColor.init(r: 255, g: 255, b: 255)
let color_B = UIColor.init(r: 248, g: 248, b: 248)
let color_C = UIColor.init(r: 241, g: 241, b: 241)
let color_D = UIColor.init(r: 204, g: 204, b: 204)
let color_E = UIColor.init(r: 155, g: 155, b: 155)
let color_F = UIColor.init(r: 102, g: 102, b: 102)
let color_G = UIColor.init(r: 51, g: 51, b: 51)
let color_H = UIColor.init(r: 0, g: 0, b: 0)

let color_X = UIColor.init(r: 244, g: 83, b: 57)
let color_Y = UIColor.init(r: 208, g: 2, b: 27)
let color_Y2 = UIColor.init(r: 74, g: 144, b: 226)

let color_NQ1 = UIColor.init(r: 240, g: 48, b: 26)
let color_NQ2 = UIColor.init(r: 187, g: 30, b: 33)
let color_NQ3 = UIColor.init(r: 245, g: 143, b: 35)
let color_NQ4 = UIColor.init(r: 0, g: 153, b: 0)

let color_F_HUD = UIColor.init(r: 102, g: 102, b: 102, a: 0.8)

let color_Z = UIColor.clear
