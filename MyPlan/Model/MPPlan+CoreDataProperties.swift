//
//  MPPlan+CoreDataProperties.swift
//  
//
//  Created by Sean.Jie on 2017/4/16.
//
//

import Foundation
import CoreData


extension MPPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MPPlan> {
        return NSFetchRequest<MPPlan>(entityName: "MPPlan")
    }

    @NSManaged public var beginTime: NSDate?
    @NSManaged public var createDate: NSDate?
    @NSManaged public var customUnit: String?
    @NSManaged public var endTime: NSDate?
    @NSManaged public var isAllDayTime: Bool
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var parentID: Int32
    @NSManaged public var planCategory: Int32
    @NSManaged public var planID: Int32
    @NSManaged public var planName: String?
    @NSManaged public var planRemarks: String?
    @NSManaged public var planType: Int32
    @NSManaged public var startValue: Double
    @NSManaged public var tergetValue: Double
    @NSManaged public var timeUnit: Int32
    @NSManaged public var tintColor: NSObject?
    @NSManaged public var unit: Int32
    @NSManaged public var userValue: Double
    @NSManaged public var value: Double
    @NSManaged public var executions: NSOrderedSet?
    @NSManaged public var subTodos: NSOrderedSet?
}

// MARK: Generated accessors for executions
extension MPPlan {

    @objc(insertObject:inExecutionsAtIndex:)
    @NSManaged public func insertIntoExecutions(_ value: Execution, at idx: Int)

    @objc(removeObjectFromExecutionsAtIndex:)
    @NSManaged public func removeFromExecutions(at idx: Int)

    @objc(insertExecutions:atIndexes:)
    @NSManaged public func insertIntoExecutions(_ values: [Execution], at indexes: NSIndexSet)

    @objc(removeExecutionsAtIndexes:)
    @NSManaged public func removeFromExecutions(at indexes: NSIndexSet)

    @objc(replaceObjectInExecutionsAtIndex:withObject:)
    @NSManaged public func replaceExecutions(at idx: Int, with value: Execution)

    @objc(replaceExecutionsAtIndexes:withExecutions:)
    @NSManaged public func replaceExecutions(at indexes: NSIndexSet, with values: [Execution])

    @objc(addExecutionsObject:)
    @NSManaged public func addToExecutions(_ value: Execution)

    @objc(removeExecutionsObject:)
    @NSManaged public func removeFromExecutions(_ value: Execution)

    @objc(addExecutions:)
    @NSManaged public func addToExecutions(_ values: NSOrderedSet)

    @objc(removeExecutions:)
    @NSManaged public func removeFromExecutions(_ values: NSOrderedSet)

}

// MARK: Generated accessors for subTodos
extension MPPlan {

    @objc(insertObject:inSubTodosAtIndex:)
    @NSManaged public func insertIntoSubTodos(_ value: SubTodo, at idx: Int)

    @objc(removeObjectFromSubTodosAtIndex:)
    @NSManaged public func removeFromSubTodos(at idx: Int)

    @objc(insertSubTodos:atIndexes:)
    @NSManaged public func insertIntoSubTodos(_ values: [SubTodo], at indexes: NSIndexSet)

    @objc(removeSubTodosAtIndexes:)
    @NSManaged public func removeFromSubTodos(at indexes: NSIndexSet)

    @objc(replaceObjectInSubTodosAtIndex:withObject:)
    @NSManaged public func replaceSubTodos(at idx: Int, with value: SubTodo)

    @objc(replaceSubTodosAtIndexes:withSubTodos:)
    @NSManaged public func replaceSubTodos(at indexes: NSIndexSet, with values: [SubTodo])

    @objc(addSubTodosObject:)
    @NSManaged public func addToSubTodos(_ value: SubTodo)

    @objc(removeSubTodosObject:)
    @NSManaged public func removeFromSubTodos(_ value: SubTodo)

    @objc(addSubTodos:)
    @NSManaged public func addToSubTodos(_ values: NSOrderedSet)

    @objc(removeSubTodos:)
    @NSManaged public func removeFromSubTodos(_ values: NSOrderedSet)

}
