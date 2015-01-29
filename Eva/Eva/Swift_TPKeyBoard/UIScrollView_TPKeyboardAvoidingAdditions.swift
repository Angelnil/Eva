//
//  UIScrollView_TPKeyboardAvoidingAdditions.swift
//  YLY11_10
//
//  Created by angelnil on 14/12/17.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

import Foundation
import UIkit
import ObjectiveC


let _UIKeyboardFrameEndUserInfoKey = (UIKeyboardFrameEndUserInfoKey != nil ? UIKeyboardFrameEndUserInfoKey:"UIKeyboardBoundsUserInfoKey")

let kCalculatedContentPadding:CGFloat = 10.0
let kMinimumScrollOffsetPadding:CGFloat = 20.0
var kStateKey:Int8 = 0

//需找下一个输入框且设计偏移量
var minY:CGFloat = CGFloat.max
var otherView:UIView? = nil


class TPKeyboardAvoidingState {
    //ScrollView prior 先前的
    var priorInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var priorScrollIndicatorInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var priorContentSize:CGSize = CGSize()
    
    var keyboardVisible:Bool = Bool()
    var keyboardRect:CGRect = CGRect()
    
    init() {
        self.priorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.priorScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.keyboardVisible = Bool()
        self.keyboardRect = CGRect()
        self.priorContentSize = CGSize()
    }
    
}


extension UIScrollView:UITextFieldDelegate ,UITextViewDelegate{
    
