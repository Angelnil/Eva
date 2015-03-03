//
//  AnimationViewController.swift
//  Eva
//
//  Created by Angle_Yan on 15/3/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController, NumberChangeViewDelegate{
    
    @IBOutlet var vieqasf: EWNumberAddOrDec!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vieqasf.numberDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addOrDecButtonClick(type: NSInteger, changeView: UIView) {

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
