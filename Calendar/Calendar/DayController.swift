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
    
    func updateWeekViewCurrentDate() {
        weekView.updateCurrent(date: Model.default.calendar.firstTimeInDay()!)
    }
    
    // MARK: - Day View
    
    @IBOutlet weak var dayView: DayView!
    @IBOutlet weak var dayViewPre: DayView!
    @IBOutlet weak var dayViewNext: DayView!
    
    func updateDayView() {
        dayView.update(0)
        dayViewPre.update(-1)
        dayViewNext.update(1)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDayView()
        
        weekView.delegate = self
        weekView.current = Model.default.calendar.firstTimeInDay()!
        weekView.deployLoop(origin: Model.default.calendar.firstDayInWeek()!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Move Gesture
    
    @IBOutlet weak var dayViewLayout: NSLayoutConstraint!
    @IBAction func dayViewPanAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            break
        case .changed:
            dayViewLayout.constant = sender.translation(in: view).x
        case .ended:
            let velocity = sender.velocity(in: view).x
            /** Previous Day View **/
            
            if dayViewLayout.constant > centerX || velocity > 1000 {
                previousAnimation()
                return
            }
            
            /** Next Day View **/
            
            if dayViewLayout.constant < -centerX || velocity < -1000 {
                nextAnimation()
                return
            }
            
            /** Center Day View **/
            fallthrough
        default:
            centerAnimation()
        }
    }
    
    // MARK: Animations
    
    private func previousAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dayViewLayout.constant = self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: { (finish) in
            Model.default.offsetDay(days: -1)
            self.updateWeekViewCurrentDate()
            self.updateDayView()
            self.dayViewLayout.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    private func nextAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dayViewLayout.constant = -self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: { (finish) in
            Model.default.offsetDay(days: 1)
            self.updateWeekViewCurrentDate()
            self.updateDayView()
            self.dayViewLayout.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    private func centerAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.dayViewLayout.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - Week View Delegate

extension DayController: WeekViewDelegate {
    
    func weekView(selected day: Date) {
        Model.default.offsetDay(date: day)
        self.updateDayView()
    }
    
}
