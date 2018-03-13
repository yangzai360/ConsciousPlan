//
//  MPPlanDetailVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/4/1.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

class MPPlanDetailVC : UIViewController {
    
    // MARK: Properties
    var managedObjectContext: NSManagedObjectContext?
    var plan: MPPlan!
    var planDetailView: MPPlanDetailView!
    
    let remarkSegue = "planRemarksSegue"
    
    //下面的列表
    var planDetailTableVC :MPPlanInfoTVC?
    var planExecutionListVC :MPPlanExecutionListVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAppearance(tintColor: plan.tintColor as! UIColor)
        
        let planDetailTVC : UIViewController! // 下面就直接赋值，所以保证 !
        
        // 根据两个不同的 计划类型，下面显示不同的进度，ToDo就显示项目，剩下的两个类型，显示 添加记录
        if (Int(plan.planType) ==  2) {
            //下面的列表初始化
            let planDetailTableVC = MPPlanInfoTVC()
            planDetailTableVC.delegate = self
            self.planDetailTableVC = planDetailTableVC
            planDetailTVC = planDetailTableVC
            planDetailTableVC.plan = plan
            planDetailTableVC.managedObjectContext = managedObjectContext
        } else {
            let planExexutionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MPPlanExecutionListVC") as! MPPlanExecutionListVC
            self.planExecutionListVC = planExexutionsVC
            planDetailTVC = planExexutionsVC
            planExexutionsVC.plan = plan
            planExexutionsVC.managedObjectContext = managedObjectContext!
        }
        
        addChildViewController(planDetailTVC)
        view.addSubview(planDetailTVC.view)
        planDetailTVC.view.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
//            make.top.equalTo(planDetailView.snp.bottom)
            make.top.equalTo(self.view).offset(64)
            make.bottom.equalTo(self.view)
            make.centerX.equalTo(self.view)
        }
        
        let nibName = MPPlanDetailView.planViewNibName(planType: Int(plan.planType))
        planDetailView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first! as! MPPlanDetailView
        
        planDetailView.delegate = self
        planDetailView.plan = self.plan
        view.addSubview(planDetailView)
        planDetailView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(planDetailView.viewHeight)
            make.top.equalTo(self.view).offset(64)
            make.centerX.equalTo(self.view)
        }
        planDetailView.configureViewWithPlan()
        
        if (Int(plan.planType) ==  2) {
            planDetailTableVC!.tableView.contentInset = UIEdgeInsetsMake(CGFloat(planDetailView.viewHeight), 0, 0, 0);
        } else {
            planExecutionListVC!.tableView.contentInset = UIEdgeInsetsMake(CGFloat(planDetailView.viewHeight), 0, 0, 0);
        }
        planDetailView.alpha = 0.94
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 动画的方式更新样式颜色
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut , animations: {
            //因为左滑手势的原因，如果画了一半没有退出，再次更新一个 Navigator 的Appearance
            self.updateAppearance(tintColor: self.plan.tintColor as! UIColor)
            self.planDetailView.configureViewWithPlan()
        }, completion: nil)
        planDetailView.animateProgress()
        
        if (Int(plan.planType) ==  2) {
//            planDetailTableVC!.tableView.reloadData()
        } else {
            planExecutionListVC!.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addExecutionPop = segue.destination as? MPAddPlanProgressPopVC {
            addExecutionPop.delegate = self
            addExecutionPop.managedObjectContext = managedObjectContext!
            addExecutionPop.plan = plan!
        } else if let executionListVC  = segue.destination as? MPPlanExecutionListVC {
            executionListVC.managedObjectContext = managedObjectContext!
            executionListVC.plan = plan!
        } else if let addTodoVC = segue.destination as? MPAddTodoPopVC {
            addTodoVC.managedObjectContext = managedObjectContext!
            addTodoVC.delegate = self
            addTodoVC.plan = plan!
        } else if let addTodoVC = segue.destination as? MPPlanRemarkVC {
            addTodoVC.managedObjectContext = managedObjectContext!
            addTodoVC.plan = plan!
        }
        
        //编辑计划
        if let navController = segue.destination as? UINavigationController,
            let viewController = navController.topViewController as? MPCreatePlanVC {
            viewController.plan = self.plan
            viewController.managedObjectContext = managedObjectContext!
        }
    }
}

extension MPPlanDetailVC : MPAddPlanProgressPopVCDelegate {
    func didAddExecution() {
        planDetailView.configureViewWithPlan()
        planDetailView.animateProgress()
        planDetailTableVC?.tableView.reloadData()
        planExecutionListVC?.tableView.reloadData()
    }
}

extension MPPlanDetailVC : MPAddTodoPopVCDelegate, MPPlanInfoTVCDelegate {
    func didAddTodo(todo: SubTodo) {
        // ToDo 点击添加 ToDo 之后的操作 （肯定存在 planDetailTableVC）
        planDetailTableVC?.prepareData()
        planDetailTableVC?.insertNewTodoAnimation()
        planDetailView.configureViewWithPlan() // 更新上面的页面
    }
    
    func didUpdateTodo() {
        planDetailView.configureViewWithPlan()
    }
}

extension MPPlanDetailVC : MPPlanDetailViewDelegate {
    func didClickedAddNewValueBtn() {
        performSegue(withIdentifier: "addNewValueSegue", sender: nil)
    }
    
    func didClickedAddTodoBtn() {
        performSegue(withIdentifier: "addTodoSegue", sender: nil)
    }
    
    func didClickedExecutionListBtn() {
        performSegue(withIdentifier: "planExecutionListSegue", sender: nil)
    }
    
    func didTapEditRemark() {
        performSegue(withIdentifier: "planRemarksSegue", sender: nil)
    }
}
