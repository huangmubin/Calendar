//
//  NightSky.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/19.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class NightSky: UIView {

    func update() {
        switch CalendarInfo().hour {
        case 0 ..< 6, 18 ..< 25:
            self.isHidden = false
        default:
            self.isHidden = true
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            func drawStars(countRange: Range<Int>, alpha: CGFloat, yS: CGFloat, yE: CGFloat) {
                let stars = Tools.randomInRange(range: countRange)
                context.setFillColor(UIColor.white.withAlphaComponent(alpha).cgColor)
                for _ in 0 ..< stars {
                    let x = CGFloat(Tools.randomInRange(range: 0 ..< Int(rect.width)))
                    let y = CGFloat(Tools.randomInRange(range: Int(rect.height * yS) ..< Int(rect.height * yE)))
                    let r = CGFloat(Tools.randomInRange(range: 5 ..< 10)) / 10
                    context.addArc(center: CGPoint(x: x, y: y), radius: r, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
                    context.fillPath()
                }
            }
            
            drawStars(countRange: 10 ..< 20, alpha: 0.5, yS: 0.0, yE: 0.2)
            drawStars(countRange: 60 ..< 80, alpha: 1.0, yS: 0.2, yE: 0.6)
            drawStars(countRange: 20 ..< 40, alpha: 0.7, yS: 0.6, yE: 0.8)
            drawStars(countRange: 10 ..< 20, alpha: 0.5, yS: 0.8, yE: 1.0)
        }
    }

}
