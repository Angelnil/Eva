//
//  UIScrollView+Refresh.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-24.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//

import UIKit

/*
控件主要实现原理是监控scrollview 的2个属性变化 来设置头部控件和尾部控件的状态 想要自己定义界面 可以参考代码并修改

添加控件
scrollView.addHeaderWithCallback({})
scrollView.addFooterWithCallback({})
没有用delegate 而是用closure来实现回调 如果不习惯可以自己写个delegate添加进去

其他方法UIScrollView+Refresh 都有实现

吐槽下xcode 6 有中文就不给代码提示 真恶心
*/

extension UIScrollView {
    func addHeaderWithCallback( callback:(() -> Void)!){
        var header:RefreshHeaderView = RefreshHeaderView.footer()
        self.addSubview(header)
        header.beginRefreshingCallback = callback
        header.addState(RefreshState.Normal)
    }
    
    func removeHeader()
    {
        for view : AnyObject in self.subviews{
            if view is RefreshHeaderView{
                view.removeFromSuperview()
            }
        }
    }
    
    
    func headerBeginRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                object.beginRefreshing()
            }
        }
    }
    
    
    func headerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                object.endRefreshing()
            }
        }
    }
    
    func setHeaderHidden(hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                var view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
    }
    
    func isHeaderHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                var view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
    }
    
   func addFooterWithCallback( callback:(() -> Void)!){
        var footer:RefreshFooterView = RefreshFooterView.footer()
        self.addSubview(footer)
        footer.beginRefreshingCallback = callback
        footer.addState(RefreshState.Normal)
    }
    
    
     func removeFooter()
    {
        for view : AnyObject in self.subviews{
            if view is RefreshFooterView{
                view.removeFromSuperview()
            }
        }
    }
    
    func footerBeginRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                object.beginRefreshing()
            }
        }
    }

    
    func footerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                object.endRefreshing()
            }
        }
    }
  
    func setFooterHidden(hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                var view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
    }
    
    func isFooterHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                var view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
    }
  
 
}