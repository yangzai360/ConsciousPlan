//
//  MPPlanInfoTVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/7/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

protocol MPPlanInfoTVCDelegate: class {
    func didUpdateTodo()
}

class MPPlanInfoTVC: UITableViewController {
    
    weak var delegate: MPPlanInfoTVCDelegate?

    var managedObjectContext: NSManagedObjectContext?
    var plan: MPPlan!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plan.subTodos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none

        let todo = plan.subTodos![indexPath.row] as! SubTodo
        cell.textLabel?.text = todo.name ?? ""
        cell.accessoryType =  todo.value ? .checkmark : .none
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
        }
    }
}
