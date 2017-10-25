//
//  MPEnums.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/4/16.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import Foundation

//类型枚举
enum PlanType : String, CustomStringConvertible {
    case CountType = "定量计划"
    case TimeType = "定时任务"
    case ToDoType = "ToDo 任务"
    var description : String { return rawValue }
    static let allValues = [CountType, TimeType, ToDoType]
}

//单位枚举
enum PlanValueUnit : String, CustomStringConvertible {
    case PlanValueUnit1 = "个"
    case PlanValueUnit2 = "页"
    case PlanValueUnit3 = "次"
    case PlanValueUnit4 = "分"
    case PlanValueUnit5 = "人"
    case PlanValueUnit6 = "只"
    case PlanValueUnit7 = "条"
    case PlanValueUnit8 = "位"
    case PlanValueUnit9 = "自定义"
    var description : String { return rawValue }
    static let allValues = [PlanValueUnit1, PlanValueUnit2, PlanValueUnit3, PlanValueUnit4, PlanValueUnit5, PlanValueUnit6, PlanValueUnit7, PlanValueUnit8, PlanValueUnit9]
}

//时间单位枚举
enum PlanTimeUnit : String, CustomStringConvertible {
    //秒 分 时 天 周 月 年
    case PlanTimeUnit1 = "秒"
    case PlanTimeUnit2 = "分钟"
    case PlanTimeUnit3 = "小时"
    case PlanTimeUnit4 = "天"
    case PlanTimeUnit5 = "周"
    case PlanTimeUnit6 = "月"
    case PlanTimeUnit7 = "年"
    var description : String { return rawValue }
    static let allValues = [PlanTimeUnit1, PlanTimeUnit2, PlanTimeUnit3, PlanTimeUnit4, PlanTimeUnit5, PlanTimeUnit6, PlanTimeUnit7]
}
