//
//  MPPlanDetailView.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/7/25.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit


class MPPlanDetailView: UIView {
    
    var delegate: MPPlanDetailViewDelegate!
    weak var plan: MPPlan!
    var viewHeight = 0.0
    
    func configureViewWithPlan() {
        fatalError("configureViewWithPlan has not been implemented")
    }
    
    func animateProgress() {
        fatalError("animateProgress has not been implemented")
    }
    
    static func planViewNibName(planType: Int) -> String {
        switch planType {
        case 0:
            return "MPPlanTypeValueView"
        case 1:
            return "MPPlanTypeTimeView"
        default:
            return "MPPlanTypeToDoView"
        }
        
    }

}
