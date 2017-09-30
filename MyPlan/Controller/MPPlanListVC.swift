//
//  MPPlanListVC.swift
//  MyPlan
//
//  Created by jieyang on 17/3/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

class MPPlanListVC : UIViewController {

    // MARK: - Properties
    var stack : CoreDataStack!
    var managedContext: NSManagedObjectContext!
    
    var fetchResult : [MPPlan]!
    
    @IBOutlet weak var tableView: UITableView!
    
    struct PlanListCellIDs {
        static let planCell = "MPPlanListCell"
//        static let noPlanCell = "NothingFoundCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.coreDataStack.managedContext
        stack = appDelegate.coreDataStack

        self.automaticallyAdjustsScrollViewInsets = false
        
//        稍后加入另一个没有数据的cell，所以这个暂时还是var
        var cellNib = UINib(nibName: PlanListCellIDs.planCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: PlanListCellIDs.planCell)
        
        tableView.rowHeight = 80
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if managedContext.hasChanges {
            managedContext.reset()
        }
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
        
        let dateFormatter = DateFormatter()
        if plan.isAllDayTime {
            dateFormatter.locale     = Locale(identifier: "zh")
            dateFormatter.dateStyle  = DateFormatter.Style.long
        } else {
            dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        }
        
        cell.tintColorView.backgroundColor = plan.tintColor as? UIColor
        cell.planNameLabel.text = plan.planName
        cell.progressLabel.text = NSString(format:"已完成: %.2f%%", (plan.value/plan.tergetValue)*100) as String
        
        cell.progressView.backgroundColor = plan.tintColor as? UIColor
        cell.progressViewWidthCons.constant = CGFloat(Double(cell.progressBackView.frame.width) * (plan.value/plan.tergetValue))
        
        cell.planTypeLabel.text = PlanType.allValues[Int(plan.planType)].description
        cell.planTimeLabel.text = plan.beginTimeStr() + " - " + plan.endTimeStr()

        return cell
    }
}

extension MPPlanListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan = fetchResult[indexPath.row]
        self.performSegue(withIdentifier:"planDetailSegue", sender: plan)
        
//        do {
//            plan.planType = Int32(0)  //测试代码，强行转换成 定量计划
//            try managedContext?.save()
//        } catch let error as NSError {
//            print("Error when save a new Plan, error: \(error), \(error.userInfo)")
//        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Delete plan row and data.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.managedContext.delete(self.fetchResult[indexPath.row])
            self.fetchResult.remove(at: indexPath.row)
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("error:\(errno), \(error.userInfo).")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
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
