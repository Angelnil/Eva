//
//  EWNumberAddOrDec.swift
//  Eva
//
//  Created by Angle_Yan on 15/3/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import UIKit

protocol  NumberChangeViewDelegate {
    func addOrDecButtonClick(type: NSInteger , changeView:UIView)
}

@IBDesignable
class EWNumberAddOrDec: EWBaseView {

    
    @IBInspectable var number: NSInteger = 1 {
        didSet {
            //写数字
            numberLabel.text = "\(number)"
        }
    }
    
    @IBInspectable var buttonWight: CGFloat = 20.0 {
        didSet {
            self.updateFrames()
        }
        
    }
    
    @IBInspectable var textColor: UIColor? {
        didSet {
            numberLabel.textColor = textColor        
        }
    }
    
    @IBInspectable var buttonColor: UIColor? {
        didSet {
            desButton.setTitleColor(buttonColor, forState: UIControlState.Normal)
            addButton.setTitleColor(buttonColor, forState: UIControlState.Normal)
        }
    }


    #if TARGET_INTERFACE_BUILDER
    override func willMoveToSuperview(newSuperview: UIView?) {
        self.defaultUI()
    }
    #else
    override func awakeFromNib() {
        super.awakeFromNib()
        self.defaultUI()
    }
    #endif
    
    
    private let desButton: UIButton = UIButton()
    private let numberLabel: UILabel = UILabel()
    private let addButton: UIButton = UIButton()
    private let line1 = CALayer()
    private let line2 = CALayer()
    //基本的设置
    private func defaultUI() {
        desButton.setTitle("-", forState: UIControlState.Normal)
        desButton.addTarget(self, action: "numberChange:", forControlEvents: UIControlEvents.TouchUpInside)
        desButton.tag = 100
        
        numberLabel.textAlignment = NSTextAlignment.Center
        numberLabel.tag = 101
        
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.addTarget(self, action: "numberChange:", forControlEvents: UIControlEvents.TouchUpInside)
        addButton.tag = 102

        addSubview(desButton)
        addSubview(numberLabel)
        addSubview(addButton)
        
        line1.backgroundColor = self.borderColor?.CGColor
        layer.addSublayer(line1)
        
        line2.backgroundColor = self.borderColor?.CGColor
        layer.addSublayer(line2)
    }
    
    //动态更新
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrames()
    }

    //改变frame，或者 buttonWight 时动态更新
    private func updateFrames() {
        let desButtonRect :CGRect = CGRect(x: 0.0, y: 0.0, width: buttonWight, height: self.frame.height)
        let numberLabelRect :CGRect = CGRect(x: buttonWight, y: 0.0, width: self.frame.width-buttonWight*2, height: self.frame.height)
        let addButtonRect :CGRect = CGRect(x: self.frame.width-buttonWight, y: 0.0, width: buttonWight, height: self.frame.height)
        desButton.frame = desButtonRect
        numberLabel.frame = numberLabelRect
        addButton.frame = addButtonRect
        
        line1.frame = CGRectMake(CGRectGetMinX(numberLabel.frame), 0.0, self.borderWidth, numberLabel.frame.height)
        line2.frame = CGRectMake(CGRectGetMaxX(numberLabel.frame), 0.0, self.borderWidth, numberLabel.frame.height)
    }

    
    var  numberDelegate: NumberChangeViewDelegate?
    //判断时增加，减少，还是数量为1不能减少了
    var isAddOrDec: NSInteger = -2 {
        didSet {
            if let delegate = numberDelegate {
                delegate.addOrDecButtonClick(isAddOrDec,changeView: self)
            }
        }
    }
    
    func numberChange(sender: UIButton) -> Void  {
        if sender.tag == 100 {
            //减少
            if (number-1) > 0 {
                number--
                isAddOrDec = -1
            } else {
                number = 1
                isAddOrDec = 0
            }
        } else {
            //增加
            number++
            isAddOrDec = 1
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
