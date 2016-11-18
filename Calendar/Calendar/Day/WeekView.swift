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
    var todaySection = 0
    var weekSection = 0
    
    func deployLoop(origin: Date) {
        self.origin = origin
        selectSection = Int((current.timeIntervalSince1970 - origin.timeIntervalSince1970) / 86400)
        weekSection = selectSection
        
        size = CGSize(width: UIScreen.main.bounds.width / 7, height: 40)
        loopWeek.initDeploy(delegate: self)
        
        let today = CalendarInfo().firstTimeInDay()!
        todaySection = Int((today.timeIntervalSince1970 - origin.timeIntervalSince1970) / 86400)
    }
    
    func updateCurrent(date: Date) {
        // Update Current
        self.current = date
        selectSection = Int((current.timeIntervalSince1970 - origin.timeIntervalSince1970) / 86400)
        
        // Changed Cell
        updateCellSelect()
        
        // Scroll To Visible
        if !loopWeek.visibleItems.contains(where: { $0.section == self.selectSection }) {
            let select = selectSection < 0 ? selectSection - 6 : selectSection
            let offset = select / 7 * 7
            loopWeek.scrollToOffset(offset: offset, animated: true)
        }
        
        self.weekSection = selectSection - self.loopWeek.firstVisibleItem!.section
        self.weekSection = (self.weekSection + 7) % 7
    }
    
    // MARK: - Calendar Change
    
    @IBAction func calendarChanged(_ sender: UIButton) {
        
    }
}

// MARK: - View Update

extension WeekView {
    
    func updateCellSelect() {
        for cell in loopWeek.visibleCells {
            let cell = cell as! WeekLoopCell
            cell.select = (cell.section == selectSection)
            cell.update()
        }
    }
    
}

// MARK: - Loop Collection View Delegate

extension WeekView: LoopCollectionViewDelegate {
    
    func loopCollection(loopView: LoopCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func loopCollection(loopView: LoopCollectionView, cellForItem cell: LoopCollectionViewCell, atSection section: Int, row: Int) {
        
    }
    func loopCollection(loopView: LoopCollectionView, headerForItem header: UICollectionReusableView, atSection section: Int) {
        
    }
    
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
        updateCellSelect()
        self.current = self.origin.addingTimeInterval(Double(section) * 86400)
        delegate?.weekView(selected: self.current)
        self.weekSection = section - self.loopWeek.firstVisibleItem!.section
    }
    
    // MARK: Scroll
    
    func loopCollection(loopView: LoopCollectionView, didEndScrollingAnimation inSection: Int) {
        let cell = self.loopWeek.visibleItems[weekSection] as! WeekLoopCell
        cell.select = true
        cell.update()
        
        self.current = self.origin.addingTimeInterval(Double(cell.section) * 86400)
        delegate?.weekView(selected: self.current)
    }
}
