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
    func dayViewLoop(offsetView to: Int)
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
            
//            format.dateFormat = "HH : mm"
//            timer.setEventHandler() {
//                let new = self.format.string(from: Date())
//                if new != self.timerLabel.text {
//                    DispatchQueue.main.async {
//                        self.timerLabel.text = new
//                    }
//                }
//            }
//            timer.resume()
        }
    }
    private var timer: DispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    private var format = DateFormatter()
    
    func timer(start: Bool) {
//        if start {
//            timer.resume()
//        } else {
//            timer.suspend()
//        }
    }
    
    // MARK: - Day Views
    
    @IBOutlet weak var centerView: DayView!
    @IBOutlet weak var previousView: DayView!
    @IBOutlet weak var nextView: DayView!
    
    func update() {
        centerView.update(0)
        previousView.update(-1)
        nextView.update(1)
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
            Model.default.offsetDay(days: -1)
            self.update()
            self.centerViewLayout.constant = 0
            self.layoutIfNeeded()
            
            self.delegate?.dayViewLoop(offsetView: -1)
        })
    }
    
    private func nextAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.centerViewLayout.constant = -self.bounds.width
            self.layoutIfNeeded()
            }, completion: { (finish) in
                Model.default.offsetDay(days: 1)
                self.update()
                self.centerViewLayout.constant = 0
                self.layoutIfNeeded()
                
                self.delegate?.dayViewLoop(offsetView: 1)
        })
    }
    
    private func centerAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.centerViewLayout.constant = 0
            self.layoutIfNeeded()
        }
    }
    
}
