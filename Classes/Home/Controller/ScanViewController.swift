//
//  ScanViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/24.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import ObjectMapper

class ScanViewController: BaseHUDViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "扫码"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var scanObj: LBXScanWrapper?
    
    lazy var scanStyle: LBXScanViewStyle = {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        style.photoframeLineW = 6
        style.photoframeAngleW = 24
        style.photoframeAngleH = 24
        style.isNeedShowRetangle = true
        
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid
        
        
        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net");

        return style
    }()
    
    var qRScanView: LBXScanView?
    
    //启动区域识别功能
    var isOpenInterestRect = false
    
    //识别码的类型
    var arrayCodeType:[String]?
    
    //是否需要识别后的当前图像
    var isNeedCodeImage = false

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        drawScanView()
        
        perform(#selector(LBXScanViewController.startScan), with: nil, afterDelay: 0.3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        qRScanView?.stopScanAnimation()
        
        scanObj?.stop()
    }

    func setNeedCodeImage(needCodeImg:Bool)
    {
        isNeedCodeImage = needCodeImg;
    }
    
    //设置框内识别
    func setOpenInterestRect(isOpen:Bool){
        isOpenInterestRect = isOpen
    }
    
    func startScan()
    {
        if(!LBXPermissions .isGetCameraPermission())
        {
            showMsg(title: "提示", message: "没有相机权限，请到设置->隐私->相机中开启本程序相机权限", isCameraPermission: true)
            return;
        }
        
        if (scanObj == nil)
        {
            var cropRect = CGRect.zero
            if isOpenInterestRect
            {
                cropRect = LBXScanView.getScanRectWithPreView(preView: self.view, style:scanStyle)
            }
            
            //识别各种码，
            //let arrayCode = LBXScanWrapper.defaultMetaDataObjectTypes()
            
            //指定识别几种码
            if arrayCodeType == nil
            {
                arrayCodeType = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code]
            }
            
            scanObj = LBXScanWrapper(videoPreView: self.view,objType:arrayCodeType!, isCaptureImg: isNeedCodeImage,cropRect:cropRect, success: { [weak self] (arrayResult) -> Void in
                
                if let strongSelf = self
                {
                    //停止扫描动画
                    strongSelf.qRScanView?.stopScanAnimation()
                    
                    strongSelf.handleCodeResult(arrayResult: arrayResult)
                }
            })
        }
        
        //结束相机等待提示
        qRScanView?.deviceStopReadying()
        
        //开始扫描动画
        qRScanView?.startScanAnimation()
        
        //相机运行
        scanObj?.start()
    }
    
    func drawScanView()
    {
        if qRScanView == nil
        {
            qRScanView = LBXScanView(frame: self.view.frame,vstyle:scanStyle)
            self.view.addSubview(qRScanView!)
        }
        qRScanView?.deviceStartReadying(readyStr: "相机启动中...")
    }
    
    
    /**
     处理扫码结果，如果是继承本控制器的，可以重写该方法,作出相应地处理
     */
    func handleCodeResult(arrayResult:[LBXScanResult])
    {
        for result:LBXScanResult in arrayResult
        {
            print("%@",result.strScanned ?? "scan_failure")
        }
        
        let result:LBXScanResult = arrayResult[0]
        
        print("codeType:\(result.strBarCodeType!),message:\(result.strScanned!)")
        
        guard let message = result.strScanned else {
            return
        }
        
        if message.hasPrefix("tt://"){
            // request 
            self.showHUD(text: nil)
            let order_no =  message.substring(from: "tt://orderNo=".endIndex)
            NetWorkTools.httpGet(url: ApiUrl.orderURL, parameters: ["token":LoginManager.sharedInstance.token, "orderNo":order_no], successCallback: { [weak self] (netmodel: NetModel) in
                self?.hideHUD()
                let data = netmodel.data as! Dictionary<String, Any>
                _ = Mapper<OrderModel>().map(JSONObject: data)
                
//                let vc = OrderDetailViewController()
//                vc.order = order
//                vc.isCanCancel = true
//                
//                let firstVC = self?.navigationController?.viewControllers.removeFirst()
//                self?.navigationController?.setViewControllers([firstVC!,vc], animated: true)
                
                }, failureCallback: { (error_msg) in
                    self.hideHUD()
                    self.showTipsHUD(text: error_msg as! String)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        self.startScan()
                    }
            })

        }else {
            showMsg(title: "提示", message: "二维码不符合", isCameraPermission: false)
        }
        
//        showMsg(title: result.strBarCodeType, message: result.strScanned)
    }
    
    
    func showMsg(title:String?,message:String?, isCameraPermission: Bool)
    {
        if LBXScanWrapper.isSysIos8Later()
        {
            
            //if #available(iOS 8.0, *)
            
            let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
            
            if isCameraPermission == true {
                let alertAction = UIAlertAction(title:  "去设置", style: UIAlertActionStyle.default) { (alertAction) in
                    
                    let url = URL.init(string: UIApplicationOpenSettingsURLString)
                    if  UIApplication.shared.canOpenURL((url ?? URL.init(string: "")!)) == true {
                        UIApplication.shared.openURL(url!)
                    }
                }
                
                alertController.addAction(alertAction)
            }else {
                let alertAction = UIAlertAction(title:  "重新扫描", style: UIAlertActionStyle.default) { [weak self] (alertAction) in
                    if let strongSelf = self
                    {
                        strongSelf.startScan()
                    }
                }
                
                alertController.addAction(alertAction)
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (UIAlertAction) in
                
            })
            
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
        }
    }
    deinit
    {
        print("LBXScanViewController deinit")
    }

}
