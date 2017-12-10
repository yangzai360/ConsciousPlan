//
//  MPCalendarListTVC.swift
//  MyPlan
//
//  Created by SJ on 2017/8/9.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol MPCalendarListTVCDelegate : class{
    func didSelectPlan(plan: MPPlan)
}

class MPCalendarListTVC: UITableViewController {
    
    var delegate: MPCalendarListTVCDelegate?
    
    //目前要展示的
    var showResult : [Execution]! = [Execution]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        let cellNib = UINib(nibName: CalendarListCellIDs.executionCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CalendarListCellIDs.executionCell)

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.tableFooterView = UIView() //去掉表格视图中多余的线
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
        dateFormatter.dateFormat = "HH:mm:ss"
        
        cell.executionDateLabel.text = dateFormatter.string(from: execution.date as! Date)
        cell.valueLabel.text = (execution.value > 0 ? "+ \(execution.value) " : "- \(abs(execution.value)) ")
            + execution.plan!.valueUnit()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let execution = showResult[indexPath.row]
        guard let plan = execution.plan else {
            return
        }
        delegate?.didSelectPlan(plan: plan)
    }
}

// MARK: - DZNEmptyDataSet.
extension MPCalendarListTVC : DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "这一天没有执行记录"
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(16.0)),
                          NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "这里展示了你在这一天的所有执行记录"
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
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
}
extension MPCalendarListTVC : DZNEmptyDataSetDelegate {
}
