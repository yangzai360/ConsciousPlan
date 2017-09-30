//
//  CoreDataStack.swift
//  MPPLanDataModelTest
//
//  Created by Sean.Jie on 2017/3/28.
//  Copyright © 2017年 JieYang. All rights reserved.
//

import Foundation
import CoreData

protocol UsesCoreDataObjects: class {
    var managedObjectContext: NSManagedObjectContext? { get set }
}

class CoreDataStack {
    private let modelName: String
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
    var savingContext: NSManagedObjectContext {
        return storeContainer.newBackgroundContext()
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        //persistentStoreDescriptions 不写的话是系统自己做，可以自己制定路径
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
