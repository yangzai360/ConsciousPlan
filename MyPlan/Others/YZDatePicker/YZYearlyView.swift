//
//  YZYearlyView.swift
//  YZDatePicker
//
//  Created by Sean.Jie on 2017/8/1.
//  Copyright © 2017年 JieYang. All rights reserved.
//

import UIKit

protocol YZYearlyViewDelegate: class {
    func didSelectMonth(_ month: Int, inYear year: Int)
}

class YZYearlyView: UIView {

    weak var delegate: YZYearlyViewDelegate?
    
    let calendar = NSCalendar.current
    var monthGridViews = [YZMonthGridView]()
    var activeDate = Date()
    
    let yearLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        let DOBlue = UIColor(red: 50/255, green: 191/255, blue: 254/255, alpha: 1.0) // DO blue
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY"
        dateFormat.locale = NSLocale.current
        yearLabel.text = dateFormat.string(from: activeDate)
        yearLabel.sizeToFit()
        yearLabel.center = CGPoint(x: frame.size.width/2.0, y: 20)
        yearLabel.textColor = DOBlue
        addSubview(yearLabel)
        
        initMonthsWithYear(year: Int(yearLabel.text!)!)
        
        let leftBtn = UIButton(frame: CGRect(x: 40, y: 10, width: 40, height: 20))
        leftBtn.setTitle("<", for: .normal)
        leftBtn.addTarget(self, action:#selector(YZYearlyView.leftBtnClicked), for:.touchUpInside)
        leftBtn.setTitleColor(DOBlue, for: .normal)
        leftBtn.center = CGPoint(x: yearLabel.center.x - 100, y: yearLabel.center.y)
        addSubview(leftBtn)
        
        let rightBtn = UIButton(frame: CGRect(x: 180, y: 10, width: 40, height: 20))
        rightBtn.setTitle(">", for: .normal)
        rightBtn.addTarget(self, action:#selector(YZYearlyView.rightBtnClicked), for:.touchUpInside)
        rightBtn.setTitleColor(DOBlue, for: .normal)
        rightBtn.center = CGPoint(x: yearLabel.center.x + 100, y: yearLabel.center.y)
        addSubview(rightBtn)
        
        let leftSwipeGesureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandle(_:)))
        leftSwipeGesureRecognizer.direction = .left
        self.addGestureRecognizer(leftSwipeGesureRecognizer)
        let rightSwipeGesureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandle(_:)))
        rightSwipeGesureRecognizer.direction = .right
        self.addGestureRecognizer(rightSwipeGesureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Target
    @objc func leftBtnClicked() {
        changeYear(changeValue: -1)
    }
    
    @objc func rightBtnClicked() {
        changeYear(changeValue: 1)
    }
    
    @objc func swipeHandle(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        if swipeGestureRecognizer.direction == .left {
            changeYear(changeValue: 1)
        } else {
            changeYear(changeValue: -1)
        }
    }
    
    func changeYear(changeValue:Int) {
        var dateComp = calendar.dateComponents([.year, .month, .day, .weekOfMonth, .weekday ] , from: activeDate)
        dateComp.year = dateComp.year! + changeValue
        activeDate = calendar.date(from: dateComp)!
        
        UIView.transition(with: self, duration: 0.5, options: changeValue > 0 ? .transitionFlipFromRight : .transitionFlipFromLeft, animations: {
            self.initMonthsWithYear(year: dateComp.year!)
        }, completion: nil)
        
        yearLabel.text = "\(dateComp.year!)"
        yearLabel.sizeToFit()
    }
    
//    MARK: - 12 Month Rect
    var monthViews = [YZMonthGridView]()
    
    func initMonthsWithYear(year: Int) {
        for view in monthViews {
            view.removeFromSuperview()
        }
        monthViews.removeAll()
        
        var dateComponents = calendar.dateComponents([.year, .month, .day, .weekOfMonth, .weekday ] , from: activeDate)
        dateComponents.year = year
        dateComponents.month = 1
        dateComponents.day = 1
        
        var monthNum = 1
        for i in 0...2 {    for j in 0...3 {
            let monthBtn = YZMonthGridView(frame: CGRect(x: j * 80 + 15, y: i * 65 + 40, width: 50, height: 60))
            monthBtn.dateComponents = dateComponents
            monthBtn.date = calendar.date(from: dateComponents)!
            monthBtn.addTarget(self, action:#selector(monthViewSelected(sender:)), for: .touchUpInside)
            monthViews.append(monthBtn)
            addSubview(monthBtn)
            dateComponents.month! += 1
            monthNum += 1
        }}
    }
    
    @objc func monthViewSelected(sender: YZMonthGridView) {
        delegate?.didSelectMonth(sender.dateComponents!.month!, inYear: sender.dateComponents!.year!)
    }
    
}
