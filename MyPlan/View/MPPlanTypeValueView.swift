//
//  MPPlanTypeValueView.swift
//  MyPlan
//
//  Created by SJ on 2017/7/27.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit

class MPPlanTypeValueView: MPPlanDetailView {
    
    @IBOutlet weak var tintColorView: UIView!
    @IBOutlet weak var planNameLabel: UILabel!
    
    @IBOutlet weak var containLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var remarkLabel: UILabel!
    
    @IBOutlet weak var progressBackView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewWidthCons: NSLayoutConstraint!
    
    weak override var plan: MPPlan! {
        didSet {
            self.progressViewWidthCons.constant = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewHeight = 250.0
    }
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(remarkViewTapped))
        tap.numberOfTapsRequired = 1
        remarkView.addGestureRecognizer(tap)
    }
    
    //Load Data
    override func configureViewWithPlan() {
        tintColorView.backgroundColor = plan.tintColor as? UIColor
        planNameLabel.text = plan.planName
        containLabel.text = NSString(format: "总进度：%.2f%%", (self.plan.value/self.plan.tergetValue)*100) as String

        let valueUnit = plan.valueUnit()  //单位，选择的或者自定义的
        
        targetLabel.setDouble(double: plan.tergetValue, count: valueUnit)
        valueLabel.setDouble(double: plan.value, count: valueUnit)
        leftLabel.setDouble(double: plan.tergetValue - plan.value, count: valueUnit)
        
//        targetLabel.text = "\(plan.tergetValue) " + valueUnit
//        valueLabel.text = "\(plan.value) " + valueUnit
//        leftLabel.text = "\(plan.tergetValue - plan.value) " + valueUnit

        timeLabel.text = "从 \(plan.beginTimeStr()) 至 \(plan.endTimeStr())"
        
        remarkLabel.text = plan.planRemarks?.count ?? 0 > 0 ? plan.planRemarks! : "请填写备注..."
        remarkLabel.textColor = plan.planRemarks?.count ?? 0 > 0 ? UIColor.black : UIColor.gray
        
        progressView.backgroundColor = plan.tintColor as? UIColor
    }

    override func animateProgress() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut , animations: {
            self.progressViewWidthCons.constant = CGFloat(Double(self.progressBackView.frame.width) * (self.plan.value/self.plan.tergetValue))
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func addNewValueBtnClicked(_ sender: Any) {
        delegate.didClickedAddNewValueBtn()
    }
    
    @IBAction func executionListBtnTapped(_ sender: UIButton) {
        delegate.didClickedExecutionListBtn()
    }
    
    func remarkViewTapped() {
        delegate.didTapEditRemark()
    }
    
}
