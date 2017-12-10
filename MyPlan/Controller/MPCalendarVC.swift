//
//  MPCalendarVC.swift
//  MyPlan
//
//  Created by SJ on 2017/8/9.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

class MPCalendarVC: UIViewController, YZDatePickerControllerDelegate, YZDatePickerControllerDataSource {
    // UI
    var datePickerController = YZDatePickerController()
    var calendarListTVC :MPCalendarListTVC!
    
    var managedObjectContext: NSManagedObjectContext?
    // 获取的所有的执行记录
    var fetchResult : [Execution]!
    // 所有结果的分类
    var fetchResultDict : [Int: [Execution]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.coreDataStack.managedContext
        
        prepareExecutionsData()
        addSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Tint color.
        updateAppearance(tintColor: self.defaultTintColor())
        prepareExecutionsData()
    }
    
    func addSubViews() {
        // Add Subview
        calendarListTVC = MPCalendarListTVC()
        view.addSubview(calendarListTVC.view)
        
        addChildViewController(datePickerController)
        datePickerController.view.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.size.width, height: 270)
        datePickerController.delegate = self
        datePickerController.dataSource = self
        view.addSubview(datePickerController.view)
        datePickerController.view.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.top.equalTo(self.view).offset(64)
            make.height.equalTo(270)
            make.centerX.equalTo(self.view)
        }
        
        datePickerController.view.backgroundColor = UIColor(red: 0.9922, green: 0.9922, blue: 0.9922, alpha: 1.0)

        let line = UIView()
        line.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.equalTo(self.datePickerController.view.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        calendarListTVC.view.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(line.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    func prepareExecutionsData() {
        let fetchRequest = NSFetchRequest<Execution>(entityName: "Execution")
        do {
            fetchResult = try managedObjectContext?.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("number of execution is \(fetchResult.count)")
        
        // 一遍循环 进行 分类
        fetchResultDict = [Int: [Execution]]()
        for execution in fetchResult {
            guard execution.plan != nil else {  // 过滤掉没有 计划 的执行结果
                continue
            }
            
            if var executionsAry = fetchResultDict[execution.dateFormatterIntKey()] {
                executionsAry.append(execution)
                fetchResultDict[execution.dateFormatterIntKey()] = executionsAry  // 有没有必要回写
            } else {
                var newExecutions = [Execution]()
                newExecutions.append(execution)
                fetchResultDict[execution.dateFormatterIntKey()] = newExecutions
            }
        }
    }
    
    func datePickerDidUpdateActiveDate(date: Date) {
        print("New date is \(date)")
        let executionDate = Int(Execution.dayDateFormatter().string(from: date))
        calendarListTVC.showResult = fetchResultDict[executionDate!] ?? []
        calendarListTVC.delegate = self
    }
    
    func colorAryInDate(date: Date) -> [UIColor] {
        let executionDate = Int(Execution.dayDateFormatter().string(from: date))
        let executionResults = fetchResultDict[executionDate!]
        var colors = [UIColor]()
        
        if executionResults != nil {
            for execution in executionResults! {
                    colors.append((execution.plan!.tintColor as? UIColor)!)
            }
        }
        return colors
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let planDetailVC = segue.destination as? MPPlanDetailVC {
            planDetailVC.managedObjectContext = managedObjectContext
            planDetailVC.plan = sender as? MPPlan
        }
    }
}

extension MPCalendarVC : MPCalendarListTVCDelegate {
    func didSelectPlan(plan: MPPlan) {
        self.performSegue(withIdentifier:"planDetailSegue", sender: plan)
    }
}
