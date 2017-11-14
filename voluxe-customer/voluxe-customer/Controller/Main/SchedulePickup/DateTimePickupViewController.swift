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
    private var maxDate = Date()
    
    private let hoursView = UIView(frame: .zero)
    private let firstHourButton = VLButton(type: .BlueSecondaryWithBorder, title: (.NineToTwelve as String).uppercased(), actionBlock: nil)
    private let secondHourButton = VLButton(type: .BlueSecondaryWithBorder, title: (.TwelveToThree as String).uppercased(), actionBlock: nil)
    private let thirdHourButton = VLButton(type: .BlueSecondaryWithBorder, title: (.ThreeToSix as String).uppercased(), actionBlock: nil)
    
    override func setupViews() {
        super.setupViews()
        
        firstHourButton.setActionBlock {
            self.firstHourClicked()
        }
        
        secondHourButton.setActionBlock {
            self.secondHourClicked()
        }
        
        thirdHourButton.setActionBlock {
            self.thirdHourClicked()
        }
        
        containerView.addSubview(firstMonthHeader)
        containerView.addSubview(hoursView)
        
        hoursView.addSubview(firstHourButton)
        hoursView.addSubview(secondHourButton)
        hoursView.addSubview(thirdHourButton)
        
        initCalendar()
        
        hoursView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        firstHourButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(VLButton.secondaryHeight)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
        }
        
        thirdHourButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(VLButton.secondaryHeight)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
        }
        
        secondHourButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(VLButton.secondaryHeight)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
        }
        
        calendar.snp.makeConstraints { make in
            make.bottom.equalTo(hoursView.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(229)
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
        
        maxDate = Calendar.current.date(byAdding: .month, value: 1, to: todaysDate)!
        
        let calendar = FSCalendar(frame: .zero)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        containerView.addSubview(calendar)
        
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.headerTitleFont = .volvoSansLightBold(size: 12)
        calendar.appearance.titleFont = .volvoSansLightBold(size: 12)
        calendar.appearance.headerTitleColor = .luxeGray()
        calendar.appearance.caseOptions = FSCalendarCaseOptions.headerUsesUpperCase
        calendar.appearance.borderSelectionColor = .luxeOrange()
        calendar.appearance.borderDefaultColor = .luxeDeepBlue()
        calendar.appearance.selectionColor = .luxeOrange()
        calendar.appearance.titleDefaultColor = .luxeDeepBlue()
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.borderRadius = 0

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
                let firstMonth = self.monthFormatter.string(from: self.minimumDate(for: calendar)).uppercased()
                self.firstMonthHeader.text = self.monthFormatter.string(from: self.minimumDate(for: calendar)).uppercased()
                if header.titleLabel.text == firstMonth {
                    self.firstMonthHeader.isHidden = true
                }
                
                var nextDay = self.todaysDate
                while (!self.dateIsSelectable(date: nextDay)) {
                    nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay)!
                }
                
                self.calendar(self.calendar, shouldSelect: nextDay, at: .current)
                self.calendar.select(nextDay)
                self.selectFirstEnabledButton()
            }
            self.calendar.animateAlpha(show: true)
        })
        
    }
    
    
    // MARK: Private Methods

    @objc func empty(_ sender:UIPanGestureRecognizer){
        print("empty")
    }
    
    @objc func firstHourClicked(){
        print("firstHourClicked")
        setButtonEnabled(enable: firstHourButton.isEnabled, selected: true, button: firstHourButton)
        setButtonEnabled(enable: secondHourButton.isEnabled, selected: false, button: secondHourButton)
        setButtonEnabled(enable: thirdHourButton.isEnabled, selected: false, button: thirdHourButton)
    }
    
    @objc func secondHourClicked(){
        print("secondHourClicked")
        setButtonEnabled(enable: firstHourButton.isEnabled, selected: false, button: firstHourButton)
        setButtonEnabled(enable: secondHourButton.isEnabled, selected: true, button: secondHourButton)
        setButtonEnabled(enable: thirdHourButton.isEnabled, selected: false, button: thirdHourButton)
    }
    
    @objc func thirdHourClicked(){
        print("thirdHourClicked")
        setButtonEnabled(enable: firstHourButton.isEnabled, selected: false, button: firstHourButton)
        setButtonEnabled(enable: secondHourButton.isEnabled, selected: false, button: secondHourButton)
        setButtonEnabled(enable: thirdHourButton.isEnabled, selected: true, button: thirdHourButton)
    }
    
    func dateIsSelectable(date: Date) -> Bool {
        if !date.isWeekend {
            return hasAvailabilities(date: date)
        }
        return false
    }
    
    func hasAvailabilities(date: Date) -> Bool {
        if date.isToday {
            if todaysDate.hour < 17 {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func updateButtons(date: Date) {
        if date.isToday {
            if todaysDate.hour > 18 {
                setButtonEnabled(enable: false, selected: false, button: firstHourButton)
                setButtonEnabled(enable: false, selected: false, button: secondHourButton)
                setButtonEnabled(enable: false, selected: false, button: thirdHourButton)
            } else if todaysDate.hour > 14 {
                setButtonEnabled(enable: false, selected: false, button: firstHourButton)
                setButtonEnabled(enable: false, selected: false, button: secondHourButton)
                setButtonEnabled(enable: true, selected: false, button: thirdHourButton)
            } else if todaysDate.hour > 11 {
                setButtonEnabled(enable: false, selected: false, button: firstHourButton)
                setButtonEnabled(enable: true, selected: false, button: secondHourButton)
                setButtonEnabled(enable: true, selected: false, button: thirdHourButton)
            } else {
                setButtonEnabled(enable: true, selected: false, button: firstHourButton)
                setButtonEnabled(enable: true, selected: false, button: secondHourButton)
                setButtonEnabled(enable: true, selected: false, button: thirdHourButton)
            }
        } else {
            setButtonEnabled(enable: true, selected: false, button: firstHourButton)
            setButtonEnabled(enable: true, selected: false, button: secondHourButton)
            setButtonEnabled(enable: true, selected: false, button: thirdHourButton)
        }
    }
    
    func selectFirstEnabledButton() {
        if firstHourButton.isEnabled {
            firstHourClicked()
        } else if secondHourButton.isEnabled {
            secondHourClicked()
        } else if thirdHourButton.isEnabled {
            thirdHourClicked()
        }
    }
    
    func setButtonEnabled(enable: Bool, selected: Bool, button: VLButton) {
        button.isEnabled = enable
        if selected {
            button.setType(type: .BlueSecondarySelected)
        } else if enable {
            button.setType(type: .BlueSecondaryWithBorder)
        } else {
            button.setType(type: .BlueSecondaryWithBorderDisabled)

        }
    }
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
   
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return maxDate
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return todaysDate
    }

    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        let selectable = dateIsSelectable(date: date)
        updateButtons(date: date)
        selectFirstEnabledButton()
        return selectable
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    
}

