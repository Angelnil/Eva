//
//  DateView.swift
//  Eva
//
//  Created by Angle_Yan on 15/4/14.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics


class DateView: EWBaseView {
    
    var date:NSDate? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        //绘制月份
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)

        
        //绘制月份的背景色
        var frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 20)
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)//填充颜色
        CGContextFillRect(context, frame)//填充范围
        
        //绘制月份数字
        let moth :String = "4月"
        let mothFont = UIFont.systemFontOfSize(32, weight: 32.0)
        CGContextSetRGBStrokeColor(context, 0.8, 0.5, 0.3, 1) //画笔颜色
        CGContextSetTextDrawingMode(context, kCGTextStroke)
        (moth as NSString).drawAtPoint(CGPoint(x: frame.width/2, y:3), withAttributes: nil)
    
        //绘制日期数字
        let day :String = "19"
        let dauFont = UIFont.systemFontOfSize(64, weight: 32.0)
        CGContextSetRGBStrokeColor(context, 0.8, 0.5, 0.3, 1) //画笔颜色
        CGContextSetTextDrawingMode(context, kCGTextStroke)
        (day as NSString).drawAtPoint(CGPoint(x: frame.width/2, y:3), withAttributes: nil)

        
        
        
        CGContextRestoreGState(context)
        
    }
    
//    private func cal
    
    
}
