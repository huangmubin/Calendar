//
//  WeekView.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/16.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

// MARK: Week View Delegate

protocol WeekViewDelegate: NSObjectProtocol {
    func weekView(selected day: Date)
}

// MARK: Week View

class WeekView: UIView {

    // MARK: Views
    
    weak var delegate: WeekViewDelegate?
    
    @IBOutlet weak var loopWeek: LoopCollectionView!
    
    // MARK: Datas
    
    var size = CGSize.zero
    var origin = Date()
    var current = Date()
    
    var selectSection = 0
    var todaySection  = 0
    var weekSection   = 0
    
    func set(weekSection: Int) {
        self.weekSection = weekSection % 7
        self.weekSection = (self.weekSection + 7) % 7
    }
    
    func deployLoop(origin: Date) {
        self.origin   = origin
        selectSection = Int((current.timeIntervalSince1970 - origin.timeIntervalSince1970) / 86400)
        weekSection = selectSection
        
        let today = CalendarInfo().firstTimeInDay()!
        todaySection = Int((today.timeIntervalSince1970 - origin.timeIntervalSince1970) / 86400)
        
        size = CGSize(width: UIScreen.main.bounds.width / 7, height: 40)
        loopWeek.initDeploy(delegate: self)
        
        let delay = DispatchTime.now() + DispatchTimeInterval.milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.updateCellSelect()
        }
    }
    
    func updateCurrent(date: Date) {
        // Update Current
        self.current = date
        selectSection = Int((current.timeIntervalSince1970 - origin.timeIntervalSince1970) / 86400)
        
        // Scroll To Visible
        if loopWeek.visibleItems.contains(where: { $0.section == self.selectSection }) {
            self.updateCellSelect()
        } else {
            let select = selectSection < 0 ? selectSection - 6 : selectSection
            let offset = select / 7 * 7
            loopWeek.scrollToOffset(offset: offset, animated: true)
        }
        
        // Update Week Section
        set(weekSection: selectSection)
    }
    
}

// MARK: - View Update

extension WeekView {
    
    func updateCellSelect() {
        for cell in loopWeek.visibleCells {
            let cell = cell as! WeekLoopCell
            cell.select = (cell.section == selectSection)
            cell.update(display: true)
        }
    }
    
}

// MARK: - Loop Collection View Delegate

extension WeekView: LoopCollectionViewDelegate {
    
    // MARK: Visible
    
    func loopCollection(loopView: LoopCollectionView, layout: UICollectionViewLayout, sizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func loopCollection(loopView: LoopCollectionView, layout: UICollectionViewLayout, sizeForItemAtSection section: Int, row: Int) -> CGSize {
        return size
    }
    
    func loopCollection(loopView: LoopCollectionView, willDisplay cell: LoopCollectionViewCell, atSection section: Int, row: Int) {
        let cell = cell as! WeekLoopCell
        let time = Double(section * 86400)
        let surplus = section % 7
        
        
        cell.light  = (surplus == 0 || surplus == 6 || surplus == -1)
        cell.select = (section == selectSection)
        cell.today  = (section == todaySection)
        
        cell.update()
        cell.update(date: origin.addingTimeInterval(time))
    }
    
    // MARK: Select
    
    func loopCollection(loopView: LoopCollectionView, didSelectItemAt section: Int, row: Int) {
        self.selectSection = section
        self.current = self.origin.addingTimeInterval(Double(section) * 86400)

        self.set(weekSection: section)
        
        updateCellSelect()
        delegate?.weekView(selected: self.current)
    }
    
    // MARK: Scroll
    
    func loopCollection(loopView: LoopCollectionView, didEndScrollingAnimation inSection: Int) {
        let cell = self.loopWeek.visibleItems[weekSection] as! WeekLoopCell
        cell.select = true
        cell.update(display: true)
        
        self.current = self.origin.addingTimeInterval(Double(cell.section) * 86400)
        delegate?.weekView(selected: self.current)
    }
}
