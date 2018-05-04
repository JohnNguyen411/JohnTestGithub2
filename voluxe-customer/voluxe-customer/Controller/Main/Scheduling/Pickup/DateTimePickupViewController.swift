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
import SwiftEventBus

class DateTimePickupViewController: VLPresentrViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    private static let hourButtonWidth = 80
    
    private static let rowHeight = 46

    private static let smallCalendarHeight = 180
    private static let tallCalendarHeight = 220
    
    var delegate: PickupDateDelegate?
    var realm: Realm?
    var dealership: Dealership?
    let vehicle: Vehicle
    
    let firstMonthHeader: UILabel = {
        let firstMonthHeader = UILabel()
        firstMonthHeader.textColor = .luxeGray()
        firstMonthHeader.font = .volvoSansLightBold(size: 12)
        firstMonthHeader.textAlignment = .center
        firstMonthHeader.addUppercasedCharacterSpacing()
        return firstMonthHeader
    }()
    
    let timeSlotsHeader: UILabel = {
        let timeSlotsHeader = UILabel()
        timeSlotsHeader.textColor = .luxeGray()
        timeSlotsHeader.font = .volvoSansLightBold(size: 12)
        timeSlotsHeader.textAlignment = .center
        timeSlotsHeader.text = (.PickupTimes as String).uppercased()
        timeSlotsHeader.addUppercasedCharacterSpacing()
        return timeSlotsHeader
    }()
    
    let noDateLabel: UILabel = {
        let noDateLabel = UILabel()
        noDateLabel.textColor = .black
        noDateLabel.font = .volvoSansLightBold(size: 12)
        noDateLabel.textAlignment = .center
        noDateLabel.text = String.NoDatesForDealership
        noDateLabel.numberOfLines = 0
        return noDateLabel
    }()
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    private let todaysDate = Date()
    private var maxDate = Date()
    
    private var isPickup = true
    
    private let loanerContainerView = UIView(frame: .zero)
    
    private let loanerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.volvoSansLightBold(size: 16)
        label.text = .DatesLoanersOnly
        return label
    }()
    
    private let loanerSwitch = UISwitch(frame: .zero)
    
    private var loanerViewHeight = 48
    private var hoursViewHeight = VLButton.secondaryHeight
    private var calendarViewHeight = smallCalendarHeight
    
    private let hoursView = UIView(frame: .zero)
    private var slotViews: [VLButton] = []
    private var weekdayViews = UIView(frame: .zero)
    
    private var currentSlots: Results<DealershipTimeSlot>?
    
    init(vehicle: Vehicle, title: String, buttonTitle: String) {
        self.vehicle = vehicle
        isPickup = StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id)
        loanerViewHeight = isPickup ? 48 : 0
        var currentDealership = RequestedServiceManager.sharedInstance.getDealership()
        if currentDealership == nil {
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                currentDealership = booking.dealership
            }
        }
        dealership = currentDealership
        
        super.init(title: title, buttonTitle: buttonTitle, screenName: isPickup ? AnalyticsConstants.paramNameSchedulingIBDateTimeModalView : AnalyticsConstants.paramNameSchedulingOBDateTimeModalView)
        
        realm = try? Realm()
        getTimeSlots()
        if let loaner = RequestedServiceManager.sharedInstance.getLoaner() {
            loanerSwitch.setOn(loaner, animated: false)
        } else {
            loanerSwitch.setOn(false, animated: false)
        }

        
        loanerSwitch.addTarget(self, action: #selector(switchChanged(uiswitch:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTimeSlots() {
        showLoading(loading: true)
        if Config.sharedInstance.isMock {
            
            var selectedDate: Date?
            // select preselected date, otherwise fallback to next day
            if isPickup {
                selectedDate = RequestedServiceManager.sharedInstance.getPickupTimeSlot()?.from
            } else {
                selectedDate = RequestedServiceManager.sharedInstance.getDropoffTimeSlot()?.from
            }
            
            // clear DB slots
            if let realm = self.realm, selectedDate == nil {
                let slots = realm.objects(DealershipTimeSlot.self)
                try? realm.write {
                    realm.delete(slots)
                }
            }
            self.showCalendar()
            
            return
        }
        
        if let dealership = self.dealership {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            let from = formatter.string(from: todaysDate.beginningOfDay())
            let to = formatter.string(from: maxDate.endOfDay())
            
            let timeSlotType = "driver"
            
            var loaner = false
            if let selectedLoaner = RequestedServiceManager.sharedInstance.getLoaner() {
                loaner = selectedLoaner
            }
            
            DealershipAPI().getDealershipTimeSlot(dealershipId: dealership.id, type: timeSlotType, loaner: loaner, from: from, to: to).onSuccess { result in
                if let slots = result?.data?.result {
                    VLAnalytics.logEventWithName(AnalyticsConstants.eventApiGetDealershipTimeslotsSuccess, screenName: self.screenName)
                    if let realm = self.realm {
                        try? realm.write {
                            realm.add(slots, update: true)
                        }
                    }
                    self.showCalendar()
                } else {
                    VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiGetDealershipTimeslotsFail, screenName: self.screenName, errorCode: result?.error?.code)
                }
                }.onFailure { error in
                    VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiGetDealershipTimeslotsFail, screenName: self.screenName, statusCode: error.responseCode)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        if isPickup {
            if let type = RequestedServiceManager.sharedInstance.getPickupRequestType(), type == .advisorPickup {
                timeSlotsHeader.text = (.DropOffTimes as String).uppercased()
            } else {
                timeSlotsHeader.text = (.PickupTimes as String).uppercased()
            }
        } else {
            if let type = RequestedServiceManager.sharedInstance.getDropoffRequestType(), type == .advisorDropoff {
                timeSlotsHeader.text = (.PickupTimes as String).uppercased()
            } else {
                timeSlotsHeader.text = (.DeliveryTimes as String).uppercased()
            }
        }
        
        loanerContainerView.isHidden = !isPickup
        
        containerView.addSubview(firstMonthHeader)
        containerView.addSubview(hoursView)
        containerView.addSubview(timeSlotsHeader)
        containerView.addSubview(loanerContainerView)
        containerView.addSubview(noDateLabel)
        noDateLabel.isHidden = true
        
        let separatorOne = UIView(frame: .zero)
        separatorOne.backgroundColor = .luxeLightestGray()
        separatorOne.clipsToBounds = false
        let separatorTwo = UIView(frame: .zero)
        separatorTwo.backgroundColor = .luxeLightestGray()
        separatorTwo.clipsToBounds = false
        
        loanerContainerView.addSubview(separatorOne)
        loanerContainerView.addSubview(separatorTwo)
        loanerContainerView.addSubview(loanerLabel)
        loanerContainerView.addSubview(loanerSwitch)
        
        containerView.addSubview(weekdayViews)
        
        initCalendar()
        
        hoursView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-28)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        timeSlotsHeader.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(hoursView.snp.top).offset(-5)
            make.height.equalTo(20)
        }
        
        calendar.snp.makeConstraints { make in
            make.bottom.equalTo(timeSlotsHeader.snp.top).offset(-28)
            make.left.right.equalToSuperview()
            make.height.equalTo(calendarViewHeight)
        }
        
        noDateLabel.snp.makeConstraints { make in
            make.center.equalTo(calendar)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        firstMonthHeader.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(calendar.snp.top).offset(-5)
            make.height.equalTo(20)
        }
        
        weekdayViews.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(firstMonthHeader.snp.top).offset(-5)
            make.height.equalTo(20)
        }
        
        loanerContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(loanerViewHeight)
            make.bottom.equalTo(weekdayViews.snp.top).offset(-20)
        }
        
        separatorOne.snp.makeConstraints { make in
            make.right.equalTo(self.view)
            make.left.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        loanerSwitch.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
        }
        
        loanerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.height.equalTo(loanerSwitch)
        }
        
        separatorTwo.snp.makeConstraints { make in
            make.right.equalTo(self.view)
            make.left.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(loanerContainerView.snp.top).offset(-8)
            make.height.equalTo(20)
        }
    }
    
    override func height() -> Int {
        var height = (169 + calendarViewHeight) + baseHeight + hoursViewHeight + loanerViewHeight
        if !noDateLabel.isHidden {
            height += 5
        }
        return height
    }
    
    override func onButtonClick() {
        if let delegate = delegate, let currentSlots = currentSlots {
            let timeSlot = currentSlots[getButtonSelectedIndex()]
            delegate.onDateTimeSelected(timeSlot: timeSlot)
        }
    }
    
    private func initWeekDayView() {
        
        let cell = self.calendar.cell(for: todaysDate, at: .current)
        let frame = cell!.frame
        
        var prevView: UIView? = nil
        
        for weekday in Calendar.current.veryShortWeekdaySymbols {
            let label = UILabel(frame: .zero)
            label.text = weekday
            label.textAlignment = .center
            label.textColor = .luxeGray()
            label.font = .volvoSansLightBold(size: 12)
            
            weekdayViews.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(prevView == nil ? weekdayViews.snp.left : prevView!.snp.right)
                make.width.equalTo(frame.width)
            }
            
            prevView = label
        }
    }
    
    private func initCalendar() {
        
        maxDate = Calendar.current.date(byAdding: .day, value: 3*7, to: todaysDate)!
        let weekday = Calendar.current.component(.weekday, from: maxDate) // 1 is sunday for Gregorian
        let weekMonth = Calendar.current.component(.weekOfMonth, from: maxDate)

        let day = Calendar.current.component(.day, from: maxDate)
        if day >= 1 && day <= 7 && weekMonth == 1 {
            maxDate = Calendar.current.date(byAdding: .day, value: -day, to: maxDate)!
        } else {
            maxDate = Calendar.current.date(byAdding: .day, value: 7-weekday+1, to: maxDate)!
        }
        
        let monthMax = Calendar.current.component(.month, from: maxDate)
        let monthCurrent = Calendar.current.component(.month, from: todaysDate)
        if monthMax != monthCurrent {
            calendarViewHeight = DateTimePickupViewController.tallCalendarHeight
        } else {
            calendarViewHeight = DateTimePickupViewController.smallCalendarHeight
        }
        
        let calendar = FSCalendar(frame: .zero)
        calendar.rowHeight = CGFloat(DateTimePickupViewController.rowHeight)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        containerView.addSubview(calendar)
        
        calendar.appearance.headerDateFormat = monthFormatter.dateFormat
        calendar.appearance.headerTitleFont = .volvoSansLightBold(size: 12)
        
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.titleOffset = CGPoint(x: 0, y: 4)
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.headerTitleFont = .volvoSansLightBold(size: 12)
        calendar.appearance.titleFont = .volvoSansLightBold(size: 12)
        calendar.appearance.headerTitleColor = .luxeGray()
        calendar.appearance.caseOptions = FSCalendarCaseOptions.headerUsesUpperCase
        calendar.appearance.borderSelectionColor = .luxeCobaltBlue()
        calendar.appearance.borderDefaultColor = .luxeCobaltBlue()
        calendar.appearance.selectionColor = .luxeCobaltBlue()
        calendar.appearance.titleDefaultColor = .luxeCobaltBlue()
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.borderRadius = 0
        
        calendar.register(VLCalendarCell.self, forCellReuseIdentifier: "cell")
        //        calendar.clipsToBounds = true // Remove top/bottom line
        
        calendar.pagingEnabled = false
        calendar.allowsMultipleSelection = false
        calendar.allowsSelection = true
        calendar.setCollectionViewScrollEnabled(false)
        calendar.placeholderType = .none
                
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
            self.calendar.reloadData()
            self.calendar.scroll(to: self.minimumDate(for: self.calendar), animated: false)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            var header: FSCalendarStickyHeader? = nil
            if (self.calendar.visibleStickyHeaders.count > 0) {
                header = self.calendar.visibleStickyHeaders[0] as? FSCalendarStickyHeader
            }
            let firstMonth = self.monthFormatter.string(from: self.minimumDate(for: self.calendar)).uppercased()
            self.firstMonthHeader.text = self.monthFormatter.string(from: self.minimumDate(for: self.calendar)).uppercased()
            if let header = header, header.titleLabel.text == firstMonth {
                self.firstMonthHeader.isHidden = true
            }
            self.firstMonthHeader.addUppercasedCharacterSpacing()
            
            var selectedDate: Date?
            // select preselected date, otherwise fallback to next day
            var selectedTimeSlot: DealershipTimeSlot? = nil
            if self.isPickup {
                selectedTimeSlot = RequestedServiceManager.sharedInstance.getPickupTimeSlot()
                selectedDate = selectedTimeSlot?.from
            } else {
                selectedTimeSlot = RequestedServiceManager.sharedInstance.getDropoffTimeSlot()
                selectedDate = selectedTimeSlot?.from
            }
            
            if selectedDate == nil {
                var nextDay = self.todaysDate
                
                // Fake slots for Mock
                if Config.sharedInstance.isMock {
                    if let dealership = self.dealership {
                        var mockDay = self.todaysDate
                        try? self.realm?.write {
                            for _ in 0...30 {
                                let timeSlot = DealershipTimeSlot.mockTimeSlotForDate(dealershipId: dealership.id, date: mockDay)
                                mockDay = Calendar.current.date(byAdding: .day, value: 1, to: mockDay)!
                                self.realm?.add(timeSlot)
                            }
                        }
                    }
                }
                
                //var skippedDays = 0
                while (!self.dateIsSelectable(date: nextDay) && nextDay <= self.maxDate) {
                    nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay)!
                }
                selectedDate = nextDay
            }
            
            if selectedDate != nil && selectedDate! > self.maxDate {
                selectedDate = nil
            }
            
            if let selectedDate = selectedDate {
                _ = self.calendar(self.calendar, shouldSelect: selectedDate, at: .current)
                self.calendar.select(selectedDate)
                self.showError(error: false)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: {
                    self.calendar.scroll(to: self.maxDate, animated: false)
                })
                self.showError(error: true)
            }
            
            self.selectTimeslot(timeSlot: selectedTimeSlot)
            
            self.initWeekDayView()
            self.showLoading(loading: false)
            if let _ = selectedDate {
                self.calendar.animateAlpha(show: true)
            }
        })
    }
    
    
    // MARK: Private Methods
    
    private func showError(error: Bool) {
        
        self.noDateLabel.isHidden = !error
        self.calendar.isHidden = error
        self.weekdayViews.isHidden = error
        self.firstMonthHeader.isHidden = error
        self.timeSlotsHeader.isHidden = error
    }
    
    @objc internal func switchChanged(uiswitch: UISwitch) {
        RequestedServiceManager.sharedInstance.setLoaner(loaner: uiswitch.isOn)
        getTimeSlots()
        SwiftEventBus.post("onLoanerChanged")
    }
    
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
        if Config.sharedInstance.isMock {
            return true
        }
        if let slots = getSlotsForDate(date: date) {
            return slots.count > 0
        }
        return false
    }
    
    private func getSlotsForDate(date: Date) -> Results<DealershipTimeSlot>? {
        if let realm = realm, let dealership = self.dealership {
            var from: NSDate = date.beginningOfDay() as NSDate
            var to: NSDate = date.endOfDay() as NSDate
            
            var predicate = NSPredicate(format: "from >= %@ AND to <= %@ AND dealershipId = %d", from, to, dealership.id)
            
            if date.isToday {
                from = self.todaysDate as NSDate
                from = from.addingTimeInterval(2*60*60) // add a 2 hours delay
                to = date.endOfDay() as NSDate
                predicate = NSPredicate(format: "to >= %@ AND to <= %@ AND dealershipId = %d", from, to, dealership.id)
            }
            
            let slots = realm.objects(DealershipTimeSlot.self).filter(predicate)
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
            // limit to 6 timeslots
            if index > 5 {
                break
            }
            let slotButton = VLButton(type: .blueSecondaryWithBorder, title: slot.getTimeSlot(calendar: Calendar.current, showAMPM: true, shortSymbol: true), eventName: AnalyticsConstants.eventClickTimeslot, screenName: screenName)
            slotButton.setActionBlock {
                self.slotClicked(viewIndex: index, slot: slot)
            }
            slotButton.tag = slot.id
            slotViews.append(slotButton)
            hoursView.addSubview(slotButton)
        }
        
        hoursViewHeight = slots.count > 3 ? (VLButton.secondaryHeight * 2) + 10 : VLButton.secondaryHeight
        
        hoursView.snp.remakeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-20)
            make.width.centerX.equalToSuperview()
            make.height.equalTo(hoursViewHeight)
        }
        
        var prevView: UIView? = nil
        for (index, view) in slotViews.enumerated() {
            
            if index == 3 {
                prevView = nil
            }
            
            view.snp.makeConstraints { make in
                make.top.equalTo(index <= 2 ? hoursView.snp.top : (VLButton.secondaryHeight + 10))
                make.left.equalTo(prevView == nil ? hoursView.snp.left : prevView!.snp.right).offset(prevView == nil ? 0 : 10)
                make.height.equalTo(VLButton.secondaryHeight)
                make.width.equalToSuperview().dividedBy(3).offset(-22/3)
            }
            
            prevView = view
        }
        
        if let delegate = delegate {
            delegate.onSizeChanged()
        }
        
    }
    
    
    func updateButtons(date: Date) {
        for slotView in slotViews {
            setButtonEnabled(enable: true, selected: false, button: slotView)
        }
    }
    
    func selectTimeslot(timeSlot: DealershipTimeSlot?) {
        guard let timeSlot = timeSlot else {
            selectFirstEnabledButton()
            return
        }
        guard let currentSlots = currentSlots else {
            return
        }
        for (index, slotView) in slotViews.enumerated() {
            if slotView.isEnabled, slotView.tag == timeSlot.id {
                slotClicked(viewIndex: index, slot: currentSlots[index])
                break
            }
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
            button.setType(type: .blueSecondarySelected)
        } else if enable {
            button.setType(type: .blueSecondaryWithBorder)
        } else {
            button.setType(type: .blueSecondaryWithBorderDisabled)
        }
    }
    
    func buttonIsSelected(button: VLButton) -> Bool {
        if let type = button.type {
            return type == .blueSecondarySelected
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
protocol PickupDateDelegate: VLPresentrViewDelegate {
    func onDateTimeSelected(timeSlot: DealershipTimeSlot?)
}

