//
//  MPAddPlanProgressPopVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/4/5.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

protocol MPAddPlanProgressPopVCDelegate {
    func didAddExecution()
}

class MPAddPlanProgressPopVC : MPPopView {
    
    var delegate: MPAddPlanProgressPopVCDelegate!
    
    var managedObjectContext: NSManagedObjectContext!
    var plan: MPPlan!
    
    lazy var execution : Execution = {
        let execution = Execution(context: self.managedObjectContext)
        execution.date = NSDate()
        execution.value = 0
        return execution
    }()
    
    @IBOutlet weak var newValueTextField: UITextField!
    @IBOutlet weak var totalValueTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalValueTextField.text = NSString(format: "%.2f", plan.value) as String
        newValueTextField.becomeFirstResponder()
        
        totalValueTextField.text =  NSString(format: "%.2f", plan.value) as String
    }
    
    @IBAction func add(_ sender: Any) {
        view.endEditing(true)
        
        if execution.value != 0 {
            plan.addToExecutions(execution)
            plan.value += execution.value
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Error when save a new Plan, error: \(error), \(error.userInfo)")
            }
            delegate.didAddExecution()
        }
        close()
    }
}

extension MPAddPlanProgressPopVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == newValueTextField {
            let text = textField.text ?? ""
            execution.value = (text as NSString).doubleValue
            
            textField.text = NSString(format: "%.2f", execution.value) as String
            totalValueTextField.text =  NSString(format: "%.2f", execution.value + plan.value) as String
        } else if textField == totalValueTextField {
            let text = textField.text ?? ""
            let totoalValue = (text as NSString).doubleValue
            execution.value = totoalValue - plan.value
            
            newValueTextField.text = NSString(format: "%.2f", execution.value) as String
            textField.text =  NSString(format: "%.2f", execution.value + plan.value) as String
        }
    }
}
