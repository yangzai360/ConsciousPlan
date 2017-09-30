//
//  MPSettingVC.swift
//  MyPlan
//
//  Created by jieyang on 17/3/29.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import Eureka

class MPSettingVC : FormViewController {
    
    @IBAction func doneItemBtnClicked(_ sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initializeForm()
    }
    
    func initializeForm() {
        form +++ Section () { section in
            var header = HeaderFooterView<UIView>(.nibFile(name: "MPSettingHeaderView", bundle: nil))
            section.header = header
        }
    }
}
