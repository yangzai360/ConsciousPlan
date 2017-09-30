//
//  YZMonthGridView.swift
//  YZDatePicker
//
//  Created by Sean.Jie on 2017/8/1.
//  Copyright © 2017年 JieYang. All rights reserved.
//

import UIKit

class YZMonthGridView: UIButton {
    
    var dateComponents: DateComponents?
    
    var date: Date? {
        didSet {
//            [self.monthLabel setText:[NSString stringWithFormat:@"%ld月",dateComponents.month]];
            monthLabel!.text = "\(dateComponents!.month!)月"
            monthLabel!.sizeToFit()
            monthLabel!.center = CGPoint(x: frame.size.width/2.0, y: 12.0)
            
            configureDayGrids()
        }
    }
    
    var monthLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        monthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        monthLabel!.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(monthLabel!)
    }
    
    func configureDayGrids() {
        let todayDateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday ], from: Date())
        let numberOfMonthDay: Int = (Calendar.current.range(of: .day, in: .month, for: self.date!)?.count)!
        
        var thisMonth = false
        
        let heightLightColor = UIColor(red: 50/255, green: 191/255, blue: 254/255, alpha: 1.0) // DO blue
        
        for i in 1...numberOfMonthDay {
            dateComponents!.day = i
            
            let dayDateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth, .weekday ], from: Calendar.current.date(from: dateComponents!)!)
            
            let dayView = UIView(frame:CGRect(x: (dayDateComponents.weekday! - 1) * 6 + 4, y: (dayDateComponents.weekOfMonth! - 1) * 6 + 22, width: 5, height: 5))
            dayView.isUserInteractionEnabled = false
            if todayDateComponents.year! == dayDateComponents.year! &&
                todayDateComponents.month! == dayDateComponents.month! &&
                todayDateComponents.day! == dayDateComponents.day! {
                dayView.backgroundColor = heightLightColor
                thisMonth = true
            } else {
                dayView.backgroundColor = UIColor.lightGray
            }
            addSubview(dayView)
        }
        
        monthLabel?.textColor = thisMonth ? heightLightColor : UIColor.black
    }
    
}
