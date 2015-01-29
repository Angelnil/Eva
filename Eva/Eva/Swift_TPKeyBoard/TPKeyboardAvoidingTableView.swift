//
//  TPKeyboardAvoidingTableView.swift
//  YLY11_10
//
//  Created by angelnil on 14/12/19.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

import UIKit

class TPKeyboardAvoidingTableView: UITableView,UITextFieldDelegate, UITextViewDelegate{

    
    //添加通知
    func setUpNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("TPKeyboardAvoiding_keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("TPKeyboardAvoiding_keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("TPKeyboardAvoiding_keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }

    
    //移除通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //重写初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpNotification()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpNotification()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    //这几个方法是呀调用的，在添加了所有的控件之后调用
    func reSetFrame() {
        self.TPKeyboardAvoiding_updateContentInset()
    }
    
    func reSetContentSize() {
        self.TPKeyboardAvoiding_updateFromContentSizeChange();
    }
    
    func contentSizeToFit() {
        self.contentSize = self.TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames();
    }
    
    
    
    func focusNextTextField() -> Bool {
        return self.TPKeyboardAvoiding_focusNextTextField()
    }
    
    func scrollToActiveTextField(){
        self.TPKeyboardAvoiding_scrollToActiveTextField();
    }
    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.focusNextTextField() {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.scrollToActiveTextField()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.scrollToActiveTextField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector:"TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView", object: self)
        self.TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(self)
    }
    
}
