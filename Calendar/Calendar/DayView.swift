//
//  DayView.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/14.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class DayView: UIView {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chineseLabel: UILabel!
    
    func update(_ offsetTo: Int) {
        let offset = Double(offsetTo) * 86400
        let calendar = Model.default.calendar.offset(time: offset)
        let chinese  = Model.default.chinese.offset(time: offset)
        dayLabel.text = "\(calendar.day)"
        dateLabel.text = "\(calendar.year) 年 \(calendar.month) 月"
        chineseLabel.text = "\(chinese.chineseYear)\(chinese.chineseZodiac)年\(chinese.chineseMonth)\(chinese.chineseDay)"
    }
    
}
