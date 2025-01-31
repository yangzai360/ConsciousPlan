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
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var remarkLabel: UILabel!
    
//    @IBOutlet weak var progressBackView: UIView!
//    @IBOutlet weak var progressView: UIView!
//    @IBOutlet weak var progressViewWidthCons: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewHeight = 217.0
    }
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(remarkViewTapped))
        tap.numberOfTapsRequired = 1
        remarkView.addGestureRecognizer(tap)
    }
    
    //Load Data
    override func configureViewWithPlan() {
//        更新Todo的数据背后的计算
        plan.recaculateTodoValue()
        
        tintColorView.backgroundColor = plan.tintColor as? UIColor
        planNameLabel.text = plan.planName
//        containLabel.text = NSString(format: "已完成：%.2f%%", (self.plan.value/self.plan.tergetValue)*100) as String
        //        "计划进度："
        
        valueLabel.setDouble(double: plan.value, count:nil)
        leftLabel.setDouble(double: plan.tergetValue - plan.value, count: nil)
        targetLabel.setDouble(double: plan.tergetValue, count: nil)
//        valueLabel.text = "\(plan.value)"
//        leftLabel.text = "\(plan.tergetValue - plan.value)"
//        targetLabel.text = "\(plan.tergetValue)"
        
        timeLabel.text = "从 \(plan.beginTimeStr()) 至 \(plan.endTimeStr())"
        
        remarkLabel.text = plan.planRemarks ?? "填写备注..."
        remarkLabel.textColor = plan.planRemarks?.count ?? 0 > 0 ? UIColor.black : UIColor.gray
        
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
    
    func remarkViewTapped() {
        delegate.didTapEditRemark()
    }
    
}
