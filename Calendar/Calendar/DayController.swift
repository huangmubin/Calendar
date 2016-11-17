//
//  DayController.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class DayController: UIViewController {
    
    
    // MARK: - Loop week view
    
    @IBOutlet weak var weekView: WeekView!
    
    // MARK: - Day View Loop
    
    @IBOutlet weak var dayViews: DayViewLoop!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekView.delegate = self
        weekView.current = Model.default.calendar.firstTimeInDay()!
        weekView.deployLoop(origin: Model.default.calendar.firstDayInWeek()!)
        
        dayViews.delegate = self
        dayViews.update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dayViews.timer(start: true)
        updateColor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dayViews.timer(start: false)
    }
    
}

// MARK: - Back View

extension DayController {
    
    
    func updateColor(inTime time: Date = Date()) {
        let hour = CGFloat((CalendarInfo(date: time).hour + 6) % 24) / 24
        print("update Color hour \(CalendarInfo(date: time).hour) \(hour)")
        // 15 20 45  160 185 250
        // 145 165 205
        func float(_ start: CGFloat, _ full: CGFloat) -> CGFloat {
            return (start + full * hour) / 255.0
        }
        view.backgroundColor = UIColor(red: float(15, 145), green: float(20, 165), blue: float(45, 205), alpha: 1)
    }
    
}

// MARK: - Week View Delegate

extension DayController: WeekViewDelegate {
    
    func weekView(selected day: Date) {
        Model.default.offsetDay(date: day)
        dayViews.update()
    }
    
}

// MARK: - Day View Loop Delegate

extension DayController: DayViewLoopDelegate {
    
    func dayViewLoop(offsetView to: Int) {
        weekView.updateCurrent(date: Model.default.calendar.firstTimeInDay()!)
    }
    
}
