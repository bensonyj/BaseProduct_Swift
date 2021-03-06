//
//  AppDelegate.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/15.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    weak var observe : NSObjectProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 键盘遮挡
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        // 网络监听
        NetWorkTools.instance.startMonitoringNet()
        
        
        // 初始化
        window = {
            let window = UIWindow()
            
            if LoginManager.sharedInstance.logined {
                let nvc = BaseNavigationViewController(rootViewController: OrderListViewController())
                window.rootViewController = nvc
            }else {
                let nvc = BaseNavigationViewController(rootViewController: LoginViewController())
                window.rootViewController = nvc
            }

            window.makeKeyAndVisible()
            return window
        }()
        
        sleep(2)
        observe = NotificationCenter.default.addObserver(forName: Notification.Name.init(rawValue: TokenTimeOut), object: nil, queue: nil) { (Notification) in
            // 用户退出
            LoginManager.sharedInstance.clean()
            
            let nvc = BaseNavigationViewController(rootViewController: LoginViewController())
            self.window?.rootViewController = nvc
            print("-------------",Thread.current)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    deinit {
        NotificationCenter.default.removeObserver(observe!)
    }
}

