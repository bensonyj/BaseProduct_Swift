//
//  OrderProductCell.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/24.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit
import Kingfisher

class OrderProductCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = color_B
        
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(priceSignLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(numberLabel)
        
        productImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImageView.snp.top)
            make.left.equalTo(productImageView.snp.right).offset(20)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        priceSignLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.bottom.equalTo(productImageView.snp.bottom)
        }
        
        numberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(productImageView.snp.bottom)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(priceSignLabel.snp.right).offset(5)
            make.bottom.equalTo(productImageView.snp.bottom)
            make.right.equalTo(numberLabel.snp.left).offset(-15)
        }
        
        priceLabel.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var product: ProductModel? = nil {
        didSet {
            if product?.img_src != nil {
                let url = URL(string: product!.img_src_encoding)
                self.productImageView.kf.setImage(with: url, placeholder: UIImage.init(named: "img_70"))
            }else {
                self.productImageView.image = UIImage.init(named: "img_70")
            }
            
            self.nameLabel.text = product!.name
            self.numberLabel.text = "x\(product!.number!)"
        }
    }

    
    lazy var productImageView: UIImageView = {
       let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = color_Z
        label.textColor = color_G
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var priceSignLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = color_Z
        label.textColor = color_NQ1
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = color_Z
        label.textColor = color_G
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = color_Z
        label.textColor = color_NQ1
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
