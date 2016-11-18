//
//  DayView.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/14.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class DayView: UIView {
    
    @IBOutlet weak var dayLabel: UILabel! {
        didSet {
            dayLabel.layer.shadowOpacity = 0.3
            dayLabel.layer.shadowRadius = 2
            dayLabel.layer.shadowColor = UIColor.black.cgColor
            dayLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.layer.shadowOpacity = 0.2
            dateLabel.layer.shadowRadius = 2
            dateLabel.layer.shadowColor = UIColor.black.cgColor
            dateLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    @IBOutlet weak var chineseLabel: UILabel! {
        didSet {
            chineseLabel.layer.shadowOpacity = 0.2
            chineseLabel.layer.shadowRadius = 2
            chineseLabel.layer.shadowColor = UIColor.black.cgColor
            chineseLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    
    var isPackUp: Bool = false
    
    func update(date: Date) {
        let calendar = CalendarInfo(date: date)
        let chinese  = CalendarInfo(identifier: Calendar.Identifier.chinese, date: date)
        dayLabel.text = "\(calendar.day)"
        dateLabel.text = "\(calendar.year) 年 \(calendar.month) 月"
        chineseLabel.text = "\(chinese.chineseYear)\(chinese.chineseZodiac)年\(chinese.chineseMonth)\(chinese.chineseDay)"
        
        if isPackUp {
            dateLabel.text = "\(dateLabel.text!) \(calendar.day)"
            dayLabel.alpha = 0
        }
    }
    
    
}
