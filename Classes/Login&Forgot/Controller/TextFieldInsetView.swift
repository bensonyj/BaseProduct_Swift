//
//  TextFieldInsetView.swift
//  CattleSteamerHousekeeper
//
//  Created by 应剑 on 2017/2/21.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import UIKit

class TextFieldInsetView: UIView {

    var placeholder: String?
    var leftImageName: String?
    var leftTitle: String?
    var maxWidth: Int?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(placeholder: String?, leftImageName: String?) {
        self.init(frame: CGRect.zero)
        self.backgroundColor = color_A
        self.placeholder = placeholder
        self.leftImageName = leftImageName
        self.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 15, 0, 15))
        }
    }
    
    convenience init(placeholder: String?, leftTitle: String?, maxWidth: Int?) {
        self.init(frame: CGRect.zero)
        self.backgroundColor = color_A
        self.placeholder = placeholder
        self.leftTitle = leftTitle
        self.maxWidth = maxWidth
        self.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 15, 0, 15))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField.init()
        textField.textColor = color_F
        textField.placeholder = self.placeholder ?? ""
        textField.font = UIFont.systemFont(ofSize: 14)
        if self.leftImageName == nil {
            textField.leftView = self.setupTextFieldLeftView(leftTitle: self.leftTitle ?? "", width: self.maxWidth ?? 0)
        }else {
            textField.leftView = TextFieldInsetView.setupTextFieldLeftView(imageName:(self.leftImageName ?? ""))
        }
        textField.leftViewMode = .always
        
        return textField
    }()
    
    class func setupTextFieldLeftView(imageName: String) -> UIView {
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 22 + 22, height: 22))
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 22))
        imageView.image = UIImage.init(named: imageName)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        leftView.addSubview(imageView)
        
        return leftView
    }
    
    func setupTextFieldLeftView(leftTitle: String, width: Int) -> UIView {
        var maxWidth = width
        let font = UIFont.systemFont(ofSize: 14)
        if maxWidth <= 0 {
            let size = leftTitle.textSizeWithFont(font: font, constrainedToSize: CGSize.zero)
            maxWidth = Int(ceilf(Float(size.width)))
        }
        
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15 + 20 + maxWidth, height: 44))
        
        let leftLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: maxWidth, height: 44))
        leftLabel.backgroundColor = UIColor.clear
        leftLabel.textColor = color_G
        leftLabel.font = font
        leftLabel.text = leftTitle
        leftView.addSubview(leftLabel)
        
        return leftView
    }
}
