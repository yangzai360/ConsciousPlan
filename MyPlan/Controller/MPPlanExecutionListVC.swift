
//
//  MPPlanExecutionListVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/4/6.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

class MPPlanExecutionListVC : UIViewController {
    
    // MARK: Properties
    var managedObjectContext: NSManagedObjectContext!
    var plan: MPPlan!
    
    @IBOutlet weak var tableView: UITableView!
}

// MARK: - UITableViewDataSource
extension MPPlanExecutionListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plan.executions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let execution : Execution = plan.executions![indexPath.row] as! Execution
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "executionCell")
        cell.textLabel?.text = NSString(format: "%.2f", execution.value) as String
        
        let dateFormatter = DateFormatter()
            dateFormatter.locale     = Locale(identifier: "zh")
            dateFormatter.dateStyle  = DateFormatter.Style.long
            dateFormatter.dateFormat = dateFormatter.dateFormat + " HH:mm"
        
        cell.detailTextLabel?.text = dateFormatter.string(for: execution.date) ?? ""
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
        }
    }
}
