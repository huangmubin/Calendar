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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dayViews.timer(start: false)
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
