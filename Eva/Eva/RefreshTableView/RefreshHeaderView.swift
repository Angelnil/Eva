//
//  RefreshHeaderView.swift
//  Eva
//
//  Created by angelnil on 15/1/5.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import UIKit
import QuartzCore


class RefreshHeaderView: UIView {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var lastUpdatedLabel:UILabel = UILabel()
    var stateLabel:UILabel = UILabel()
    var arrowImage:CALayer = CALayer()
    var activityView:UIActivityIndicatorView = UIActivityIndicatorView()
    var state:RefreshState = RefreshState.refreshNormal
    var refrshDelegate:RefreshDelegate?
    
    init (frame:CGRect,arrowImageName:NSString,textColor:UIColor,delegate:RefreshDelegate) {
        super.init(frame: frame)
        self.refrshDelegate = delegate
        self.backgroundColor = UIColor(red: 226.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        lastUpdatedLabel = UILabel(frame: CGRectMake(0,frame.height - 30, self.frame.width, 20))
        lastUpdatedLabel.font = UIFont.systemFontOfSize(12.0)
        lastUpdatedLabel.backgroundColor = UIColor.clearColor()
        lastUpdatedLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        lastUpdatedLabel.shadowColor = UIColor(white: 0.9, alpha: 1.0)
        lastUpdatedLabel.textColor = textColor
        lastUpdatedLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(lastUpdatedLabel)
        
        
        stateLabel = UILabel(frame: CGRectMake(0,frame.height - 50, self.frame.width, 20))
        stateLabel.font = UIFont.systemFontOfSize(13.0)
        stateLabel.backgroundColor = UIColor.clearColor()
        stateLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        stateLabel.shadowColor = UIColor(white: 0.9, alpha: 1.0)
        stateLabel.textColor = textColor
        stateLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(stateLabel)
        
        
        arrowImage = CALayer()
        arrowImage.frame = CGRectMake(25.0,frame.height - 55.0, 15, 35)
        arrowImage.contentsGravity = kCAGravityResizeAspect;
        arrowImage.contents = UIImage(named: arrowImageName)!.CGImage
        self.layer.addSublayer(arrowImage)
        
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRectMake(45.0, frame.height - 38.0, 20.0, 20.0)
        self.addSubview(activityView)
        self.setRefreshState(state)
        
    }

    
    //刷新状态
    func setRefreshState(aState:RefreshState) {
        switch(aState) {
            
        case .refreshNormal:
            if (state == .refreshPulling) {
                CATransaction.begin()
                CATransaction.setAnimationDuration(animationDuration)
                arrowImage.transform = CATransform3DIdentity;
                CATransaction.commit()
            }
            
            stateLabel.text = "下拉刷新..."
            activityView.stopAnimating()
            CATransaction.begin()
            arrowImage.hidden = false;
            arrowImage.transform = CATransform3DIdentity;
            CATransaction.commit()
            
        case .refreshPulling:
            stateLabel.text = "释放立即刷新..."
            CATransaction.begin()
            CATransaction.setAnimationDuration(animationDuration)
            arrowImage.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0.0, 0.0, 1.0)
            CATransaction.commit()
            
        case .refreshLoading:
            stateLabel.text = "加载中..."
            activityView.startAnimating()
            CATransaction.begin()
            arrowImage.hidden = true
            CATransaction.commit()
            
        default:
            println("加载完成")
        }
        
        state = aState;
        
    }
    
    //上次刷新时间
    func refreshLastUpdatedDate() {
        let date:NSDate = refrshDelegate!.egoRefreshTableDataSourceLastUpdated(self)
        let time:Int = Int(NSDate().timeIntervalSinceDate(date))/60
        lastUpdatedLabel.text = "更新时间:"+"\(time)"+"分钟之前"
    }
    
    
    //scrollView 滑动
    func egoRefreshScrollViewDidScroll(scrollView:UIScrollView) {
        if state == RefreshState.refreshLoading {
            var offset = max(scrollView.contentOffset.y*(-1), 0)
            offset = min(offset, 60)
            scrollView.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
        } else if scrollView.dragging {
            var isLoading = false
            if (refrshDelegate != nil) {
                isLoading = refrshDelegate!.egoRefreshTableDataSourceIsLoading(self)
            }
            
            if (state == RefreshState.refreshPulling && scrollView.contentOffset.y > -65.0 && scrollView.contentOffset.y < 0.0 && !isLoading) {
                self.setRefreshState(RefreshState.refreshNormal)
            } else if (state == RefreshState.refreshNormal && scrollView.contentOffset.y < -65.0 && !isLoading) {
                self.setRefreshState(RefreshState.refreshPulling)
            }
            
            if (scrollView.contentInset.top != 0) {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
            
        }
    }

    func egoRefreshScrollViewDidEndDragging(scrollView:UIScrollView) {
    
        var isLoading = false
        if refrshDelegate != nil {
            isLoading = refrshDelegate!.egoRefreshTableDataSourceIsLoading(self)
        }
        if (scrollView.contentOffset.y <= -65.0 && !isLoading) {
            if refrshDelegate != nil {
                refrshDelegate!.egoRefreshTableDidTriggerRefresh(RefreshViewPos.refreshHeader)
            }
            self.setRefreshState(RefreshState.refreshLoading)
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                scrollView.contentInset = UIEdgeInsets(top: 60.0, left: 0, bottom: 0, right: 0)
            })
        }
    }
    
    func egoRefreshScrollViewDataSourceDidFinishedLoading(scrollView:UIScrollView) {
    
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
        })
        self.setRefreshState(RefreshState.refreshNormal)
    }

}
