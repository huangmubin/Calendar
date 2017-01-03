//
//  ClockInView.swift
//  Calendar
//
//  Created by 黄穆斌 on 2016/11/22.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

// MARK: - Clock In View Delegate

protocol ClockInViewDateModel {
    var habit: String { get set }
    var clockIn: Bool { get set }
}

protocol ClockInViewDelegate: NSObjectProtocol {
    var clockInDates: [ClockInViewDateModel] { get set }
    func clockInView(view: ClockInView, clockIn: Bool, habit: String, at: Int)
    func clockInView(view: ClockInView, insert habit: String) -> Bool
    func clockInView(view: ClockInView, delete habit: String, at: Int) -> Bool
}

// MARK: - Clock In View

class ClockInView: UIView {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var textInputView: TextInputView! {
        didSet {
            textInputView.delegate = self
            NotificationCenter.default.addObserver(self, selector: #selector(textInputViewKeyBoardShowNotify), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(textInputViewKeyBoardHideNotify), name: .UIKeyboardWillHide, object: nil)
        }
    }
    
    weak var delegate: ClockInViewDelegate?
    @IBOutlet weak var textInputViewBottomLayout: NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Table View Date Srouce

extension ClockInView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.clockInDates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClockInCell", for: indexPath)
        cell.textLabel?.text = delegate?.clockInDates[indexPath.row].habit
        cell.accessoryType = delegate?.clockInDates[indexPath.row].clockIn == true ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = delegate?.clockInDates[indexPath.row].habit
        cell.accessoryType = delegate?.clockInDates[indexPath.row].clockIn == true ? .checkmark : .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = (cell.accessoryType == .none ? .checkmark : .none)
            if let data = delegate?.clockInDates[indexPath.row] {
                delegate?.clockInView(view: self, clockIn: cell.accessoryType == .checkmark, habit: data.habit, at: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if let data = delegate?.clockInDates[indexPath.row] {
                if delegate?.clockInView(view: self, delete: data.habit, at: indexPath.row) == true {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
}


// MARK: - Text Input View Delegate

extension ClockInView: TextInputViewDelegate {
    
    func textInputView(input: TextInputView, define text: String) {
        if delegate?.clockInView(view: self, insert: text) == true {
            if let row = delegate?.clockInDates.count {
                tableView.insertRows(at: [IndexPath(row: row - 1, section: 0)], with: .automatic)
            }
        }
    }
    
    func textInputViewKeyBoardShowNotify(object: Notification) {
        if let value = object.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.textInputViewBottomLayout.constant = value.cgRectValue.size.height
                self.layoutIfNeeded()
            })
        }
    }
    
    func textInputViewKeyBoardHideNotify(object: Notification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.textInputViewBottomLayout.constant = 0
            self.layoutIfNeeded()
        })
    }
    
}
