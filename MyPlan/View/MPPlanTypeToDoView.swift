//
//  MPPlanTypeToDoView.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/7/29.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit

class MPPlanTypeToDoView: MPPlanDetailView {

    @IBOutlet weak var tintColorView: UIView!
    @IBOutlet weak var planNameLabel: UILabel!
    
//    @IBOutlet weak var containLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
//    @IBOutlet weak var progressBackView: UIView!
//    @IBOutlet weak var progressView: UIView!
//    @IBOutlet weak var progressViewWidthCons: NSLayoutConstraint!
    
//    weak override var plan: MPPlan! {
//        didSet {
//            self.progressViewWidthCons.constant = 0
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewHeight = 175.0
    }
    
    //Load Data
    override func configureViewWithPlan() {
        tintColorView.backgroundColor = plan.tintColor as? UIColor
        planNameLabel.text = plan.planName
//        containLabel.text = NSString(format: "已完成：%.2f%%", (self.plan.value/self.plan.tergetValue)*100) as String
        //        "计划进度："
        targetLabel.text = "总项目：\(plan.tergetValue)"
        valueLabel.text = "已完成：\(plan.value)"
        leftLabel.text = "剩余数：\(plan.tergetValue - plan.value)"
        timeLabel.text = "从 \(plan.beginTimeStr()) 至 \(plan.endTimeStr())"
//        progressView.backgroundColor = plan.tintColor as? UIColor
    }
    
    override func animateProgress() {
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut , animations: {
//            self.progressViewWidthCons.constant = CGFloat(Double(self.progressBackView.frame.width) * (self.plan.value/self.plan.tergetValue))
//            self.layoutIfNeeded()
//        }, completion: nil)
    }
    
    @IBAction func addNewValueBtnClicked(_ sender: Any) {
        delegate.didClickedAddTodoBtn()
    }
    
    @IBAction func executionListBtnTapped(_ sender: UIButton) {
        delegate.didClickedExecutionListBtn()
    }
    

}