    //动态关联
    func tPKeyboardAvoidingState() -> TPKeyboardAvoidingState! {
        var state:TPKeyboardAvoidingState? = objc_getAssociatedObject(self, &kStateKey)
            as? TPKeyboardAvoidingState
        if state == nil {
            state = TPKeyboardAvoidingState();
            objc_setAssociatedObject(self, &kStateKey, state!, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
        return state!
    }
    
    //MARK ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝键盘通知 ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    //keyboardWillShow
    func TPKeyboardAvoiding_keyboardWillShow(notification:NSNotification) {
        var state:TPKeyboardAvoidingState = self.tPKeyboardAvoidingState()
        if state.keyboardVisible {
            return
        }
        
        let firstResponder = self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)
        let info = notification.userInfo as Dictionary!
        state.keyboardRect = self.convertRect(((info[_UIKeyboardFrameEndUserInfoKey]) as NSValue!).CGRectValue(), fromView:nil)
        state.keyboardVisible = true
        state.priorInset = self.contentInset
        state.priorScrollIndicatorInsets = self.scrollIndicatorInsets
        
        if  self.isKindOfClass(TPKeyboardAvoidingScrollView) {
            state.priorContentSize = self.contentSize
            if CGSizeEqualToSize(self.contentSize, CGSizeZero) {
                self.contentSize = self.TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
            }
        }
        
        //动画形式移动
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]) as NSTimeInterval)
        self.contentInset = self.TPKeyboardAvoiding_contentInsetForKeyboard()
        
        if  (firstResponder != nil) {
            let viewAbleHeight:CGFloat = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
            self.setContentOffset(CGPoint(x: self.contentOffset.x, y: self.TPKeyboardAvoiding_idealOffsetForView(view: firstResponder!, viewAreaHeight: viewAbleHeight)), animated: true)
        }
        
        self.scrollIndicatorInsets = self.contentInset
        UIView.commitAnimations()
        
    }
    
    //keyboardChangeFrame
    func TPKeyboardAvoiding_keyboardWillChangeFrame(notification:NSNotification) {
        var state:TPKeyboardAvoidingState = self.tPKeyboardAvoidingState()
        if notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as CGFloat! > 0.0 {
            return
        }
        
        let firstResponder = self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)
        let info = notification.userInfo as Dictionary!
        state.keyboardRect = self.convertRect(((info[UIKeyboardFrameEndUserInfoKey]) as NSValue!).CGRectValue(), fromView:nil)
        state.keyboardVisible = true
        state.priorInset = self.contentInset
        state.priorScrollIndicatorInsets = self.scrollIndicatorInsets
        
        if  self.isKindOfClass(TPKeyboardAvoidingScrollView) {
            state.priorContentSize = self.contentSize
            // Set the content size, if it's not set. Do not set content size explicitly if auto-layout
            // is being used to manage subviews
            if CGSizeEqualToSize(self.contentSize, CGSizeZero) {
                self.contentSize = self.TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
            }
        }
        
        //动画形式移动
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]) as NSTimeInterval)
        self.contentInset = self.TPKeyboardAvoiding_contentInsetForKeyboard()
        
        if  (firstResponder != nil) {
            let viewAbleHeight:CGFloat = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
            self.setContentOffset(CGPoint(x: self.contentOffset.x, y: self.TPKeyboardAvoiding_idealOffsetForView(view: firstResponder!, viewAreaHeight: viewAbleHeight)), animated: true)
        }
        
        self.scrollIndicatorInsets = self.contentInset
        UIView.commitAnimations()
    }
    
    func TPKeyboardAvoiding_keyboardWillHide(notification:NSNotification) {
        var state:TPKeyboardAvoidingState = self.tPKeyboardAvoidingState()
        if !state.keyboardVisible {
            return
        }
        state.keyboardRect = CGRectZero
        state.keyboardVisible = false
        
        //动画形式移动
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]) as NSTimeInterval)
        if self.isKindOfClass(TPKeyboardAvoidingScrollView) {
            self.contentSize = state.priorContentSize
            self.contentInset = state.priorInset
            self.scrollIndicatorInsets = state.priorScrollIndicatorInsets
        }
        UIView.commitAnimations()
    }
    
    //MARK ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝键盘通知结束 ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
    func TPKeyboardAvoiding_updateContentInset() {
        var state:TPKeyboardAvoidingState = self.tPKeyboardAvoidingState()
        if state.keyboardVisible {
            self.contentInset = self.TPKeyboardAvoiding_contentInsetForKeyboard()
        }
    }
    
    func TPKeyboardAvoiding_updateFromContentSizeChange() {
        var state:TPKeyboardAvoidingState = self.tPKeyboardAvoidingState()
        if state.keyboardVisible {
            state.priorContentSize = self.contentSize
            self.contentInset = self.TPKeyboardAvoiding_contentInsetForKeyboard()
        }
    }
    
    //下一个textField是否为焦点
    func TPKeyboardAvoiding_focusNextTextField() -> Bool {
        let firstResponder:UIView? = self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)
        if firstResponder == nil {
            return false
        }
        minY = CGFloat.max
        otherView = nil
        self.TPKeyboardAvoiding_findTextFieldAfterTextField(firstResponder!, beneathView: self, theMinY: minY, foundView: otherView);
        if otherView != nil {
            firstResponder!.resignFirstResponder()
            otherView!.becomeFirstResponder()
            return true
        }
        return false
    }
    
    //滚动到当前第一响应的textField
    func TPKeyboardAvoiding_scrollToActiveTextField() {
        let state:TPKeyboardAvoidingState = self.tPKeyboardAvoidingState();
        if !state.keyboardVisible {
            return
        }
        let visibleSpace:CGFloat = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
        let idealOffset:CGPoint = CGPointMake(0, self.TPKeyboardAvoiding_idealOffsetForView(view: self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)!, viewAreaHeight: visibleSpace))
        self.setContentOffset(idealOffset, animated: true)
    }
    
    //找出view上的当前响应的控件
    func TPKeyboardAvoiding_findFirstResponderBeneathView(view:UIView) -> UIView? {
        
        for childView in view.subviews {
            if (childView.respondsToSelector("isFirstResponder") && childView.isFirstResponder()) {
                return (childView as? UIView)
            }
            let result:UIView? = self.TPKeyboardAvoiding_findFirstResponderBeneathView(childView as UIView)
            if result != nil {
                return result
            }
        }
        return nil
    }
    
    func TPKeyboardAvoiding_findTextFieldAfterTextField(priorTextField:UIView,beneathView:UIView, theMinY:CGFloat,foundView:UIView?) {
        let priorFieldOffset:CGFloat = CGRectGetMinY(self.convertRect(priorTextField.frame, fromView: priorTextField.superview));
        for childView in beneathView.subviews {
            if (childView as UIView).hidden {
                continue
            }
            if ((childView as UIView !== priorTextField) && (childView.isKindOfClass(UITextField) || childView.isKindOfClass(UITextView)) && (childView as UIView).userInteractionEnabled == true) {
                let frame:CGRect = self.convertRect((childView as UIView).frame, fromView: beneathView)
                
                if (CGRectGetMinY(frame) >= priorFieldOffset && CGRectGetMinY(frame) < minY && !(frame.origin.y == priorTextField.frame.origin.y
                    && frame.origin.x < priorTextField.frame.origin.x)) {
                        minY = CGRectGetMinY(frame)
                        otherView = childView as? UIView
                }
            } else {
                self.TPKeyboardAvoiding_findTextFieldAfterTextField(priorTextField, beneathView:childView as UIView, theMinY: minY, foundView: otherView)
            }
            
        }
    }
    
    
    func TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(view:UIView) ->() {
        for childView in view.subviews {
            if ( childView.isKindOfClass(UITextField) || childView.isKindOfClass(UITextView) ) {
                self.TPKeyboardAvoiding_initializeView(childView as UIView)
            } else {
                self.TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(childView as UIView)
            }
        }
    }
    
    
    //根据subViews的frame计算contentSize
    func TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames() -> CGSize {
        let wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator
        let wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
        var rect:CGRect = CGRectZero
        for view in self.subviews  {
            rect = CGRectUnion(rect, view.frame);
        }
        rect.size.height += kCalculatedContentPadding;
        self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator;
        self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator;
        return rect.size;
    }
    
    //根据keyboard重现设置contentInset,只需要修改bottom
    func TPKeyboardAvoiding_contentInsetForKeyboard() -> UIEdgeInsets {
        var state:TPKeyboardAvoidingState = self.tPKeyboardAvoidingState()
        var newInset = self.contentInset;
        let keyboardRect = state.keyboardRect;
        newInset.bottom = keyboardRect.size.height - (CGRectGetMaxY(keyboardRect) - CGRectGetMaxY(self.bounds));
        return newInset;
    }
    
    //设置包含键盘最好的offset
    func TPKeyboardAvoiding_idealOffsetForView(view aView:UIView, viewAreaHeight aviewAreaHeight:CGFloat) -> CGFloat {
        let contentSize:CGSize = self.contentSize
        var offset:CGFloat = 0.0
        let subviewRect:CGRect = aView.convertRect(aView.bounds, toView: self)
        var padding:CGFloat = (aviewAreaHeight - subviewRect.size.height) / 2
        if padding < kMinimumScrollOffsetPadding {
            padding = kMinimumScrollOffsetPadding;
        }
        offset = subviewRect.origin.y - padding - self.contentInset.top
        
        if offset > (contentSize.height - aviewAreaHeight) {
            offset = contentSize.height - aviewAreaHeight
        }
        
        if ( offset < -self.contentInset.top ) {
            offset = -self.contentInset.top
        }
        return offset
    }
    
    func TPKeyboardAvoiding_initializeView(view:UIView) {
        if view.isKindOfClass(UITextField) {
            var textField = view as UITextField
            if ((textField.returnKeyType == UIReturnKeyType.Default) && textField.delegate == nil) {
                textField.delegate = self
                minY = CGFloat.max
                otherView = nil
                self.TPKeyboardAvoiding_findTextFieldAfterTextField(textField, beneathView: self, theMinY: minY, foundView: otherView)
                if (otherView != nil) {
                    textField.returnKeyType = UIReturnKeyType.Next
                } else {
                    textField.returnKeyType = UIReturnKeyType.Done
                }
            }
        } else if view.isKindOfClass(UITextView) {
            var textView = view as UITextView
            if ((textView.returnKeyType == UIReturnKeyType.Default) && textView.delegate == nil) {
                textView.delegate = self
                minY = CGFloat.max
                otherView = nil
                self.TPKeyboardAvoiding_findTextFieldAfterTextField(textView, beneathView: self, theMinY: minY, foundView: otherView)
            }
        }
    }
    
}
