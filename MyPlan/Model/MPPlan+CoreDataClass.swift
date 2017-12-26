//
//  MPPlan+CoreDataClass.swift
//  
//
//  Created by jieyang on 17/3/27.
//
//

import Foundation
import UIKit
import CoreData

@objc(MPPlan)
public class MPPlan: NSManagedObject {
    
    // MARK: - Create
    
    /// 创建一个新的计划
    ///
    /// - Returns: new Plan With the context
    static func newPlan(context: NSManagedObjectContext) -> MPPlan {
        let plan = MPPlan(context: context)
        plan.planName = ""
        // 先不维护ID 值 试试
        // newPlan.planID = 0
        // ID 根据取出来的数据的最大值 +1 来处理
        plan.tintColor = UIColor.init(red: 50/255, green: 191/255, blue: 254/255, alpha: 1.0)
        plan.planType = 0
        
        //        plan.isAllDayTime = true   //这里直接改为 true，会有问题
        plan.beginTime = NSDate()
        plan.endTime = NSDate().addingTimeInterval(60 * 60 * 24 * 1)
        
        plan.unit = 0
        plan.customUnit = ""
        plan.timeUnit = 1
        
        plan.startValue = 0
        plan.tergetValue = 100.0
        
        plan.planRemarks = ""
        return plan
    }
    
    /// 创建或编辑计划的时候检查项目合法
    ///
    /// - Returns: nil is right, else return the error alert string.
    func checkForCreatPlan() -> String? {
        if planName == nil || planName?.characters.count == 0 { return "请输入计划名称"}
//        if beginTime!.compare(endTime! as Date) == .orderedAscending { return "请修正结束时间"}
        return nil
    }

    // MARK: - Get
    
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "zh")
        dateFormatter.dateStyle  = DateFormatter.Style.long
        
        if !isAllDayTime {
            dateFormatter.dateFormat = dateFormatter.dateFormat + " HH:mm"
        }
        return dateFormatter
    }
    
    /// 开始结束时间的供显示的字符串
    ///
    /// - Returns: the showing string after formatter.
    func beginTimeStr() -> String {
        return getDateFormatter().string(from: (beginTime! as Date ))
    }
    func endTimeStr() -> String {
        return getDateFormatter().string(from: (endTime! as Date ))
    }
    
    // MARK: - Action.
    
    //暂时没有被调用
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
    
    func recaculateTodoValue() {
        //确保为 Todo
        guard Int(planType) == 2 else { return }
        
        var numOfDonesTodd = 0
        for item in self.subTodos! {
            if let todo = item as? SubTodo {
                if todo.value {
                    numOfDonesTodd += 1
                }
            }
        }
        tergetValue = Double(subTodos?.count ?? 0)
        value = Double(numOfDonesTodd)
    }
    
    func addSubTodo(todo: SubTodo) {
        var todoArrays = self.subTodos?.array as! [SubTodo]
        todoArrays.insert(todo, at: 0)
        self.subTodos = NSOrderedSet(array: todoArrays)

        todo.plan = self
        todo.plan?.createDate = NSDate()
    }
    
    // MARK: - Caculate Get
    
    func valueUnit() -> String {
        let valueUnit = Int(unit) != PlanValueUnit.allValues.count - 1 ?
            PlanValueUnit.allValues[Int(unit)].description :
            customUnit ?? ""
        return valueUnit
    }
}
