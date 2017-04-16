//
//  OrderFooterView.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/24.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit

protocol OrderFooterViewDelegate {
    func footerViewClicked(order: OrderModel)
}

class OrderFooterView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = color_C
        self.contentView.addSubview(labelView)
        labelView.addSubview(numberLabel)
        
        labelView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(0, 0, 10, 0))
        }
        numberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(labelView).offset(10)
            make.right.equalTo(labelView).offset(-15)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(footerClicked))
        self.contentView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var order: OrderModel? = nil {
        didSet {
            self.numberLabel.text = "共\(order!.total_num)件商品"
//            self.priceLabel.text = "实付：￥\(order!.pay_price_string)"
        }
    }
    
    var delegate: OrderFooterViewDelegate?
    
    func footerClicked() {
        delegate?.footerViewClicked(order: order!)
    }

    lazy var labelView: UIView = {
       let view = UIView.init()
        view.backgroundColor = color_A
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = color_A
        label.textColor = color_G
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = color_A
        label.textColor = color_G
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
