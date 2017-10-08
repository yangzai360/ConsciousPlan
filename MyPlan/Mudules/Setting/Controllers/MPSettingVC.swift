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
            let header = HeaderFooterView<UIView>(.callback({ return UIView(frame: CGRect()) }))
            section.header = header
        }

        form +++ Section () { section in
            var header = HeaderFooterView<UIView>(.callback({
                let view = Bundle.main.loadNibNamed("MPSettingHeaderView", owner: nil, options: nil)?.first! as! UIView
                return view
            }))
            header.height = {160.0}
            section.header = header
            }
            
            <<< EKSettingSelectRow("技术支持") {
//                $0.title = "计划名称"
                $0.value = $0.tag
                }.onChange{ row in
        }
        
        form +++ Section("")
            <<< ButtonRow("推荐给朋友") {
                    $0.title = $0.tag
            }
        
    }
}
