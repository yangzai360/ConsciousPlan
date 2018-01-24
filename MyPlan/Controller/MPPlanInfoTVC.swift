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

class MPPlanInfoTVC: UITableViewController, MPTodoCellDelegate, MPTodoTagCellDelegate {
    
    weak var delegate: MPPlanInfoTVCDelegate?
    
    var isShowSeletedTodos = false
    
    public enum PlanInfoCellIDs {
        static let todoCell = "MPTodoCell"
        static let tagCell = "MPTodoTagCell"
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
        var cellNib = UINib(nibName: PlanInfoCellIDs.todoCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: PlanInfoCellIDs.todoCell)
        cellNib = UINib(nibName: PlanInfoCellIDs.tagCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: PlanInfoCellIDs.tagCell)
        
        prepareData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if selectedTodos.count == 0 {
            return 1
        }
        return isShowSeletedTodos ? 3 : 2
    }
    
    // MARK: -  UITableView Data Source.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        如果有数据，那就返回数据 +1，否则返回 0
        if section == 0 {
//            return plan.subTodos?.count ?? 0
            return self.unselectedTodos.count
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return isShowSeletedTodos ? self.selectedTodos.count : 0
        }
        return 0
    }
    
    func todoForIndexPath(indexPath: IndexPath) -> SubTodo? {
        if indexPath.section == 0 {
            return unselectedTodos[indexPath.row]
        } else if indexPath.section == 1 {
            return nil
        } else if indexPath.section == 2 {
            return selectedTodos[indexPath.row]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let todo = todoForIndexPath(indexPath: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlanInfoCellIDs.todoCell, for: indexPath) as! MPTodoCell
            cell.delegate = self
            cell.conigureCell(withToDo: todo)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlanInfoCellIDs.tagCell, for: indexPath) as! MPTodoTagCell
            cell.delegate = self
            cell.tagButton.setTitle("\(isShowSeletedTodos ? "隐藏" : "显示")已完成任务(\(selectedTodos.count)个已完成)", for: .normal)
            cell.setTagColor(color: plan.tintColor as! UIColor)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return false }
        return true
    }
    
    // MARK: -  UITableView Delegate.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func didSelectTodoCell(sender: MPTodoCell) {
        let indexPath = tableView.indexPath(for: sender)!
        guard let todo = todoForIndexPath(indexPath: indexPath) else {
            return
        }
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
        
        managedObjectContext?.trySave()
        //更新数据
        delegate?.didUpdateTodo()
        
        prepareData()
        if todo.value {
            //上面删
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            if selectedTodos.count == 1 { //如果第一个完成项出现的话，加中间的 Section
                tableView.insertSections([1], with: .fade)
                if isShowSeletedTodos { //加中间Section的时候，如果下面打开，也插入下面的 Section
                    tableView.insertSections([2], with: .fade)
                }
            } else if isShowSeletedTodos { //正常完成添加，下面首行插入。并刷新中间的section
                tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
                tableView.insertRows(at: [IndexPath(row: 0, section: 2)], with: .fade)
            } else {
                //不是第一个添加，中间的section存在，刷新中间的section
                tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
            }
            tableView.endUpdates()
        } else {
            //下面删
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [IndexPath(row: unselectedTodos.count-1, section: 0)], with: .fade)
            if selectedTodos.count == 0 { // 下面删完了，1、2两个section删掉
                tableView.deleteSections([1,2], with: .fade)
            } else { //正常删除，刷新中间的section
                tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
            }
            tableView.endUpdates()
        }
    }
    
    func didClickTagButton() {
        isShowSeletedTodos = !isShowSeletedTodos
        if isShowSeletedTodos {
            tableView.insertSections([2], with: .middle)
        } else {
            tableView.deleteSections([2], with: .middle)
        }
        tableView.reloadRows(at:[IndexPath(row: 0, section: 1)], with: .fade)
    }
    
    // Delete todo
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let todo = todoForIndexPath(indexPath: indexPath) else {
                return //  // 不可能到这里
            }
            managedObjectContext?.delete(todo)
            
            let todos = plan.subTodos!.mutableCopy() as! NSMutableOrderedSet
            todos.remove(todo)
            
            plan.subTodos = todos.copy() as? NSOrderedSet
            managedObjectContext?.trySave()
            
            prepareData()
            
            tableView.beginUpdates()
            if selectedTodos.count == 0 && indexPath.section == 2 {         //加入 section 的判断，如果是删除第一行的时候，不删除后面两个 section
                tableView.deleteSections([1,2], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            tableView.endUpdates()
            
            if todos.count == 0 {  //如果没有，刷出 EmptySet 页面
                tableView.reloadEmptyDataSet()
            }
            delegate?.didUpdateTodo()
        }
    }
    
    //动画方法
    func insertNewTodoAnimation() {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        if plan.subTodos?.count == 1 {
            tableView.reloadEmptyDataSet()
        }
    }
    
    // MARK: - 整理数据的方法
    var unselectedTodos = [SubTodo]()       // 待完成的 Todo
    var selectedTodos = [SubTodo]()         // 已完成的 Todo
    func prepareData() {
        unselectedTodos.removeAll()
        selectedTodos.removeAll()
        let todos = self.plan.subTodos!.array as! [SubTodo]
        for todo in todos {
            if todo.value {
                selectedTodos.append(todo)
            } else {
                unselectedTodos.append(todo)
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
