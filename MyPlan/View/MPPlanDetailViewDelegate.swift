//
//  MPPlanDetailViewProtocol.swift
//  MyPlan
//
//  Created by SJ on 2017/7/27.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import Foundation

// 计划详情 的三种类型的 详情视图，统一的代理方法
protocol MPPlanDetailViewDelegate {
    
    func didClickedAddNewValueBtn()
    func didClickedExecutionListBtn()
    
    func didClickedAddTodoBtn()
    
    func didTapEditRemark()
}

