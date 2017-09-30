//
//  MPPlan+CoreDataClass.swift
//  
//
//  Created by jieyang on 17/3/27.
//
//

import Foundation
import CoreData

@objc(MPPlan)
public class MPPlan: NSManagedObject {

    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "zh")
        dateFormatter.dateStyle  = DateFormatter.Style.long
        
        if !isAllDayTime {
            dateFormatter.dateFormat = dateFormatter.dateFormat + " HH:mm"
        }
        return dateFormatter
    }
    
    func beginTimeStr() -> String {
        return getDateFormatter().string(from: (beginTime! as Date ))
    }
    
    func endTimeStr() -> String {
        return getDateFormatter().string(from: (endTime! as Date ))
    }
    
    func recaculateValue() -> Double {
        var newValue : Double = 0
        newValue += self.startValue
        
        for execution in self.executions! {
            if let execution = execution as? Execution {
                newValue += execution.value
            }
        }
        return newValue
    }
}

/*
 let planID      : Int       //计划ID
 var planName    : String    //计划名称
 var parentID    : Int       //父ID
 var planCategory: Int       //分类
 var planType    : Int       //类型
 var tintColor   : Int       //主体颜色
 var planIcon    : String    //Icon
 let createDate  : NSDate    //创建时间
 var lastUpdate  : NSDate    //更新时间
 
 var beginTime   : NSDate    //开始时间
 var endTime     : NSDate    //结束时间
 
 var startValue  : Int       //其实值
 var tergetValue : Int       //目标值
 var value       : Int       //当前值
 
 var userValue   : Int       //用户干预值
 
 //自增量集合
 */
