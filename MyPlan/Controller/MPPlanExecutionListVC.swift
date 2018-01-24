
//
//  MPPlanExecutionListVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/4/6.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class MPPlanExecutionListVC : UIViewController {
    
    // MARK: Properties
    var managedObjectContext: NSManagedObjectContext!
    var plan: MPPlan!
    
    @IBOutlet weak var tableView: UITableView!
    
    public enum PlanExecutionCellIs {
        static let executionCell = "MPExecutionCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.tableFooterView = UIView() //去掉表格视图中多余的线
        
        tableView.rowHeight = 50
        //Regist cell.
        let cellNib = UINib(nibName: PlanExecutionCellIs.executionCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: PlanExecutionCellIs.executionCell)
    }
}

// MARK: - UITableViewDataSource
extension MPPlanExecutionListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plan.executions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let execution : Execution = plan.executions![indexPath.row] as! Execution
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanExecutionCellIs.executionCell, for: indexPath) as! MPExecutionCell
        let valueUnit = plan.valueUnit()  //单位，选择的或者自定义的
        cell.executionLabel.setDouble(double: execution.value, count: valueUnit)
        
        let dateFormatter = DateFormatter()
            dateFormatter.locale     = Locale(identifier: "zh")
            dateFormatter.dateStyle  = DateFormatter.Style.long
            dateFormatter.dateFormat = dateFormatter.dateFormat + " HH:mm"
        
        cell.timeLabel.text = dateFormatter.string(for: execution.date) ?? ""
        return cell
    }
}

extension MPPlanExecutionListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Delete execution row and data.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteExecutionItem = plan.executions![indexPath.row] as! Execution
            plan.value -= deleteExecutionItem.value
            plan.removeFromExecutions(at: indexPath.row)
            managedObjectContext.trySave()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if plan.executions?.count == 0 {  //如果没有
                tableView.reloadData()
            }
        }
    }
}

// MARK: - DZNEmptyDataSet.
extension MPPlanExecutionListVC : DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "此计划没有执行记录"
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(16.0)),
                          NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "这里显示了此计划的所有执行记录"
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14.0)),
                          NSForegroundColorAttributeName: UIColor.lightGray,
                          NSParagraphStyleAttributeName: paragraph]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
extension MPPlanExecutionListVC : DZNEmptyDataSetDelegate {
}
