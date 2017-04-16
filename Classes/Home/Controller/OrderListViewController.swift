//
//  OrderListViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/17.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class OrderListViewController: BaseTableViewController, OrderHeaderViewDelegate, OrderFooterViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "xxxx"

        if LoginManager.sharedInstance.logined {
            setup()
            NotificationCenter.default.addObserver(self, selector: #selector(orderListRefresh), name: NSNotification.Name(rawValue: RefreshOrderList), object: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let headerViewIdentifier = "headerViewIdentifier"
    let footerViewIdentifier = "footerViewIdentifier"
    
    func setup() {
        let leftButton = self.createBarButtonItemImageButton(imageName: "home_scan")
        leftButton.rx.tap.subscribe(onNext: {[weak self] in
            let _ = self?.navigationController?.pushViewController(ScanViewController(), animated: true)
        }).disposed(by: disposeBag)

        let rightButton = self.createBarButtonItemImageButton(imageName: "home_mine")
        rightButton.rx.tap.subscribe(onNext: {[weak self] in
            let _ = self?.navigationController?.pushViewController(MineTableViewController(), animated: true)
        }).disposed(by: disposeBag)
        
        self.addLeftNavigationButton(button: leftButton)
        self.addRightNavigationButton(button: rightButton)
        
        self.cellIdentifier = "orderProductCellIdentifier"
        self.tableView.separatorStyle = .none
        self.tableView.register(OrderProductCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.register(OrderHeaderView.self, forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.tableView.register(OrderFooterView.self, forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.tableView.rowHeight = 80
        self.tableView.sectionFooterHeight = 36 + 10
        
        self.configureRefreshHeader(scrollView: self.tableView)
        self.refreshData()
    }
    
    func orderListRefresh() {
        self.type = .refreshType_PullDown
        self.dataList.removeAll()
        self.refreshData()
    }
    
    override func tableStyle() -> UITableViewStyle {
        return .grouped
    }
        
    override func refreshData() {
        super.refreshData()
        self.showHUD(text: nil)
        NetWorkTools.httpGet(url: ApiUrl.orderURL, parameters: ["token":LoginManager.sharedInstance.token, "pageNum":self.startPage, "pageSize": self.perPageCount], successCallback: { [weak self] (netmodel: NetModel) in
            self?.hideHUD()

            if self?.type == RefreshType.refreshType_PullDown {
                self?.dataList.removeAll()
            }
            let data = netmodel.data as! Dictionary<String, Any>
            let orders = data["orders"]
            let list = Mapper<OrderModel>().mapArray(JSONObject: orders)
            
            if list != nil {
                self?.dataList += list! as Array<Any>
            }

            self?.totalCount = data["total_count"] as! Int

            self?.tableView.reloadData()
            self?.endDataRefresh()
            }, failureCallback: { (error_msg) in
                self.hideHUD()
                self.endDataRefresh()
                self.showTipsHUD(text: error_msg as! String)
        })
    }
}

extension OrderListViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let order = self.dataList[section] as! OrderModel
        return order.items!.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: OrderHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as! OrderHeaderView
        view.order = self.dataList[section] as? OrderModel
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as! OrderFooterView
        view.order = self.dataList[section] as? OrderModel
        view.delegate = self
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderProductCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! OrderProductCell
        
        let order = self.dataList[indexPath.section] as? OrderModel
        cell.product = order?.items?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

extension OrderListViewController {
    func headerViewClicked(order: OrderModel) {

    }
    
    func footerViewClicked(order: OrderModel) {
        
    }
}
