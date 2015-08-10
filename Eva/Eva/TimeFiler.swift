//
//  TimeFiler.swift
//  Eva
//
//  Created by Angle_Yan on 15/4/14.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

import Foundation

struct DateFormat {
    let DateFormat1 = "yyyy-MM-dd hh:mm:ss"
    let dateFormat2 = "yyyy-MM-dd hh:mm:ss:SSS"
    let DateFormat3 = "yyyy-MM-dd-hh-mm-ss-SSS"
    let dateFormat4 = "h-mm"
    let DateFormat5 = "yyyy-MM-dd a H:mm:ss"
    let dateFormat6 = "M月d日 H:mm"
}


extension NSString {
    
    //*将date时间转化成String时间*/
    func timeStringFromDate(date:NSDate, format:String) -> NSString {
        return dataFormateFromString(format).stringFromDate(date)
    }
    //*将String时间转化成date时间*/
    func dateFromTimeString(timeString:String, format:String) -> NSDate? {
        return dataFormateFromString(format).dateFromString(timeString)
    }
    
    //*将日期转化成 weekDay */
    func weekDayStringFromDate(date:NSDate) -> String {
        var weekDay = ""
        let newDateString = dataFormateFromString("EEEE").stringFromDate(date)
        if newDateString == "Monday" {
            weekDay = "星期一"
        } else if newDateString == "Tuesday" {
            weekDay = "星期二"
        } else if newDateString == "Wednesday" {
            weekDay = "星期三"
        } else if newDateString == "Thursday" {
            weekDay = "星期四"
        } else if newDateString == "Friday" {
            weekDay = "星期五"
        } else if newDateString == "Saturday" {
            weekDay = "星期六"
        } else if newDateString == "Sunday" {
            weekDay = "星期天"
        }
        return weekDay
    }
    
    
    
    private func dataFormateFromString(format: String) -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
}
