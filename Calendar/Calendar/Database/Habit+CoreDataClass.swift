//
//  Habit+CoreDataClass.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/22.
//  Copyright © 2016年 Myron. All rights reserved.
//

import Foundation
import CoreData


public class Habit: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit");
    }
    
    @NSManaged public var createTime: Double
    @NSManaged public var name: String?
}
