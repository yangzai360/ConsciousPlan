//
//  Execution+CoreDataClass.swift
//  
//
//  Created by Sean.Jie on 2017/4/5.
//
//

import Foundation
import CoreData

@objc(Execution)
public class Execution: NSManagedObject {
    
    static func dayDateFormatter() -> DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYYMMDD"
        return dateFormat
    }
    
    func dateFormatterIntKey() -> Int {
        return Int(Execution.dayDateFormatter().string(from: date! as Date))!
    }

}
