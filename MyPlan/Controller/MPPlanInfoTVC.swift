//
//  MPPlanInfoTVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/7/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

// 这里显示了此 ToDo 计划的所有任务

protocol MPPlanInfoTVCDelegate: class {
    func didUpdateTodo()
}

//MPTodoCell

class MPPlanInfoTVC: UITableViewController {
    
    weak var delegate: MPPlanInfoTVCDelegate?
    
    public enum PlanInfoCellIDs {
        static let todoCell = "MPTodoCell"
    }
    
    var managedObjectContext: NSManagedObjectContext?
    var plan: MPPlan!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.tableFooterView = UIView() //去掉表格视图中多余的线
        tableView.rowHeight = 50
        //Regist cell.
        let cellNib = UINib(nibName: PlanInfoCellIDs.todoCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: PlanInfoCellIDs.todoCell)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plan.subTodos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanInfoCellIDs.todoCell, for: indexPath) as! MPTodoCell
        let todo = plan.subTodos![indexPath.row] as! SubTodo
        cell.isDone = todo.value
        cell.name.text = todo.name ?? ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = plan.subTodos![indexPath.row] as! SubTodo
        todo.value = !todo.value
        todo.doneTime = NSDate()
        
        //重新排序
        let orderdTodosAry = plan.subTodos!.sorted(by: { (any1, any2) -> Bool in
            guard let todo1 = any1 as? SubTodo, let todo2 = any2 as? SubTodo else {
                return false
            }
            return !todo1.value && todo2.value
        })
        plan.subTodos = NSOrderedSet(array: orderdTodosAry)
        
        var numberOfUnselectedTodo = 0
        for item in orderdTodosAry {
            let todo = item as! SubTodo
            if !todo.value {
                numberOfUnselectedTodo += 1
            } else {
                break
            }
        }
        //        tableView.moveRow(at: indexPath, to: IndexPath(row: numberOfUnselectedTodo, section: indexPath.section))
        tableView.reloadData()
        //更新数据
        delegate?.didUpdateTodo()
        managedObjectContext?.trySave()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Delete todo
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedObjectContext?.delete(plan.subTodos![indexPath.row] as! NSManagedObject)
            
            let todos = plan.subTodos!.mutableCopy() as! NSMutableOrderedSet
            todos.remove(plan.subTodos![indexPath.row])
            plan.subTodos = todos.copy() as? NSOrderedSet
            
            managedObjectContext?.trySave()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if todos.count == 0 {  //如果没有
                tableView.reloadData()
            }
        }
    }
}

// MARK: - DZNEmptyDataSet.
extension MPPlanInfoTVC : DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "此计划没有任何任务"
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(16.0)),
                          NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "这里显示了此 ToDo 计划的所有任务"
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(14.0)),
                          NSForegroundColorAttributeName: UIColor.lightGray,
                          NSParagraphStyleAttributeName: paragraph]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
}
extension MPPlanInfoTVC : DZNEmptyDataSetDelegate {
}
