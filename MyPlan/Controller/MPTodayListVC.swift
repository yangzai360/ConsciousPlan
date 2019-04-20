//
//  MPTodayListVC.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/11/23.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class MPTodayListVC: UIViewController {

    var managedContext: NSManagedObjectContext!
    var fetchResult : [MPPlan]!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.coreDataStack.managedContext
        
        self.automaticallyAdjustsScrollViewInsets = false
        let cellNib = UINib(nibName: "MPPlanListCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MPPlanListCell")
        tableView.rowHeight = 80
        
//        tableView.emptyDataSetDelegate = self
//        tableView.emptyDataSetSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Tint color.
        updateAppearance(tintColor: self.defaultTintColor())
        fetchTodayPlans()
        tableView.reloadData()
    }
    
    func fetchTodayPlans() {
        let fetchRequest = NSFetchRequest<MPPlan>(entityName: "MPPlan")
        //查询计划列表，筛选条件为「计划的时间范围 包含当前时间」
        let nowDate = NSDate();
        fetchRequest.predicate = NSPredicate.init(format: "beginTime < %@ AND endTime > %@", nowDate, nowDate)
        do {
            fetchResult = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let viewController = navController.topViewController as? MPCreatePlanVC {
            viewController.managedObjectContext = managedContext
        } else if let planDetailVC = segue.destination as? MPPlanDetailVC {
            planDetailVC.managedObjectContext = managedContext
            planDetailVC.plan = sender as? MPPlan
        }
    }
    
    @IBAction func unwindToTodayList(_ segue: UIStoryboardSegue) {
        print("Unwinding to Today List")
    }
}

// MARK: - UITableViewDataSource
extension MPTodayListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchResult == nil { return 0 }
        return fetchResult.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MPPlanListCell", for: indexPath) as! MPPlanListCell
        let plan = fetchResult[indexPath.row]
        cell.configureCell(plan: plan)
        return cell
    }
}

extension MPTodayListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan = fetchResult[indexPath.row]
        self.performSegue(withIdentifier:"planDetailSegue", sender: plan)
    }
    
    // Header's height & view.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4.0;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}

//// MARK: - DZNEmptyDataSet.
//extension MPTodayListVC : DZNEmptyDataSetSource {
//    //实现第三方库协议的方法
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text = "你今天没有任何计划~"
//        let attributes = [NSAttributedString.Key.foregroundColor: UIFont.boldSystemFont(ofSize: CGFloat(18.0)),
//                          NSAttributedString.Key.foregroundColor: UIColor.darkGray]
//        return NSAttributedString(string: text, attributes: attributes)
//    }
//    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text = "这里列举了今天的计划"
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineBreakMode = .byWordWrapping
//        paragraph.alignment = .center
//        let attributes = [NSAttributedString.Key.foregroundColor: UIFont.systemFont(ofSize: CGFloat(14.0)),
//                          NSAttributedString.Key.foregroundColor: UIColor.lightGray,
//                          NSAttributedString.Key.paragraphStyle: paragraph]
//        return NSAttributedString(string: text, attributes: attributes)
//
//    }
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
//        let attributes = [NSAttributedString.Key.foregroundColor: UIFont.boldSystemFont(ofSize: CGFloat(18.0)),
//                          NSAttributedString.Key.foregroundColor: self.defaultTintColor()]
//        return NSAttributedString(string: "创建新计划", attributes: attributes)
//
//    }
//    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
//        return UIColor.white
//    }
//}
//extension MPTodayListVC : DZNEmptyDataSetDelegate {
//    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
//        performSegue(withIdentifier: "createPlanSegue", sender: nil)
//    }
//}
