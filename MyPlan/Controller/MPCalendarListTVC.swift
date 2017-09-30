//
//  MPCalendarListTVC.swift
//  MyPlan
//
//  Created by SJ on 2017/8/9.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit

class MPCalendarListTVC: UITableViewController {
    //目前要展示的
    var showResult : [Execution]! = [Execution]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        let cellNib = UINib(nibName: CalendarListCellIDs.executionCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CalendarListCellIDs.executionCell)
    }
    
    func loadDataWithDate(activeDate: Date) {
//        let executionDate = Int(Execution.dayDateFormatter().string(from: activeDate))
//        showResult = fetchResultDict[executionDate!] ?? []
//        tableView.reloadData()
    }
    
    
    struct CalendarListCellIDs {
        static let executionCell = "MPCalendarExecutionCell"
        //        static let noPlanCell = "NothingFoundCell"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showResult.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarListCellIDs.executionCell, for: indexPath) as! MPCalendarExecutionCell
        
        cell.selectionStyle = .none
        let execution = showResult[indexPath.row]
        
        let tintColor = execution.plan!.tintColor as? UIColor
        
        cell.tintColorView.backgroundColor = tintColor!
        cell.valueLabel.textColor = tintColor!
        
        cell.planNameLabel.text = execution.plan!.planName!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        cell.executionDateLabel.text = dateFormatter.string(from: execution.date as! Date)
        
        cell.valueLabel.text = execution.value > 0 ? "+ \(execution.value)" : "- \(execution.value)"
        
        return cell
    }
    
}
