//
//  YZDatePickerController.swift
//  YZDatePicker
//
//  Created by Sean.Jie on 2017/8/1.
//  Copyright © 2017年 JieYang. All rights reserved.
//

import UIKit

protocol YZDatePickerControllerDelegate: class {
    func datePickerDidUpdateActiveDate(date: Date)
}

//获取每个日期格子的颜色数组
protocol YZDatePickerControllerDataSource: class {
    func colorAryInDate(date: Date) -> [UIColor]
}

/**    日期选择器 的 ViewController
 */

class YZDatePickerController: UIViewController, YZYearlyViewDelegate, YZMonthViewDelegate{
    
    weak var delegate: YZDatePickerControllerDelegate? {
        didSet {
            delegate?.datePickerDidUpdateActiveDate(date: activeDate)
        }
    }
    weak var dataSource: YZDatePickerControllerDataSource? {
        didSet {
            monthView.dataSource = self
        }
    }
    
    var yearlyView: YZYearlyView!
    var monthView: YZMonthView!
    var activeDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearlyView = YZYearlyView(frame: CGRect(x: 0, y: 0, width: 320, height: 270))
        yearlyView.alpha = 0
        yearlyView.delegate = self
        view.addSubview(yearlyView)
        
        monthView = YZMonthView(frame: CGRect(x: 0, y: 0, width: 320, height: 270))
        monthView.alpha = 1
        monthView.delegate = self
        monthView.activeDate = activeDate
        view.addSubview(monthView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        yearlyView.center = CGPoint(x: view.frame.size.width/2, y:yearlyView.center.y)
        monthView.center = CGPoint(x: view.frame.size.width/2, y:yearlyView.center.y)
        
        //如果可以的话，刷新所有日，更新一下点的数量
        if monthView.dataSource != nil {
            monthView.initDays()
        }
    }
    
    //delegate 跟新月视图的数据
    func didSelectMonth(_ month: Int, inYear year: Int) {
        var dateCom = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday ], from: Date())
        
        //如果是今天，那么还是初始化为今天
        if dateCom.year! == year && dateCom.month! == month {
            monthView.activeDate = Date()
        } else {
            dateCom.year = year
            dateCom.month = month
            dateCom.day = 1
            let activeDate = Calendar.current.date(from: dateCom)
            monthView.activeDate = activeDate!
        }
        monthView.initDays()
        
        //从年份换到月份的动画
        UIView.animate(withDuration: 0.5) { [weak self] in
            self!.monthView.alpha = 1
            self!.yearlyView.alpha = 0
        }
    }
    
    func didTouchMonthButton() {
        //从月份换到年份的动画
        UIView.animate(withDuration: 0.5) { [weak self] in
            self!.monthView.alpha = 0
            self!.yearlyView.alpha = 1
        }
    }
    
    func didUpdateActiveDate() {
        let newDate = monthView.activeDate
//        var newDateCom = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday ], from: newDate)
//        print("\(newDateCom.year!)/\(newDateCom.month!)/\(newDateCom.day!)")
        if delegate != nil {
            delegate?.datePickerDidUpdateActiveDate(date: newDate)
        }
    }
}

extension YZDatePickerController: YZDatePickerControllerDataSource {
    func colorAryInDate(date: Date) -> [UIColor] {
        return dataSource!.colorAryInDate(date: date)
    }
}
