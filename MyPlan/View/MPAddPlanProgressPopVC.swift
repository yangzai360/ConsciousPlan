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
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countLabel2: UILabel!
    
    
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
        
        //设置单位
        countLabel.text = self.plan.valueUnit()
        countLabel2.text = countLabel.text
        
        totalValueTextField.text = NSString(format: "%.2f", plan.value) as String
        newValueTextField.becomeFirstResponder()
        
        totalValueTextField.text =  NSString(format: "%.2f", plan.value) as String
        
    }
    
    @IBAction func add(_ sender: Any) {
        view.endEditing(true)
        
        if execution.value != 0 {
            plan.addToExecutions(execution)
            plan.value += execution.value
            
            managedObjectContext.trySave()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        //实现动态显示另一个数据
        if textField == newValueTextField {
            totalValueTextField.text =  NSString(format: "%.2f", (Double(newText) ?? 0.00) + plan.value) as String
        } else if textField == totalValueTextField {
            newValueTextField.text = NSString(format: "%.2f", (Double(newText) ?? 0.00) - plan.value) as String
        }
        return true
    }
}
