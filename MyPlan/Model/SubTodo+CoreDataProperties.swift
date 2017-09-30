//
//  SubTodo+CoreDataProperties.swift
//  
//
//  Created by Sean.Jie on 2017/4/16.
//
//

import Foundation
import CoreData

extension SubTodo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubTodo> {
        return NSFetchRequest<SubTodo>(entityName: "SubTodo")
    }

    @NSManaged public var name: String?
    @NSManaged public var createTime: NSDate?
    @NSManaged public var doneTime: NSDate?
    @NSManaged public var value: Bool
    @NSManaged public var plan: MPPlan?

}
