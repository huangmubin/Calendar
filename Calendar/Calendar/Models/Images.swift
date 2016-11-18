//
//  Images.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/16.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class Images {

    
    // MARK: - Init
    
    static let `default` = Images()
    
    init() {
        if !UserDefaults.standard.bool(forKey: "Images_First_Deploy") {
            try? FileManager.default.createDirectory(atPath: Images.Path.interface.folder, withIntermediateDirectories: true, attributes: nil)
            try? FileManager.default.createDirectory(atPath: Images.Path.weather.folder, withIntermediateDirectories: true, attributes: nil)
            UserDefaults.standard.set(true, forKey: "Images_First_Deploy")
        }
    }
    
}

// MARK: - Draw

extension Images {
    
    func draw(name: String) {
        switch name {
        case "":
            break
        default:
            break
        }
    }
    
    func drawWeekDayBack() {
        
    }
    
}

// MARK: - Path

extension Images {
    enum Path: String {
        case interface = "/Documents/Images/Interface/"
        case weather   = "/Documents/Images/Weather/"
        
        var folder: String { return NSHomeDirectory() + rawValue }
        subscript(name: String) -> String {
            return NSHomeDirectory() + rawValue + name
        }
    }
}
