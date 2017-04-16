//
//  BaseHUDViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/16.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

/** 网络提示框的出现时机，若干秒后网络数据还未返回则出现提示框 */
enum NetworkRequestGraceTimeType {
    case NetworkRequestGraceTimeTypeNormal      // 0.5s
    case NetworkRequestGraceTimeTypeLong        // 1s
    case NetworkRequestGraceTimeTypeShort       // 0.1s
    case NetworkRequestGraceTimeTypeAlways      // 总是有提示框
}

class BaseHUDViewController: BaseViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var delayTime = 1.5
    var requestGraceTimeType: NetworkRequestGraceTimeType = .NetworkRequestGraceTimeTypeNormal
    
    func showHUD(text: String?) {
        var textString: String = text ?? "加载中..."
        
        let size = CGSize(width: 60, height:60)
        let type: NVActivityIndicatorType = .ballSpinFadeLoader
        let textFont = UIFont.systemFont(ofSize: 14.0)
        let padding: CGFloat = 10.0
        var displayTime: Int {
            switch requestGraceTimeType {
            case .NetworkRequestGraceTimeTypeNormal:
                return 1
            case .NetworkRequestGraceTimeTypeShort:
                return 1
            case .NetworkRequestGraceTimeTypeLong:
                return 2
            case .NetworkRequestGraceTimeTypeAlways:
                return 0
            }
        }
        let miniumDisplayTime = 1
        
        // show
        startAnimating(size, message: textString, messageFont: textFont, type: type, color: color_A, padding: padding, displayTimeThreshold: displayTime, minimumDisplayTime: miniumDisplayTime, backgroundColor: color_F_HUD, textColor: color_A)
    }
    
    func hideHUD(){
        self.stopAnimating()
    }
    
    func showTipsHUD(text: String) {
        if text.isEmpty {
            return
        }
        let size = CGSize(width: 60, height:60)
        let type: NVActivityIndicatorType = .blank
        let textFont = UIFont.systemFont(ofSize: 14.0)
        let padding: CGFloat = 10.0
        
        // show
        startAnimating(size, message: text, messageFont: textFont, type: type, color: color_A, padding: padding, backgroundColor: color_F_HUD, textColor: color_A)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime) {
            self.stopAnimating()
        }
    }
}
