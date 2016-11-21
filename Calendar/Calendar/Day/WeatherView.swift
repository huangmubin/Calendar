//
//  WeatherView.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/19.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

// MARK: - Weather

enum Weather {
    case sunny
    case cloudy
}

// MARK: - Weather View

class WeatherView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        deploy()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        deploy()
    }
    private func deploy() {
        addSubview(imageView)
    }
    
    // MARK: - Views
    
    var imageView: UIImageView = UIImageView()
    var subImage: UIImage? {
        set { self.imageView.image = newValue }
        get { return self.imageView.image }
    }
    
    // MARK: - Override
    
    override var frame: CGRect {
        didSet { self.imageView.frame = self.bounds }
    }
    override var bounds: CGRect {
        didSet { self.imageView.frame = self.bounds }
    }
    
    
}
