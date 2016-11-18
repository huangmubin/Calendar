//
//  WeekLoopCell.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/16.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class WeekLoopCell: LoopCollectionViewCell {
    
    // MARK: Property
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var chineseDayLabel: UILabel!
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.backgroundColor = UIColor.clear
            backView.layer.cornerRadius = 20
        }
    }
    
    // MARK: - Update Views
    
    var light  = false
    var today  = false
    var select = false
    
    func update(display: Bool = false) {
        if display {
            switch (select, light, today) {
            case (true, _, true):   // 选中，并且是今天
                backView.layer.backgroundColor = Colors.red.cgColor
                
                dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
                chineseDayLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold)
                
                dayLabel.textColor = Colors.white
                chineseDayLabel.textColor = Colors.white
            case (true, _, false):  // 选中，但不是今天
                backView.layer.backgroundColor = Colors.white.cgColor
                
                dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
                chineseDayLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold)
                
                dayLabel.textColor = Colors.black
                chineseDayLabel.textColor = Colors.black
            case (_, _, true):      // 没选中，并且是今天
                backView.layer.backgroundColor = UIColor.clear.cgColor
                
                dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
                chineseDayLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
                
                dayLabel.textColor = UIColor.red
                chineseDayLabel.textColor = UIColor.red
            default:                // 没选中，不是今天
                backView.layer.backgroundColor = UIColor.clear.cgColor
                
                dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
                chineseDayLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
                
                dayLabel.textColor = Colors.white
                chineseDayLabel.textColor = Colors.white
            }
        } else {
            backView.layer.backgroundColor = UIColor.clear.cgColor
            
            if today {
                dayLabel.textColor = UIColor.red
                chineseDayLabel.textColor = UIColor.red
            } else {
                dayLabel.textColor = Colors.white
                chineseDayLabel.textColor = Colors.white
            }
            
            dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
            chineseDayLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        }
    }
    
    // MARK: - Interface
    
    func update(date: Date) {
        let calendar = CalendarInfo(date: date)
        let chinese  = CalendarInfo(identifier: .chinese, date: date)
        dayLabel.text = "\(calendar.day)"
        chineseDayLabel.text = chinese.chineseDay
    }
    
}
