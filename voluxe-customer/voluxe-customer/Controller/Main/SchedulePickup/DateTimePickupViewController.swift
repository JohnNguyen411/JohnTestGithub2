//
//  DateTimePickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class DateTimePickupViewController: VLPresentrViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    let firstMonthHeader: UILabel = {
        let firstMonthHeader = UILabel()
        firstMonthHeader.textColor = .luxeGray()
        firstMonthHeader.font = .volvoSansLightBold(size: 12)
        firstMonthHeader.textAlignment = .left
        return firstMonthHeader
    }()
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    private let todaysDate = Date()
   
    
    override func setupViews() {
        super.setupViews()
        
        containerView.addSubview(firstMonthHeader)
        
        initCalendar()
        
        calendar.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        firstMonthHeader.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(calendar.snp.top).offset(-10)
            make.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(firstMonthHeader.snp.top).offset(-10)
            make.height.equalTo(25)
        }
    }
    
    override func height() -> Int {
        return (350) + VLPresentrViewController.baseHeight + 60
    }
    
    private func initCalendar() {
        let calendar = FSCalendar(frame: .zero)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        containerView.addSubview(calendar)
        
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.headerTitleFont = .volvoSansLightBold(size: 12)
        calendar.appearance.headerTitleColor = .luxeGray()
        calendar.appearance.caseOptions = FSCalendarCaseOptions.headerUsesUpperCase
        
        calendar.register(VLCalendarCell.self, forCellReuseIdentifier: "cell")
        //        calendar.clipsToBounds = true // Remove top/bottom line
        
        calendar.pagingEnabled = false
        calendar.allowsMultipleSelection = false
        calendar.allowsSelection = true
        calendar.setCollectionViewScrollEnabled(false)
        calendar.placeholderType = .none

        //calendar.setCollectionViewScrollEnabled(false)
        
        calendar.calendarWeekdayView.isHidden = true
        calendar.weekdayHeight = 0
        //calendar.preferredWeekdayHeight = 0
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.empty(_:)))
        calendar.handleScopeGesture(panGesture)
        calendar.swipeToChooseGesture.isEnabled = false // Swipe-To-Choose
        
        calendar.today = nil // Hide the today circle
        
        self.calendar = calendar
        self.calendar.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.calendar.scroll(to: self.minimumDate(for: calendar), animated: false)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if (self.calendar.visibleStickyHeaders.count > 0) {
                let header = self.calendar.visibleStickyHeaders[0] as! FSCalendarStickyHeader
                header.
                
                self.firstMonthHeader.text = self.monthFormatter.string(from: self.minimumDate(for: calendar)).uppercased()

            }
            self.calendar.animateAlpha(show: true)
        })
        
    }
    
    
    @objc func empty(_ sender:UIPanGestureRecognizer){
        print("empty")
    }
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2017/11/15")!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return todaysDate
    }

    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! VLCalendarCell)
        // Custom today circle
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
}

