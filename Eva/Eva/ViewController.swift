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
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.addHeaderWithCallback { () -> Void in
            dataSource.removeAllObjects()
            dataSource.addObjectsFromArray(array)
            self.tableView.headerEndRefreshing()
            self.tableView.reloadData()
        }
        tableView.addFooterWithCallback { () -> Void in
            dataSource.addObjectsFromArray(array);
            self.tableView.footerEndRefreshing()
            self.tableView.reloadData()

        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIndentify) as! UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIndentify)
        }
        cell!.textLabel!.text = "index = "+"\(indexPath.row)" + "\(dataSource[indexPath.row])"
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

