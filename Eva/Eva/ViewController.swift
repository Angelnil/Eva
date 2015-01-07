//
//  ViewController.swift
//  Eva
//
//  Created by angelnil on 15/1/4.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import UIKit

private let cellIndentify = "cell"
private var dataSource:NSMutableArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n"]
private let array = ["a","b","c","d"]

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var refreshTableView:RefreshTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        refreshTableView = RefreshTableView(_isHeader: true, _isFooter: true, frame: self.view.bounds)
        refreshTableView!.delegate = self
        refreshTableView!.dataSource = self
        refreshTableView!.getRefresh = {
            dataSource.removeAllObjects()
            dataSource.addObjectsFromArray(array)
            self.refreshTableView!.reloadData()
        }
        
        refreshTableView!.getNextPageNum = {
            dataSource.addObjectsFromArray(array)
            self.refreshTableView!.reloadData()
        }
        
        self.view.addSubview(refreshTableView!)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIndentify) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIndentify)
        }
        cell!.textLabel!.text = "index = "+"\(indexPath.row)" + "\(dataSource[indexPath.row])"
        return cell!
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if refreshTableView!.headerView != nil {
            refreshTableView!.headerView!.egoRefreshScrollViewDidScroll(refreshTableView!)
        }
        
        if refreshTableView!.footerView != nil {
            refreshTableView!.footerView!.egoRefreshScrollViewDidScroll(refreshTableView!)
        }
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshTableView!.headerView != nil {
            refreshTableView!.headerView!.egoRefreshScrollViewDidEndDragging(refreshTableView!)
        }
        
        if refreshTableView!.footerView != nil {
            refreshTableView!.footerView!.egoRefreshScrollViewDidEndDragging(refreshTableView!)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

