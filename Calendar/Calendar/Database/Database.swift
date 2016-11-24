//
//  Database.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/22.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit
import CoreData

class Database {

    // MARK: - Context
    
    static let persistent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    static let queue = DispatchQueue(label: "Database")
    
    // MARK: - Method
    
    class func save() {
        if persistent.viewContext.hasChanges {
            do {
                try persistent.viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func delete(object: NSManagedObject) {
        persistent.viewContext.delete(object)
    }
    
    // MARK: - Insert
    
    class func insert(habit name: String) {
        queue.sync {
            if var objects = UserDefaults.standard.array(forKey: "Habits") as? [String] {
                objects.append(name)
                UserDefaults.standard.set(objects, forKey: "Habits")
            } else {
                UserDefaults.standard.set([name], forKey: "Habits")
            }
            /*
            let object = NSEntityDescription.insertNewObject(forEntityName: "Habit", into: persistent.viewContext) as! Habit
            object.createTime = Date().timeIntervalSince1970
            object.name = name
            self.save()
            */
        }
    }
    
    class func insert(clockIn name: String, time: Double = Date().timeIntervalSince1970) {
        queue.sync {
            let object = NSEntityDescription.insertNewObject(forEntityName: "ClockIn", into: persistent.viewContext) as! ClockIn
            object.time = time
            object.habit = name
            self.save()
        }
    }
    
    // MARK: - Delete
    
    class func remove(habit name: String) {
        queue.sync {
            let _ = {
                if var objects = UserDefaults.standard.array(forKey: "Habits") as? [String] {
                    if let index = objects.index(of: name) {
                        objects.remove(at: index)
                        UserDefaults.standard.set(objects, forKey: "Habits")
                    }
                }
                /*
                let request = NSFetchRequest<Habit>(entityName: "Habit")
                request.predicate = NSPredicate(format: "name == '\(name)'")
                if let objects = try? persistent.viewContext.fetch(request) {
                    for object in objects {
                        persistent.viewContext.delete(object)
                    }
                }*/
            }()
            let _ = {
                let request = NSFetchRequest<ClockIn>(entityName: "ClockIn")
                request.predicate = NSPredicate(format: "habit == '\(name)'")
                if let objects = try? persistent.viewContext.fetch(request) {
                    for object in objects {
                        persistent.viewContext.delete(object)
                    }
                }
            }()
            save()
        }
    }
    
    class func remove(clockIn name: String, start: Double, end: Double) {
        queue.sync {
            let _ = {
                let request = NSFetchRequest<ClockIn>(entityName: "ClockIn")
                request.predicate = NSPredicate(format: "(habit == '\(name)') AND (time >= \(start)) AND (time < \(end))")
                if let objects = try? persistent.viewContext.fetch(request) {
                    for object in objects {
                        persistent.viewContext.delete(object)
                    }
                }
            }()
            save()
        }
    }
    
    // MARK: - Fetch
    
    class func fetchHabits() -> [String] {
        return queue.sync {
            return (UserDefaults.standard.array(forKey: "Habits") as? [String]) ?? []
            /*
            let request = NSFetchRequest<Habit>(entityName: "Habit")
            request.predicate = NSPredicate(format: "name != ' '")
            request.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: true)]
            var habits = [String]()
            if let objects = try? persistent.viewContext.fetch(request) {
                for object in objects {
                    habits.append(object.name!)
                }
            }
            return habits
            */
        }
    }
    
    class func fetchClockIn(habit: String, start: Double, end: Double) -> [Double] {
        return queue.sync {
            let request = NSFetchRequest<ClockIn>(entityName: "ClockIn")
            request.predicate = NSPredicate(format: "(habit == '\(habit)') AND (time >= \(start)) AND (time < \(end))")
            request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
            
            var clockIns = [Double]()
            if let objects = try? persistent.viewContext.fetch(request) {
                for object in objects {
                    clockIns.append(object.time)
                }
            }
            return clockIns
        }
    }
    
    // MARK: - Move
    
    class func moveHabit(name: String, to: Int) {
        queue.sync {
            if var objects = UserDefaults.standard.array(forKey: "Habits") as? [String] {
                if let index = objects.index(of: name) {
                    let habit = objects.remove(at: index)
                    objects.insert(habit, at: to)
                    UserDefaults.standard.set(objects, forKey: "Habits")
                }
            }
        }
    }
    
    class func movehabit(index: Int, to: Int) {
        queue.sync {
            if var objects = UserDefaults.standard.array(forKey: "Habits") as? [String] {
                let habit = objects.remove(at: index)
                objects.insert(habit, at: to)
                UserDefaults.standard.set(objects, forKey: "Habits")
            }
        }
    }
    
    
    
}
