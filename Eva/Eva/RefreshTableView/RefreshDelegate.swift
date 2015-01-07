//
//  RefreshDelegate.swift
//  Eva
//
//  Created by angelnil on 15/1/5.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import Foundation
import UIKit

let defaultTextColor = UIColor(red: 87.0/255.0, green: 108.0/255.0, blue: 137.0/255.0, alpha: 1.0)
let animationDuration:NSTimeInterval = 0.18
let regreshRegionHeight:CGFloat = 65.0

enum RefreshState:Int {
    case refreshPulling = 0,
         refreshNormal,
         refreshLoading
}

enum RefreshViewPos:Int {
    case refreshHeader = 0,refreshFooter
}

protocol RefreshDelegate {
    
    func egoRefreshTableDidTriggerRefresh(aRefreshPos:RefreshViewPos)
    func egoRefreshTableDataSourceIsLoading(view:UIView) -> Bool
    
    func egoRefreshTableDataSourceLastUpdated(view:UIView) -> NSDate
}



