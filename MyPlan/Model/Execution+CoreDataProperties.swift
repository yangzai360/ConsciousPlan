//
//  Execution+CoreDataProperties.swift
//  
//
//  Created by Sean.Jie on 2017/4/5.
//
//

import Foundation
import CoreData

extension Execution {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Execution> {
        return NSFetchRequest<Execution>(entityName: "Execution")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var value: Double
    @NSManaged public var plan: MPPlan?
    
}
