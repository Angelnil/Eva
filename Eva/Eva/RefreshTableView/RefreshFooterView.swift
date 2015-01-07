//
//  RefreshFooterView.swift
//  Eva
//
//  Created by angelnil on 15/1/5.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import UIKit

class RefreshFooterView: UIView {

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

        lastUpdatedLabel = UILabel(frame: CGRectMake(0,10, self.frame.width, 20))
        lastUpdatedLabel.font = UIFont.systemFontOfSize(12.0)
        lastUpdatedLabel.backgroundColor = UIColor.clearColor()
        lastUpdatedLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        lastUpdatedLabel.shadowColor = UIColor(white: 0.9, alpha: 1.0)
        lastUpdatedLabel.textColor = textColor
        lastUpdatedLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(lastUpdatedLabel)
        
        
        stateLabel = UILabel(frame: CGRectMake(0,28, self.frame.width, 20))
        stateLabel.font = UIFont.systemFontOfSize(13.0)
        stateLabel.backgroundColor = UIColor.clearColor()
        stateLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        stateLabel.shadowColor = UIColor(white: 0.9, alpha: 1.0)
        stateLabel.textColor = textColor
        stateLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(stateLabel)
        
        
        arrowImage = CALayer()
        arrowImage.frame = CGRectMake(25.0,15.0, 20.0, 40.0)
        arrowImage.contentsGravity = kCAGravityResizeAspect;
        arrowImage.contents = UIImage(named: arrowImageName)!.CGImage
        self.layer.addSublayer(arrowImage)
        
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRectMake(45.0, 18.0, 20.0, 20.0)
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
            
            stateLabel.text = "上拉加载更多..."
            activityView.stopAnimating()
            CATransaction.begin()
            arrowImage.hidden = false;
            arrowImage.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0.0, 0.0, 1.0)
            CATransaction.commit()
            self.refreshLastUpdatedDate()
            
        case .refreshPulling:
            stateLabel.text = "释放立即加载..."
            CATransaction.begin()
            CATransaction.setAnimationDuration(animationDuration)
            arrowImage.transform = CATransform3DIdentity;
            CATransaction.commit()
            
        case .refreshLoading:
            stateLabel.text = "加载中..."
            activityView.startAnimating()
            CATransaction.begin()
            arrowImage.hidden = true
            CATransaction.commit()
        }
        
        state = aState;
        
    }
    
    //上次刷新时间
    func refreshLastUpdatedDate() {
        let date:NSDate = refrshDelegate!.egoRefreshTableDataSourceLastUpdated(self)
        let dateFormat = NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        lastUpdatedLabel.text = "上次加载时间:\(dateFormat)"
    }
    
    //scrollView 滑动
    func egoRefreshScrollViewDidScroll(scrollView:UIScrollView) {
        var dragDistance:CGFloat = 0
        if scrollView.bounds.height > scrollView.contentSize.height {
            dragDistance = scrollView.contentOffset.y
        } else {
           dragDistance = scrollView.contentOffset.y+scrollView.bounds.height-scrollView.contentSize.height
        }
        if state == RefreshState.refreshLoading {
            var offset = max(scrollView.contentOffset.y*(-1), 0)
            offset = min(offset, 60)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: regreshRegionHeight, right: 0)
        } else if scrollView.dragging {
            var isLoading = false
            if (refrshDelegate != nil) {
                isLoading = refrshDelegate!.egoRefreshTableDataSourceIsLoading(self)
            }
            
            if (state == RefreshState.refreshPulling && dragDistance < regreshRegionHeight && dragDistance > 0.0 && !isLoading) {
                self.setRefreshState(RefreshState.refreshNormal)
            } else if (state == RefreshState.refreshNormal && dragDistance > regreshRegionHeight && !isLoading) {
                self.setRefreshState(RefreshState.refreshPulling)
            }
            
            if (scrollView.contentInset.bottom != 0) {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
            
        }
    }
    
    func egoRefreshScrollViewDidEndDragging(scrollView:UIScrollView) {
        var isLoading = false
        var dragDistance:CGFloat = 0
        if scrollView.bounds.height > scrollView.contentSize.height {
            dragDistance = scrollView.contentOffset.y
        } else {
            dragDistance = scrollView.contentOffset.y+scrollView.bounds.height-scrollView.contentSize.height
        }
        if refrshDelegate != nil {
            isLoading = refrshDelegate!.egoRefreshTableDataSourceIsLoading(self)
        }
        if (dragDistance > regreshRegionHeight && !isLoading) {
            if refrshDelegate != nil {
                refrshDelegate!.egoRefreshTableDidTriggerRefresh(RefreshViewPos.refreshFooter)
            }
            self.setRefreshState(RefreshState.refreshLoading)
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:regreshRegionHeight, right: 0)
            })
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
        }
    }
    
    func egoRefreshScrollViewDataSourceDidFinishedLoading(scrollView:UIScrollView) {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
        })
        self.setRefreshState(RefreshState.refreshNormal)
    }

}
