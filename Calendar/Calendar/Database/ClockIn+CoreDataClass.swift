//
//  ClockIn+CoreDataClass.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/22.
//  Copyright © 2016年 Myron. All rights reserved.
//

import Foundation
import CoreData


public class ClockIn: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClockIn> {
        return NSFetchRequest<ClockIn>(entityName: "ClockIn");
    }
    
    @NSManaged public var habit: String?
    @NSManaged public var time: Double
}
