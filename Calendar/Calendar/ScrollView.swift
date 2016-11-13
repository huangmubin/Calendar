//
//  ScrollView.swift
//  Calendar
//
//  Created by 黄穆斌 on 16/11/12.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    // MARK: - Property
    
    @IBInspectable var direction: UICollectionViewScrollDirection = UICollectionViewScrollDirection.vertical
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDeploy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDeploy()
    }
    
    private func initDeploy() {
        
    }

}
