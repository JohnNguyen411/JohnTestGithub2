//
//  DateTimePickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DateTimePickupViewController: VLPresentrViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    static let hourButtonWidth = 80
    
    var delegate: PickupDateDelegate?
    var realm: Realm?
    
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
    private var slotViews: [VLButton] = []
    
    private var currentSlots: Results<DealershipTimeSlot>?
    
    override init() {
        super.init()
        realm = try? Realm()
        getTimeSlots()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTimeSlots() {
        if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
            DealershipAPI().getDealershipTimeSlot(dealershipId: dealership.id).onSuccess { result in
                if let slots = result?.data?.result {
                    if let realm = self.realm {
                        try? realm.write {
                            realm.add(slots, update: true)
                        }
                    }
                    self.showCalendar()
                } else {
                    // todo show error
                    
                }
                }.onFailure { error in
                    // todo show error
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        containerView.addSubview(firstMonthHeader)
        containerView.addSubview(hoursView)
        
        initCalendar()
        
        hoursView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        calendar.snp.makeConstraints { make in
            make.bottom.equalTo(hoursView.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(270)
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
        return (360) + VLPresentrViewController.baseHeight + 60
    }
    
    override func onButtonClick() {
        if let delegate = delegate, let currentSlots = currentSlots {
            let timeSlot = currentSlots[getButtonSelectedIndex()]
            delegate.onDateTimeSelected(timeSlot: timeSlot)
        }
    }
    
    private func initCalendar() {
        
        maxDate = Calendar.current.date(byAdding: .month, value: 1, to: todaysDate)!
        
        let calendar = FSCalendar(frame: .zero)
        calendar.rowHeight = 46
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        containerView.addSubview(calendar)
        
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.titleOffset = CGPoint(x: 0, y: 4)
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
        
        
    }
    
    private func showCalendar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.calendar.scroll(to: self.minimumDate(for: self.calendar), animated: false)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if (self.calendar.visibleStickyHeaders.count > 0) {
                let header = self.calendar.visibleStickyHeaders[0] as! FSCalendarStickyHeader
                let firstMonth = self.monthFormatter.string(from: self.minimumDate(for: self.calendar)).uppercased()
                self.firstMonthHeader.text = self.monthFormatter.string(from: self.minimumDate(for: self.calendar)).uppercased()
                if header.titleLabel.text == firstMonth {
                    self.firstMonthHeader.isHidden = true
                }
                
                var selectedDate: Date?
                // select preselected date, otherwise fallback to next day
                if StateServiceManager.sharedInstance.isPickup() {
                    selectedDate = RequestedServiceManager.sharedInstance.getPickupTimeSlot()?.from
                } else {
                    selectedDate = RequestedServiceManager.sharedInstance.getDropoffTimeSlot()?.from
                }
                
                if selectedDate == nil {
                    var nextDay = self.todaysDate
                    var skippedDays = 0
                    while (!self.dateIsSelectable(date: nextDay) && skippedDays < 30) {
                        nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay)!
                        skippedDays += 1
                    }
                    selectedDate = nextDay
                }
                
                if let selectedDate = selectedDate {
                    _ = self.calendar(self.calendar, shouldSelect: selectedDate, at: .current)
                    self.calendar.select(selectedDate)
                }
                self.selectFirstEnabledButton()
            }
            self.calendar.animateAlpha(show: true)
        })
    }
    
    
    // MARK: Private Methods
    
    @objc func empty(_ sender:UIPanGestureRecognizer){
        Logger.print("empty")
    }
    
    @objc func slotClicked(viewIndex: Int, slot: DealershipTimeSlot) {
        for (index, view) in slotViews.enumerated() {
            setButtonEnabled(enable: view.isEnabled, selected: index == viewIndex, button: view)
        }
    }
    
    func dateIsSelectable(date: Date) -> Bool {
        return hasAvailabilities(date: date)
    }
    
    func hasAvailabilities(date: Date) -> Bool {
        if let slots = getSlotsForDate(date: date) {
            return slots.count > 0
        }
        return false
    }
    
    private func getSlotsForDate(date: Date) -> Results<DealershipTimeSlot>? {
        if let realm = realm, let dealership = RequestedServiceManager.sharedInstance.getDealership() {
            var from: NSDate = date.beginningOfDay() as NSDate
            var to: NSDate = date.endOfDay() as NSDate
            
            if date == self.todaysDate {
                from = date as NSDate
                to = date as NSDate
            }
            
            let predicate = NSPredicate(format: "from <= %@ AND to >= %@ AND dealershipId = %d", from, to, dealership.id)
            let slots = realm.objects(DealershipTimeSlot.self).filter(predicate)
            Logger.print("from: \(from) to: \(to)")
            Logger.print("hasAvailabilities \(slots.count) for date: \(date)")
            Logger.print("predicate \(predicate)")
            return slots
        }
        return nil
    }
    
    func updateSlots(slots: Results<DealershipTimeSlot>?) {
        // remove time slots view
        for view in hoursView.subviews {
            view.removeFromSuperview()
        }
        
        guard let slots = slots, slots.count > 0 else {
            return
        }
        
        slotViews = []
        currentSlots = slots
        
        for (index, slot) in slots.enumerated() {
            let slotButton = VLButton(type: .BlueSecondaryWithBorder, title: slot.getTimeSlot(calendar: Calendar.current, showAMPM: false), actionBlock: nil)
            slotButton.setActionBlock {
                self.slotClicked(viewIndex: index, slot: slot)
            }
            slotViews.append(slotButton)
            hoursView.addSubview(slotButton)
        }
        // todo add constraints
        
        hoursView.snp.remakeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.width.equalTo((DateTimePickupViewController.hourButtonWidth + 10) * slots.count)
            make.centerX.equalToSuperview()
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        var prevView: UIView? = nil
        for view in hoursView.subviews {
            
            view.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(prevView == nil ? hoursView.snp.left : prevView!.snp.right).offset(prevView == nil ? 0 : 10)
                make.height.equalTo(VLButton.secondaryHeight)
                make.width.equalToSuperview().dividedBy(hoursView.subviews.count).offset(-10)
            }
            
            prevView = view
        }
        
    }
    
    
    func updateButtons(date: Date) {
        for slotView in slotViews {
            setButtonEnabled(enable: true, selected: false, button: slotView)
        }
    }
    
    func selectFirstEnabledButton() {
        guard let currentSlots = currentSlots else {
            return
        }
        for (index, slotView) in slotViews.enumerated() {
            if slotView.isEnabled {
                slotClicked(viewIndex: index, slot: currentSlots[index])
                break
            }
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
    
    func buttonIsSelected(button: VLButton) -> Bool {
        if let type = button.type {
            return type == .BlueSecondarySelected
        }
        return false
    }
    
    func getButtonSelectedIndex() -> Int {
        for (index, slotView) in slotViews.enumerated() {
            if buttonIsSelected(button: slotView) {
                return index
            }
        }
        return -1
    }
    
    func minMax(index: Int) -> (min: Int, max: Int) {
        if index == 0 {
            return (9, 12)
        } else if index == 1 {
            return (12, 15)
        } else if index == 2 {
            return (15, 18)
        }
        return (0, 0)
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
        if selectable {
            updateSlots(slots: getSlotsForDate(date: date))
            updateButtons(date: date)
            selectFirstEnabledButton()
        }
        return selectable
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let cell = (cell as! VLCalendarCell)
        if dateIsSelectable(date: date) {
            cell.isEnabled = true
        } else {
            cell.isEnabled = false
        }
    }
}


// MARK: protocol PickupDateDelegate
protocol PickupDateDelegate: class {
    func onDateTimeSelected(timeSlot: DealershipTimeSlot)
}

