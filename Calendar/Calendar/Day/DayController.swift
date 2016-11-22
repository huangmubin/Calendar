//
//  DayController.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class DayController: UIViewController {
    
    // MARK: - Illustration
    
    @IBOutlet weak var illustration: UIImageView!
    
    // MARK: - Loop week view
    
    @IBOutlet weak var weekView: WeekView!
    
    // MARK: - Day View Loop
    
    @IBOutlet weak var dayViews: DayViewLoop!
    @IBOutlet weak var dayBottomLayout: NSLayoutConstraint!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekView.delegate = self
        weekView.current = Model.default.calendar.firstTimeInDay()!
        weekView.deployLoop(origin: Model.default.calendar.firstDayInWeek()!)
        
        dayViews.delegate = self
        dayViews.update(date: Model.default.calendar.date)
        
        updateColor()
        NotificationCenter.default.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: .main) { _ in
            self.updateColor()
            self.dayViews.timer(start: true)
        }
        NotificationCenter.default.addObserver(forName: .UIApplicationWillResignActive, object: nil, queue: .main) { _ in
            self.dayViews.timer(start: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
             
}

// MARK: - Back View

extension DayController {
    
    func updateColor(inTime time: Date = Date()) {
        switch CalendarInfo(date: time).hour {
        case 0 ..< 5, 19 ..< 25:
            view.backgroundColor = Colors.night
            self.illustration.image = UIImage(named: "Night")
        case 5 ..< 7, 17 ..< 19:
            view.backgroundColor = Colors.dusk
            self.illustration.image = UIImage(named: "Day")
        default:
            view.backgroundColor = Colors.day
            self.illustration.image = UIImage(named: "Day")
        }
    }
    
}

// MARK: - Week View Delegate

extension DayController: WeekViewDelegate {
    
    func weekView(selected day: Date) {
        Model.default.offsetDay(date: day)
        dayViews.update(date: Model.default.calendar.date)
    }
    
}

// MARK: - Day View Loop Delegate

extension DayController: DayViewLoopDelegate {
    
    func dayViewLoop(offsetView to: Int) -> Date {
        Model.default.offsetDay(days: to)
        weekView.updateCurrent(date: Model.default.calendar.firstTimeInDay()!)
        return Model.default.calendar.date
    }
    
    func dayViewLoop(packUp: Bool) -> Date {
        return Model.default.calendar.date
    }
    
    func dayViewLoop(checkUp: Bool) -> (Int, Int) {
        return (0, 0)
    }
    
}

// MARK: - Animation

extension DayController {
    
    @IBAction func dayViewPackUpAction(_ sender: UIButton) {
        let packUp = self.dayBottomLayout.constant == 0
        if !packUp {
            self.dayViews.dayViews(packUp: packUp, inDate: Model.default.calendar.date)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.dayBottomLayout.constant = packUp ? self.dayViews.bounds.height - 70 : 0
            self.dayViews.centerView.dayLabel.alpha = packUp ? 0 : 1
            self.view.layoutIfNeeded()
            }, completion: { _ in
                if packUp {
                    self.dayViews.dayViews(packUp: packUp, inDate: Model.default.calendar.date)
                }
        })
    }
    
}
