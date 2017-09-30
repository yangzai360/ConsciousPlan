//
//  YZMonthView.swift
//  YZDatePicker
//
//  Created by Sean.Jie on 2017/8/5.
//  Copyright © 2017年 JieYang. All rights reserved.
//

import UIKit

protocol YZMonthViewDelegate: class {
    func didTouchMonthButton()
    func didUpdateActiveDate()
}

//获取每个日期格子的颜色数组
protocol YZMonthViewDataSource: class {
    func colorAryInDate(date: Date) -> [UIColor]
}

class YZMonthView: UIView{
    weak var delegate: YZMonthViewDelegate?
    weak var dataSource : YZDatePickerControllerDataSource? {
        didSet {
            initDays()
        }
    }

    let calendar = NSCalendar.current
    //    var monthGridViews = [YZMonthGridView]()
    
    var activeDate = Date() {
        didSet {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY年MM月"
            dateFormat.locale = NSLocale.current
            monthLabel.setTitle(dateFormat.string(from: activeDate), for: .normal)
            monthLabel.sizeToFit()
            monthLabel.center = CGPoint(x: frame.size.width/2.0, y: 20)
        }
    }
    
    let monthLabel = UIButton()
    
    var dayGridViews = [YZDayGridView]()
    var heightLightDayGrid : YZDayGridView?
    
    let heightLightColor = UIColor(red: 50/255, green: 191/255, blue: 254/255, alpha: 1.0) // DO blue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.yellow //Debug
        self.clipsToBounds = true
        
        let DOBlue = UIColor(red: 50/255, green: 191/255, blue: 254/255, alpha: 1.0) // DO blue
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY年MM月"
        dateFormat.locale = NSLocale.current
        monthLabel.setTitle(dateFormat.string(from: activeDate), for: .normal)
        monthLabel.sizeToFit()
        monthLabel.center = CGPoint(x: frame.size.width/2.0, y: 20)
        monthLabel.setTitleColor(DOBlue, for: .normal)
        monthLabel.addTarget(self, action:#selector(monthBtnClicked), for:.touchUpInside)
        addSubview(monthLabel)
        
        //Add monday to sunday
        let weekStrArray = ["日", "一", "二", "三", "四", "五", "六"]
        for i in 0 ..< 7 {
            let weekLabel = UILabel(frame: CGRect(x: i * 46, y: 30, width: 45, height: 20))
            weekLabel.text = weekStrArray[i]
            weekLabel.font = UIFont.systemFont(ofSize: 11.0)
            weekLabel.textAlignment = .center
            //            weekLabel.textColor = (i == 0 || i == 6) ? DOBlue : UIColor.black
            weekLabel.textColor = UIColor.lightGray
            addSubview(weekLabel)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func monthBtnClicked() {
        delegate?.didTouchMonthButton()
    }
    
    func initDays() {
        for view in dayGridViews {
            view.removeFromSuperview()
        }
        dayGridViews.removeAll()
        
        var monthDateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday], from: activeDate)
        let numberOfMonthDay: Int = (Calendar.current.range(of: .day, in: .month, for: activeDate)?.count)!
        
        let todayComp = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday], from: Date())
        var hasToday = false
        for i in 1...numberOfMonthDay {
            monthDateComponents.day = i
            let iDayComp = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday], from: Calendar.current.date(from: monthDateComponents)!)
            let dayGridView = YZDayGridView(frame: CGRect(x: (iDayComp.weekday! - 1) * 46, y: (iDayComp.weekOfMonth! - 1) * 36 + 50, width: 45, height: 35))
            dayGridView.layer.cornerRadius = 3.0
            dayGridView.year = iDayComp.year!
            dayGridView.month = iDayComp.month!
            dayGridView.day = iDayComp.day!
            dayGridView.date = Calendar.current.date(from: iDayComp)!
            dayGridView.dayLabel?.text = "\(i)"
            
            dayGridView.dataSource = self
            dayGridView.addTarget(self, action:#selector(dayViewSelected(sender:)), for: .touchUpInside)
            
            if todayComp.year! == iDayComp.year! &&
                todayComp.month! == iDayComp.month! &&
                todayComp.day! == iDayComp.day! {
                dayGridView.dayLabel?.textColor = heightLightColor
                heightLightDayGrid = dayGridView
                hasToday = true
            } else {
                dayGridView.dayLabel?.textColor = UIColor.black
            }
            addSubview(dayGridView)
            dayGridViews.append(dayGridView)
        }
        
        if !hasToday {
            heightLightDayGrid = dayGridViews.first!
            
            heightLightDayGrid?.backgroundColor = UIColor.black
            heightLightDayGrid?.dayLabel?.textColor = UIColor.white
        } else {
            heightLightDayGrid?.backgroundColor = heightLightColor
            heightLightDayGrid?.dayLabel?.textColor = UIColor.white
        }
        delegate?.didUpdateActiveDate()
    }
    
    func dayViewSelected(sender: YZDayGridView) {
        let todayComp = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday], from: Date())
        
        heightLightDayGrid?.backgroundColor = UIColor.clear
        
        if todayComp.year! == heightLightDayGrid!.year! &&
            todayComp.month! == heightLightDayGrid!.month! &&
            todayComp.day! == heightLightDayGrid!.day! {
            heightLightDayGrid?.dayLabel?.textColor = heightLightColor
        } else {
            heightLightDayGrid?.dayLabel?.textColor = UIColor.black
        }
        
        heightLightDayGrid = sender
        
        if todayComp.year! == sender.year! &&
            todayComp.month! == sender.month! &&
            todayComp.day! == sender.day! {
            heightLightDayGrid?.backgroundColor = heightLightColor
            heightLightDayGrid?.dayLabel?.textColor = UIColor.white
        } else {
            heightLightDayGrid?.backgroundColor = UIColor.black
            heightLightDayGrid?.dayLabel?.textColor = UIColor.white
        }
        
        var newDateComp = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday], from: activeDate)
        newDateComp.year = sender.year!
        newDateComp.month = sender.month!
        newDateComp.day = sender.day!
        
        activeDate = Calendar.current.date(from: newDateComp)!
        delegate?.didUpdateActiveDate()
    }
}

extension YZMonthView: YZDatePickerControllerDataSource {
    func colorAryInDate(date: Date) -> [UIColor] {
        return dataSource!.colorAryInDate(date:date)
    }

}
