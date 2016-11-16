//
//  Model.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/16.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

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
        _origin = Date()
    }
    
    // MARK: - Methods
    
    func offsetDay(days: Int) {
        offset += CalendarInfo.Timestamp.day[days]
    }
    
    func offsetDay(date: Date) {
        offset = date.timeIntervalSince1970 - _origin.timeIntervalSince1970
    }
    
}
