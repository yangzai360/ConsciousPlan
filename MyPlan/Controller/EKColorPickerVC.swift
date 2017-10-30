//
//  EKColorPickerVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/10/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import Eureka

class EKColorPickerVC: FormViewController {
    
    var row: EKColorNormalRow?
    
    var optionsColor = [
        UIColor.init(red: 050/255, green: 191/255, blue: 254/255, alpha: 1.0), // DO blue.
        UIColor.init(red: 245/255, green: 122/255, blue: 130/255, alpha: 1.0),
        UIColor.init(red: 250/255, green: 190/255, blue: 130/255, alpha: 1.0),
        UIColor.init(red: 250/255, green: 220/255, blue: 130/255, alpha: 1.0),
        UIColor.init(red: 230/255, green: 240/255, blue: 150/255, alpha: 1.0),
        UIColor.init(red: 150/255, green: 240/255, blue: 240/255, alpha: 1.0),
        UIColor.init(red: 160/255, green: 190/255, blue: 240/255, alpha: 1.0),
        UIColor.init(red: 190/255, green: 170/255, blue: 225/255, alpha: 1.0),
        
        UIColor.init(red: 200/255, green: 190/255, blue: 160/255, alpha: 1.0),
        UIColor.init(red: 140/255, green: 110/255, blue: 085/255, alpha: 1.0),
        UIColor.init(red: 170/255, green: 075/255, blue: 075/255, alpha: 1.0),
        UIColor.init(red: 235/255, green: 190/255, blue: 180/255, alpha: 1.0),
        UIColor.init(red: 220/255, green: 190/255, blue: 110/255, alpha: 1.0),
        UIColor.init(red: 140/255, green: 140/255, blue: 100/255, alpha: 1.0),
        UIColor.init(red: 180/255, green: 200/255, blue: 190/255, alpha: 1.0),
        UIColor.init(red: 100/255, green: 095/255, blue: 120/255, alpha: 1.0),

        UIColor.init(red: 230/255, green: 200/255, blue: 160/255, alpha: 1.0),
        UIColor.init(red: 090/255, green: 080/255, blue: 075/255, alpha: 1.0),
        UIColor.init(red: 250/255, green: 180/255, blue: 005/255, alpha: 1.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
        title = "主题色"
    }
    
    func initializeForm() {
        form +++ Section() { section in
            section.header = HeaderFooterView(title: "选择主体颜色")
        }
        for option in optionsColor {
            form.last! <<< EKColorCheckRow(){
                $0.selectableValue = option
                $0.value = option == self.row?.value ? option : nil  //如果这个选项是选目前的color，那么这个的value才有值
                }.onCellSelection({ (cell, row) in
                    if let color = row.selectableValue {
                        self.row?.value = color
                        self.navigationController?.popViewController(animated: true)
                    }
                })
        }
    }
}
