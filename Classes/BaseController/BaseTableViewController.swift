//
//  BaseTableViewController.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/16.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import ESPullToRefresh

enum RefreshType {
    case refreshType_Normal
    case refreshType_PullDown   // 下来刷新
    case refreshType_PullUp     // 上拉加载
}

class BaseTableViewController: BaseHUDViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    var tableView: UITableView! = nil
    // 分页加载起始页
    var startPage = 1
    // 限制每次获取数据条数，默认为20
    var perPageCount = 20
    // 当前存在的数据量
    var existCount: Int {
        return self.dataList.count
    }
    // 数据总量
    var totalCount = 0 {
        didSet {
            if totalCount > existCount {
                self.configureRefreshFooter(scrollView: self.tableView)
            }else {
                self.noMoreData()
            }
        }
    }
    // 数据获取方式
    var type = RefreshType.refreshType_Normal
    // 数据
    var dataList = Array<Any>()
    // CellIdentifier
    var cellIdentifier = "CellIdentifier"
    
    // custom table
    func tableStyle() -> UITableViewStyle{
        return .plain
    }
    
    func setupUI(){
        tableView = UITableView.init(frame: self.view.bounds, style: tableStyle())
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }
        tableView.backgroundColor = self.view.backgroundColor
        tableView.backgroundView = nil
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // 监听
    }

    // 配置刷新
    func configureRefreshHeader(scrollView: UIScrollView) {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = RefreshHeaderAnimator.init(frame: CGRect.zero)
        scrollView.es_addPullToRefresh(animator: header) { [weak self] in
            self?.type = .refreshType_PullDown
//            self?.dataList.removeAll()
            self?.refreshData()
        }
    }
    
    // 配置加载更多
    func configureRefreshFooter(scrollView: UIScrollView) {
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        footer = RefreshFooterAnimator.init(frame: CGRect.zero)
        scrollView.es_addInfiniteScrolling(animator: footer) { [weak self] in
            self?.type = .refreshType_PullUp
            self?.refreshData()
        }
    }
    
    func refreshData() {
        switch type {
        case .refreshType_Normal:
            self.startPage = 1
        case .refreshType_PullDown:
            self.startPage = 1
        case .refreshType_PullUp:
            self.startPage += 1
        }
    }
    
    func beginDataRefresh() {
        self.tableView.es_startPullToRefresh()
    }
    
    func endDataRefresh() {
        self.type = .refreshType_Normal
        self.tableView.es_stopLoadingMore()
        self.tableView.es_stopPullToRefresh()
        
        if totalCount > existCount {

        }else {
            self.noMoreData()
        }
    }
    
    func noMoreData(){
        self.tableView.es_noticeNoMoreData()
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}

public class RefreshHeaderAnimator: ESRefreshHeaderAnimator {
    
    override init(frame: CGRect) {
        super.init(frame: frame) //这里要用super
        pullToRefreshDescription = "下拉可以刷新"
        releaseToRefreshDescription = "松开立即刷新"
        loadingDescription = "正在刷新数据中..."
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class RefreshFooterAnimator: ESRefreshFooterAnimator {
    
    override init(frame: CGRect) {
        super.init(frame: frame) //这里要用super
        loadingMoreDescription = "上拉加载更多"
        noMoreDataDescription = "已经全部加载完毕"
        loadingDescription = "正在加载更多的数据..."
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
