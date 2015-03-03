//
//  EWBaseView.swift
//  Eva
//
//  Created by Angle_Yan on 15/3/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import UIKit

@IBDesignable

class EWBaseView: UIView {
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    //2种方式来判断时已IB创建 还是代码手动创建
    
    //1. IB 创建的
    override func prepareForInterfaceBuilder() {
        
    }

    
    //2.
    #if TARGET_INTERFACE_BUILDER
    // this code will execute only in IB
    #else
    // this code will run in the app itself
    #endif
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}

