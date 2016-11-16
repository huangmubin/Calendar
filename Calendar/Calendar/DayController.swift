//
//  DayController.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class DayController: UIViewController {

    
    // MARK: - Day View
    
    @IBOutlet weak var dayView: DayView!
    @IBOutlet weak var dayViewPre: DayView!
    @IBOutlet weak var dayViewNext: DayView!
    
    @IBOutlet weak var dayViewLayout: NSLayoutConstraint!
    
    @IBAction func dayViewPanAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            break
        case .changed:
            dayViewLayout.constant = sender.translation(in: view).x
        case .ended:
            
            // Pre
            
            if dayViewLayout.constant < -view.bounds.width / 2 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.dayViewLayout.constant = -self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: { (finish) in
                        self.dayViewLayout.constant = 0
                        self.view.layoutIfNeeded()
                })
                return
            }
            
            // Next
            
            if dayViewLayout.constant > view.bounds.width / 2 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.dayViewLayout.constant = self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: { (finish) in
                        self.dayViewLayout.constant = 0
                        self.view.layoutIfNeeded()
                })
                return
            }
            
            // Center
            fallthrough
        default:
            UIView.animate(withDuration: 0.2) {
                self.dayViewLayout.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
}
