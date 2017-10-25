//
//  NSManagedObjectContext+MPAddition.swift
//  MyPlan
//
//  Created by jieyang on 2017/10/25.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    
    func trySave() {
        guard hasChanges else { return }
        
        do {
            try save()
        } catch let error as NSError {
            print("Error when save a new Plan, error: \(error), \(error.userInfo)")
        }
    }
}
