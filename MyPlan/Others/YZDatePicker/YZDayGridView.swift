//
//  YZDayGridView.swift
//  YZDatePicker
//
//  Created by Sean.Jie on 2017/8/6.
//  Copyright © 2017年 JieYang. All rights reserved.
//

import UIKit

// width: 45, height: 35

class YZDayGridView: UIButton {
    
    var dataSource : YZDatePickerControllerDataSource! {
        didSet {
            initColorGrids()
        }
    }
    
    var dayLabel : UILabel?
    
    var date: Date?
    var year: Int?
    var month: Int?
    var day: Int?
    
    var color: [UIColor]?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 28, height: 16))
        dayLabel!.textAlignment = .center
        dayLabel?.center = CGPoint(x: frame.size.width/2, y: 8 + 4)
        dayLabel!.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(dayLabel!)
    }
    
    func initColorGrids() {
        //Clear 
        for i in 17 ... 21 {
            viewWithTag(i)?.removeFromSuperview()
        }
        
        let s = frame.size.width / 12.0   // S代表每个单位点的位置  按照如下阵列来排列5个点
        /*
        0 1 2 3 4 5 6 7 8 9 0 1 2
        1           6
        2         5   7
        3       4   6   8
        4     3   5   7   9
        5   2   4   6   8   0
        */
        let colors = dataSource.colorAryInDate(date: date!)
        var i = 0
        for color in colors {
            if i >= 5 { break }  //最多只显示 5 个点
            
            let colorView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 3.0
            colorView.tag = 17 + i
            colorView.center = CGPoint(x: s * (6.0 + 2.0 * CGFloat(i) - CGFloat(colors.count - 1)), y: 35 - 7)
            addSubview(colorView)
            i += 1
        }
    }
}
