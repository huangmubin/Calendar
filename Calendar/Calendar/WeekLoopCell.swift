//
//  WeekLoopCell.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/16.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class WeekLoopCell: LoopCollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.backgroundColor = UIColor.clear
        backView.layer.cornerRadius = 20
    }
    
    // MARK: Property
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var chineseDayLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Update Views
    
    var light  = false
    var today  = false
    var select = false
    
    func update() {
        switch (select, light, today) {
        case (true, _, true):   // 选中，并且是今天
            backView.layer.backgroundColor = UIColor.red.cgColor
            dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
            dayLabel.textColor = UIColor.white
            chineseDayLabel.textColor = UIColor.white
        case (true, _, false):  // 选中，但不是今天
            backView.layer.backgroundColor = UIColor.white.cgColor
            dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
            dayLabel.textColor = UIColor.black
            chineseDayLabel.textColor = UIColor.black
        case (_, _, true):      // 没选中，并且是今天
            backView.layer.backgroundColor = UIColor.clear.cgColor
            dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
            dayLabel.textColor = UIColor.red
            chineseDayLabel.textColor = UIColor.red
        case (_, true, _):      // 没选中，而且不是今天，但是是周末
            backView.layer.backgroundColor = UIColor.clear.cgColor
            dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
            dayLabel.textColor = UIColor.lightGray
            chineseDayLabel.textColor = UIColor.lightGray
        default:                // 没选中，不是今天，而且不是周末
            backView.layer.backgroundColor = UIColor.clear.cgColor
            dayLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
            dayLabel.textColor = UIColor.white
            chineseDayLabel.textColor = UIColor.white
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
