//
//  DayViewLoop.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/16.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

// MARK: - Day View Loop Delegate Protocol

protocol DayViewLoopDelegate: NSObjectProtocol {
    func dayViewLoop(offsetView to: Int) -> Date
    func dayViewLoop(packUp: Bool) -> Date
    func dayViewLoop(checkUp: Bool) -> (Int, Int)
}

// MARK: - Day View Loop

class DayViewLoop: UIView {
    
    // MARK: - Delegate
    
    weak var delegate: DayViewLoopDelegate?
    
    // MARK: - Timer
    
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.layer.shadowOpacity = 0.2
            timerLabel.layer.shadowRadius = 2
            timerLabel.layer.shadowColor = UIColor.black.cgColor
            timerLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
            format.dateFormat = "HH : mm"
            timerLabel.text = self.format.string(from: Date())
        }
    }
    private var timer: DispatchSourceTimer!
    private var format = DateFormatter()
    
    func timer(start: Bool) {
        if start {
            timerLabel.text = self.format.string(from: Date())
            DispatchQueue.global().async {
                let date = 60 - CalendarInfo().second
                Thread.sleep(forTimeInterval: TimeInterval(date))
                self.timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.init(rawValue: 1), queue: DispatchQueue.main)
                self.timer?.scheduleRepeating(wallDeadline: DispatchWallTime.now(), interval: DispatchTimeInterval.seconds(60))
                self.timer?.setEventHandler(handler: {
                    DispatchQueue.main.async {
                        self.timerLabel.text = self.format.string(from: Date())
                    }
                })
                self.timer?.resume()
            }
        } else {
            timer?.suspend()
        }
    }
    
    // MARK: - Day Views
    
    @IBOutlet weak var centerView: DayView!
    @IBOutlet weak var previousView: DayView!
    @IBOutlet weak var nextView: DayView!
    
    func update(date: Date) {
        centerView.update(date: date)
        previousView.update(date: date.addingTimeInterval(-86400))
        nextView.update(date: date.addingTimeInterval(86400))
    }
    
    // MARK: - Pan Gesture Action
    
    @IBOutlet weak var centerViewLayout: NSLayoutConstraint!
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            break
        case .changed:
            centerViewLayout.constant = sender.translation(in: self).x
        case .ended:
            let velocity = sender.velocity(in: self).x
            
            /** Previous Day View **/
            if centerViewLayout.constant > self.bounds.width / 2 || velocity > 1000 {
                previousAnimation()
                return
            }
            
            /** Next Day View **/
            if centerViewLayout.constant < -self.bounds.width / 2 || velocity < -1000 {
                nextAnimation()
                return
            }
            
            /** Center Day View **/
            fallthrough
        default:
            centerAnimation()
        }
    }
    
    // MARK: - Animations
    
    private func previousAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.centerViewLayout.constant = self.bounds.width
            self.layoutIfNeeded()
        }, completion: { (finish) in
            if let date = self.delegate?.dayViewLoop(offsetView: -1) {
                self.update(date: date)
            }
            self.centerViewLayout.constant = 0
            self.layoutIfNeeded()
        })
    }
    
    private func nextAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.centerViewLayout.constant = -self.bounds.width
            self.layoutIfNeeded()
            }, completion: { (finish) in
                if let date = self.delegate?.dayViewLoop(offsetView: 1) {
                    self.update(date: date)
                }
                self.centerViewLayout.constant = 0
                self.layoutIfNeeded()
        })
    }
    
    private func centerAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.centerViewLayout.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Move
    
    func dayViews(packUp: Bool, inDate date: Date) {
        self.centerView.isPackUp = packUp
        self.previousView.isPackUp = packUp
        self.nextView.isPackUp = packUp
        self.update(date: date)
    }
    
}
