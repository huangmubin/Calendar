//
//  Model.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/16.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

// MARK: - Test

func log(file: String = #file, function: String = #function, pre: String, date: Date) {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss EEEE"
    print("\(file) _ \(function): \(pre) -> \(format.string(from: date))")
}

func logPo(date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss EEEE"
    return format.string(from: date)
}

// MARK: - Model

class Model {
    
    // MARK: Default
    static let `default` = Model()
    
    // MARK: - Datas
    
    private var _origin: Date
    
    /// 显示日期偏移量
    var offset: TimeInterval = 0
    
    var origin: Date {
        return _origin.addingTimeInterval(offset)
    }
    var calendar: CalendarInfo {
        return CalendarInfo(date: origin)
    }
    var chinese: CalendarInfo {
        return CalendarInfo(identifier: Calendar.Identifier.chinese, date: origin)
    }
    
    // MARK: - Init
    
    init() {
        _origin = CalendarInfo().firstTimeInDay()!
    }
    
    // MARK: - Methods
    
    func offsetDay(days: Int) {
        offset += CalendarInfo.Timestamp.day[days]
    }
    
    func offsetDay(date: Date) {
        offset = date.timeIntervalSince1970 - _origin.timeIntervalSince1970
    }
    
}
