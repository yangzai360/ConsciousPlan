//
//  MPPlanListCell.swift
//  MyPlan
//
//  Created by jieyang on 2017/6/29.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit

class MPPlanListCell: UITableViewCell {

    @IBOutlet weak var tintColorView: UIView!

    @IBOutlet weak var planNameLabel: UILabel!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var planTypeLabel: UILabel!
    @IBOutlet weak var planTimeLabel: UILabel!
    
    @IBOutlet weak var contentCardView: UIView!
    
    @IBOutlet weak var progressBackView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewWidthCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentCardView.layer.borderWidth = 0.5
        contentCardView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
    }
    
    func configureCell(plan: MPPlan) {
        tintColorView.backgroundColor = plan.tintColor as? UIColor
        planNameLabel.text = plan.planName
        
        progressView.backgroundColor = plan.tintColor as? UIColor
        
        if plan.tergetValue == 0 {
            progressLabel.text = "已完成: 0.00%"
            progressViewWidthCons.constant = 0
        } else {
            progressLabel.text = NSString(format:"已完成: %.2f%%", (plan.value/plan.tergetValue)*100) as String
            progressViewWidthCons.constant = CGFloat(Double(progressBackView.frame.width) * (plan.value/plan.tergetValue))
        }
        
        planTypeLabel.text = PlanType.allValues[Int(plan.planType)].description
        planTimeLabel.text = plan.beginTimeStr() + " - " + plan.endTimeStr()
    }
    
}
