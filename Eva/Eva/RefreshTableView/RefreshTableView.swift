//
//  RefreshTableView.swift
//  Eva
//
//  Created by angelnil on 15/1/5.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import UIKit


//Mark:刷新和加载更多
typealias getRefreshBlock = () -> ()
typealias getNextPageNumBlock = () -> ()

class RefreshTableView: UITableView,RefreshDelegate {

    var headerView:RefreshHeaderView?
    var footerView:RefreshFooterView?

    var isLoading = false
    var ishead:Bool = false
    var isfoot:Bool = false

    var getRefresh:getRefreshBlock!
    var getNextPageNum:getNextPageNumBlock!

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        ishead = true
        isfoot = true
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        createHeaderView()
        createFooterView()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ishead = true
        isfoot = true
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        createHeaderView()
        createFooterView()
    }
    
    init(_isHeader:Bool,_isFooter:Bool,frame:CGRect) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        ishead = _isHeader;
        isfoot = _isFooter
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        createHeaderView()
        createFooterView()
    }
    
    
    //MARK: 私有方法
    private

//    MARK: －－headerView
    func createHeaderView() {
        if ishead {
            if headerView != nil {
                headerView!.removeFromSuperview()
                headerView = nil
            }
            headerView = RefreshHeaderView(frame: CGRectMake(0,0.0-self.bounds.height,self.bounds.width, self.bounds.height), arrowImageName: "blueArrow", textColor: UIColor.grayColor(), delegate: self)
            self.addSubview(headerView!)
            headerView!.refreshLastUpdatedDate()
        }
    }
    
    func removeHeaderView(){
        if headerView != nil {
            headerView!.removeFromSuperview()
            headerView = nil
        }
    }

    //MARK: －－footerView
    func createFooterView() {
        let y = max(self.contentSize.height, self.bounds.height)
        if isfoot {
            if footerView != nil {
                footerView!.frame = CGRectMake(0,y,self.bounds.width, self.bounds.height)
            } else {
            footerView = RefreshFooterView(frame: CGRectMake(0,y,self.bounds.width, self.bounds.height), arrowImageName: "blueArrow", textColor: UIColor.grayColor(), delegate: self)
            self.addSubview(footerView!)
            }
            footerView!.refreshLastUpdatedDate()
        }
    }
    
    func removeFooterView(){
        if footerView != nil {
            footerView!.removeFromSuperview()
            footerView = nil
        }
    }
    
    //
    func showRefreshHeader(animated:Bool) {
        if animated {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
                self.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
            })
        } else {
            self.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
            self.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
        }
        
        headerView!.setRefreshState(RefreshState.refreshPulling)
    }
    
    func beginToReloadData(aRefreshViewPos:RefreshViewPos) {
        isLoading = true
        var methodName:Selector? = nil
        if aRefreshViewPos == RefreshViewPos.refreshHeader {
            methodName = "refreshData"
        }
        
        if aRefreshViewPos == RefreshViewPos.refreshFooter {
            methodName = "getNextPage"
        }

//        let delayTime = dispatch_time(dispatch_time_t(),Int64(10))
//        dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
//            NSThread.detachNewThreadSelector(methodName!, toTarget: self, withObject: nil)
//        })
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: methodName!, userInfo: nil, repeats: false)
    }
    
    func refreshData() {
        self.getRefresh()
        self.willFinishedLoadData()
    }
    
    func getNextPage() {
        self.getNextPageNum()
        self.willFinishedLoadData()
    }
    
    func willFinishedLoadData() {
        self.finishReloadingData()
        self.createFooterView()
    }
    
    func finishReloadingData() {
        isLoading = false
        if headerView != nil {
            headerView!.egoRefreshScrollViewDataSourceDidFinishedLoading(self)
        }
        if footerView != nil {
            footerView!.egoRefreshScrollViewDataSourceDidFinishedLoading(self)
            createFooterView()
        }
    }
    

    //MARK:代理方法
    func egoRefreshTableDidTriggerRefresh(aRefreshPos: RefreshViewPos) {
        self.beginToReloadData(aRefreshPos)
    }
    
    
    func egoRefreshTableDataSourceLastUpdated(view: UIView) -> NSDate {
        return NSDate()
    }
    
    func egoRefreshTableDataSourceIsLoading(view: UIView) -> Bool {
        return isLoading
    }
    
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
