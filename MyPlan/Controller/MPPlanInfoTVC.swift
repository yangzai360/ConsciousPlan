//
//  MPPlanInfoTVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/7/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

class MPPlanInfoTVC: UITableViewController {
    var managedObjectContext: NSManagedObjectContext?
    var plan: MPPlan!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let todos = plan.subTodos {
            return todos.count
        }
        return 0
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
        
//        tableView.beginUpdates()
//        tableView.moveRow(at: indexPath, to: IndexPath(row: numberOfUnselectedTodo, section: indexPath.section))
//        tableView.endUpdates()
        
//        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        tableView.reloadData()
        
        do {
            try managedObjectContext?.save()
        } catch let error as NSError {
            print("Error when save a new Plan, error: \(error), \(error.userInfo)")
        }
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
            
            do {
                try self.managedObjectContext?.save()
            } catch let error as NSError {
                print("error:\(errno), \(error.userInfo).")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

//extension MPPlanDetailVC: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        
//        cell.textLabel?.text = "HelloTest"
//        
//        return cell
//    }
//    
//}
