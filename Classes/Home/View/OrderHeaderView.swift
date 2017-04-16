//
//  OrderHeaderView.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/24.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit

protocol OrderHeaderViewDelegate {
     func headerViewClicked(order: OrderModel)
}

class OrderHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = color_A
        self.contentView.addSubview(idLabel)
        self.contentView.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        idLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(statusLabel.snp.left).offset(-15)
        }

        idLabel.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(headerClicked))
        self.contentView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var order: OrderModel? = nil {
        didSet {
            self.idLabel.text = "订单编号:\(order!.order_no!)"
            self.statusLabel.text = order!.statusString
            self.statusLabel.textColor = order!.statusStringColor
        }
    }
    
    var delegate: OrderHeaderViewDelegate?
    
    func headerClicked() {
        delegate?.headerViewClicked(order: order!)
    }
    
    lazy var idLabel: UILabel = {
       let label = UILabel.init()
        label.backgroundColor = color_A
        label.textColor = color_G
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    lazy var statusLabel: UILabel = {
    let label = UILabel.init()
    label.backgroundColor = color_A
    label.textColor = color_G
    label.font = UIFont.systemFont(ofSize: 14)
    return label
    }()
}
