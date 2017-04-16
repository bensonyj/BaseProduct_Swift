//
//  UIButtonExtension.swift
//  CattleSteamerHousekeeper
//
//  Created by 应剑 on 2017/2/23.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func startTime(timeout: Int, title: String, waitTitle: String) {
        
        var timeOut = timeout
        //倒计时代码
        var queue: DispatchQueue?
        var timer: DispatchSourceTimer?
        
        queue = DispatchQueue.global(qos: .default)
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.scheduleRepeating(deadline: DispatchTime.now(), interval: (1.0), leeway: DispatchTimeInterval.milliseconds(10))
        timer?.setEventHandler(handler: {
            [weak self]
            () -> Void in
            if timeOut <= 0 {
                timer!.cancel();
                DispatchQueue.main.async(execute: {
                    self?.setTitle(title, for: .normal)
                    self?.isUserInteractionEnabled = true
                    self?.isEnabled = true
                })
            } else {
                let seconds = timeOut % 60
                DispatchQueue.main.async(execute: {
                    self?.setTitle("\(waitTitle) \(seconds)", for: .normal)
                    self?.isUserInteractionEnabled = false
                    self?.isEnabled = false
                })
                timeOut -= 1;
            }
        })
        timer?.resume()
    }
}
