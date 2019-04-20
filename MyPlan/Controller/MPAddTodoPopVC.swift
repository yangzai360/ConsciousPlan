//
//  MPAddTodoPopVC.swift
//  MyPlan
//
//  Created by jieyang on 2017/9/8.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

protocol MPAddTodoPopVCDelegate: class {
    func didAddTodo(todo: SubTodo)
}

class MPAddTodoPopVC: MPPopView {
    
    weak var delegate: MPAddTodoPopVCDelegate?
    
    var managedObjectContext: NSManagedObjectContext!
    var plan: MPPlan!
    
    lazy var newTodo : SubTodo = {
        let todo = SubTodo(context: self.managedObjectContext)
        todo.name = ""
        todo.createTime = NSDate()
        todo.value = false
        return todo
    }()
    
    @IBOutlet weak var nameTextField: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
        nameTextField.text = ""
    }
    
    @IBAction func add(_ sender: Any) {
        nameTextField.endEditing(true)
        
        if nameTextField.text!.count > 0 {
            newTodo.name = nameTextField.text!
            plan.addSubTodo(todo: newTodo)
            managedObjectContext.trySave()
            
            delegate?.didAddTodo(todo: newTodo)
        }
        close()
    }
}
