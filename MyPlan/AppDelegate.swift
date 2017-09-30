//
//  AppDelegate.swift
//  MyPlan
//
//  Created by jieyang on 17/3/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack(modelName:"MyPlan")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        guard let tabbarController = window?.rootViewController as? UITabBarController else {
//            return true
//        }
//        print("\(tabbarController)")
        
//        guard let tabbarController = window?.rootViewController as? UITabBarController,
//            let navController = tabbarController.viewControllers?.first as? UINavigationController,
//            let viewcontroller = navController.topViewController as? MPPlanListVC else {
//                return true
//        }
//        viewcontroller.managedContext = coreDataStack.managedContext
//        viewcontroller.stack = coreDataStack
        
        return true

    }
}

