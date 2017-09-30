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
    var planDetailTableVC :MPPlanInfoTVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAppearance(tintColor: plan.tintColor as! UIColor)
        
        //下面的列表初始化
        planDetailTableVC = MPPlanInfoTVC()
        planDetailTableVC.plan = plan
        planDetailTableVC.managedObjectContext = managedObjectContext
        addChildViewController(planDetailTableVC)
        view.addSubview(planDetailTableVC.view)
        planDetailTableVC.view.snp.makeConstraints { (make) -> Void in
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
        
        planDetailTableVC.tableView.contentInset = UIEdgeInsetsMake(CGFloat(planDetailView.viewHeight - 64.0), 0, 0, 0);
        planDetailView.alpha = 0.94
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        planDetailView.configureViewWithPlan()
        planDetailView.animateProgress()
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
        }
    }
}

extension MPPlanDetailVC : MPAddPlanProgressPopVCDelegate {
    func didAddExecution() {
        planDetailView.configureViewWithPlan()
        planDetailView.animateProgress()
    }
}

extension MPPlanDetailVC : MPAddTodoPopVCDelegate {
    func didAddTodo() {
        planDetailTableVC.tableView.reloadData()
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
}
