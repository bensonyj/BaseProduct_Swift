//
//  BaseViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/16.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = color_C
        
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: nil, style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationController?.navigationBar.shadowImage = UIImage.init()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:color_G,NSFontAttributeName:UIFont.systemFont(ofSize: 17)]
        
        if (navigationController?.viewControllers.count)! > 1 {
            setupCustomBackBarButton(imageName: "back_d")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var disposeBag = DisposeBag()

    func setupCustomBackBarButton(imageName: String) {
        let image = UIImage.init(named: imageName)
        
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect.init(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(backBarButtonItemClick), for: .touchUpInside)
        
        let backBarItem = UIBarButtonItem.init(customView: backButton)
        
//        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        negativeSpacer.width = -5
//        
//        self.navigationItem.leftBarButtonItems = [negativeSpacer, backBarItem]
        self.navigationItem.leftBarButtonItem = backBarItem
    }
    
    func addLeftNavigationButton(button: UIButton) {
        let barItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func addRightNavigationButton(button: UIButton) {
        let barItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func createBarButtonItemImageButton(imageName: String) -> UIButton {
        let button = UIButton.init(type: .custom)
        let image = UIImage.init(named: imageName)!
        button.frame = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor.clear
        
        return button
    }
    
    func createBarButtonItemTitleButton(title: String) -> UIButton {
        let button = UIButton.init(type: .custom)
        let font = UIFont.systemFont(ofSize: 14)
        let size = title.textSizeWithFont(font: font, constrainedToSize: CGSize.zero)
        button.frame = CGRect.init(x: 0, y: 0, width: size.width > 44 ? size.width : 44, height: 44)
        button.setTitle(title, for: .normal)
        button.setTitleColor(color_G, for: .normal)
        button.titleLabel?.font = font
        
        return button
    }
    
    func backBarButtonItemClick() {
        if navigationController!.viewControllers.count > 1 {
           _ = navigationController?.popViewController(animated: true)
        }
    }
}
