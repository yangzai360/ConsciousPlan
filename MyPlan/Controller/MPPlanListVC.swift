//
//  MPPlanListVC.swift
//  MyPlan
//
//  Created by jieyang on 17/3/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

class MPPlanListVC : UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

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

extension MPPlanListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan = fetchResult[indexPath.row]
        self.performSegue(withIdentifier:"planDetailSegue", sender: plan)
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
