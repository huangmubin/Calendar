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
    
    // MARK: - Clock In View
    
    @IBOutlet weak var clockInView: ClockInView! {
        didSet {
            clockInView.delegate = self
            self.takeHabits()
            self.updateClockInViewDatas()
        }
    }
    
    var clockInDates: [ClockInViewDateModel] = []
    
    // MARK: - PackUp Button
    
    @IBOutlet weak var packUpButton: UIButton! {
        didSet { self.updatePackUpButton() }
    }
    
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

// MARK: - PackUp

extension DayController {
    
    func updatePackUpButton() {
        var count = 0
        self.clockInDates.forEach({
            if $0.clockIn {
                count += 1
            }
        })
        packUpButton?.setTitle("打卡: \(count)/\(clockInDates.count)", for: .normal)
    }
    
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
        updateClockInViewDatas()
    }
    
}

// MARK: - Day View Loop Delegate

extension DayController: DayViewLoopDelegate {
    
    func dayViewLoop(offsetView to: Int) -> Date {
        Model.default.offsetDay(days: to)
        weekView.updateCurrent(date: Model.default.calendar.firstTimeInDay()!)
        updateClockInViewDatas()
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
            self.view.layoutIfNeeded()
            
            self.dayViews.centerView.dayLabel.alpha = packUp ? 0 : 1
            self.illustration.alpha = packUp ? 0 : 1
            
            }, completion: { _ in
                if packUp {
                    self.dayViews.dayViews(packUp: packUp, inDate: Model.default.calendar.date)
                }
        })
    }
    
}


// MARK: - Clock In View Delegate

extension DayController: ClockInViewDelegate {
    
    func takeHabits() {
        self.clockInDates.removeAll(keepingCapacity: true)
        let habits = Database.fetchHabits()
        for habit in habits {
            let model = ClockInModel(habit: habit)
            model.habit = habit
            self.clockInDates.append(model)
        }
    }
    
    func updateClockInViewDatas() {
        let range = Model.default.rangeInDay()
        
        for var model in self.clockInDates {
            model.clockIn = Database.fetchClockIn(habit: model.habit, start: range.start, end: range.end).count > 0
        }
        
        self.clockInView?.tableView?.reloadData()
        self.updatePackUpButton()
    }
    
    func clockInView(view: ClockInView, clockIn: Bool, habit: String, at: Int) {
        let range = Model.default.rangeInDay()
        if clockIn {
            Database.insert(clockIn: habit, time: range.start + 43200)
        } else if Database.fetchClockIn(habit: habit, start: range.start, end: range.end).count <= 0 {
            Database.remove(clockIn: habit, start: range.start, end: range.end)
        }
        
        self.clockInDates[at].clockIn = clockIn
    }
    
    func clockInView(view: ClockInView, insert habit: String) -> Bool {
        Database.insert(habit: habit)
        self.clockInDates.append(ClockInModel(habit: habit))
        return true
    }
    
    func clockInView(view: ClockInView, delete habit: String, at: Int) -> Bool {
        Database.remove(habit: habit)
        self.clockInDates.remove(at: at)
        return true
    }
    
}
