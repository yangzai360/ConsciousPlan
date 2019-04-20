//
//  MPPlanListVC.swift
//  MyPlan
//
//  Created by jieyang on 17/3/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class MPPlanListVC : UIViewController {

    // MARK: - Properties
    var stack : CoreDataStack!
    var managedContext: NSManagedObjectContext!
    
    var fetchResult : [MPPlan]!
    
    @IBOutlet weak var tableView: UITableView!
    
    public enum PlanListCellIDs {
        static let planCell = "MPPlanListCell"
//        static let noPlanCell = "NothingFoundCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.coreDataStack.managedContext
        stack = appDelegate.coreDataStack
        
        self.automaticallyAdjustsScrollViewInsets = false
        let cellNib = UINib(nibName: PlanListCellIDs.planCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: PlanListCellIDs.planCell)
        tableView.rowHeight = 80
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Tint color.
        updateAppearance(tintColor: self.defaultTintColor())
        fetchPlanData()
        tableView.reloadData()
    }
    
    func fetchPlanData() {
        let fetchRequest = NSFetchRequest<MPPlan>(entityName: "MPPlan")
        do {
            fetchResult = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let viewController = navController.topViewController as? MPCreatePlanVC {
            viewController.managedObjectContext = stack.managedContext
        } else if let planDetailVC = segue.destination as? MPPlanDetailVC {
            planDetailVC.managedObjectContext = stack.managedContext
            planDetailVC.plan = sender as? MPPlan
        }
    }
    
    @IBAction func unwindToPlansList(_ segue: UIStoryboardSegue) {
        print("Unwinding to Plans List")
    }
}

// MARK: - UITableViewDataSource
extension MPPlanListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchResult == nil { return 0 }
        return fetchResult.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanListCellIDs.planCell, for: indexPath) as! MPPlanListCell
        let plan = fetchResult[indexPath.row]
        cell.configureCell(plan: plan)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MPPlanListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan = fetchResult[indexPath.row]
        self.performSegue(withIdentifier:"planDetailSegue", sender: plan)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Delete plan row and data.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.managedContext.delete(self.fetchResult[indexPath.row])
            self.fetchResult.remove(at: indexPath.row)
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("error:\(errno), \(error.userInfo).")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if self.fetchResult.count == 0 {  //如果没有
                tableView.reloadData()
            }
        }
    }
    
    // Header height & view.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4.0;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}

// MARK: - DZNEmptyDataSet.
extension MPPlanListVC : DZNEmptyDataSetSource {
    //实现第三方库协议的方法
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "你还没有任何计划~"
        let attributes = [NSAttributedString.Key.foregroundColor: UIFont.boldSystemFont(ofSize: CGFloat(18.0)),
                          NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "这里列举了你的所有计划"
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        let attributes = [NSAttributedString.Key.foregroundColor: UIFont.systemFont(ofSize: CGFloat(14.0)),
                          NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                          NSAttributedString.Key.paragraphStyle: paragraph]
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.foregroundColor: UIFont.boldSystemFont(ofSize: CGFloat(18.0)),
                          NSAttributedString.Key.foregroundColor: self.defaultTintColor()]
        return NSAttributedString(string: "创建新计划", attributes: attributes)
        
    }
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
}
extension MPPlanListVC : DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        performSegue(withIdentifier: "createPlanSegue", sender: nil)
    }
}
