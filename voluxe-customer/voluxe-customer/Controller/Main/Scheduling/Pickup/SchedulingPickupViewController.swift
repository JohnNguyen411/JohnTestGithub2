//
//  SchedulingPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/3/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import MBProgressHUD

class SchedulingPickupViewController: SchedulingViewController {
    
    override func setupViews() {
        super.setupViews()
        loanerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scheduledPickupView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
    }
    
    override func fillViews() {
        
        if let timeSlot = RequestedServiceManager.sharedInstance.getPickupTimeSlot(), let date = timeSlot.from {
            let dateTime = formatter.string(from: date)
            scheduledPickupView.setTitle(title: getScheduledPickupTitle(), leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" ))", rightDescription: "")
        }
        
        if let requestLocation = RequestedServiceManager.sharedInstance.getPickupLocation() {
            pickupLocationView.setTitle(title: .PickupLocation, leftDescription: requestLocation.address!, rightDescription: "")
        }
        super.fillViews()
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
        loanerView.isEditable = true
        dealershipView.isEditable = true
        scheduledPickupView.isEditable = true
        pickupLocationView.isEditable = true
        
        if state == .schedulingService && pickupScheduleState == .start{
            // show location modal
            pickupLocationClick()
        }
        
        if state.rawValue >= ServiceState.pickupScheduled.rawValue {
            
            scheduledPickupView.animateAlpha(show: true)
            pickupLocationView.animateAlpha(show: true)
            loanerView.animateAlpha(show: true)
            
            scheduledPickupView.isUserInteractionEnabled = false
            pickupLocationView.isUserInteractionEnabled = false
            loanerView.isUserInteractionEnabled = false
            dealershipView.isUserInteractionEnabled = false
        }
    }
    
    override func onDealershipSelected(dealership: Dealership) {
        var openNext = false
        if pickupScheduleState.rawValue < SchedulePickupState.dealership.rawValue {
            pickupScheduleState = .dealership
            openNext = true
        }
        RequestedServiceManager.sharedInstance.setDealership(dealership: dealership)
        
        dealershipView.descLeftLabel.text = dealership.name
        currentPresentrVC?.dismiss(animated: true, completion: {
            if openNext {
                self.loanerClick()
            } else {
                // timeslots already selected, need to invalidate them
                self.onDateTimeSelected(timeSlot: nil)
                self.showConfirmButtonIfNeeded()
            }
        })
    }
    
    override func onDateTimeSelected(timeSlot: DealershipTimeSlot?) {
        if pickupScheduleState.rawValue < SchedulePickupState.dateTime.rawValue {
            pickupScheduleState = .dateTime
        }
        super.onDateTimeSelected(timeSlot: timeSlot)
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.showConfirmButtonIfNeeded()
        })
    }
    
    override func onLocationSelected(customerAddress: CustomerAddress) {
        
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.showBlockingLoading()
        })
        
        var openNext = false
        
        if pickupScheduleState.rawValue < SchedulePickupState.location.rawValue {
            pickupScheduleState = .location
            openNext = true
        }
        
        super.onLocationSelected(customerAddress: customerAddress)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            
            self.fetchDealershipsForLocation(location: customerAddress.location?.getLocation(), completion: { error in
                // hide loader
                self.hideBlockingLoading()
                if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
                    self.pickupLocationView.hideError()
                    self.dealershipView.descLeftLabel.text = dealership.name
                    
                    if self.pickupScheduleState.rawValue < SchedulePickupState.dealership.rawValue {
                        self.pickupScheduleState = .dealership
                        openNext = true
                    }
                    if openNext {
                        self.dealershipView.animateAlpha(show: true)
                        // show date time
                        self.loanerClick()
                    }
                    
                } else {
                    RequestedServiceManager.sharedInstance.setPickupRequestLocation(requestLocation: nil)
                    if let error = error {
                        self.pickupLocationView.showError(error: error)
                    } else {
                        self.pickupLocationView.showError(error: .OutOfPickupArea)
                    }
                }
                self.showConfirmButtonIfNeeded()

            })
        })
        
    }
    
    @objc override func dealershipClick() {
        showDealershipModal(dismissOnTap: pickupScheduleState.rawValue >= SchedulePickupState.dealership.rawValue)
        super.dealershipClick()
    }
    
    @objc override func scheduledPickupClick() {
        showPickupDateTimeModal(dismissOnTap: pickupScheduleState.rawValue >= SchedulePickupState.dateTime.rawValue)
        super.scheduledPickupClick()
    }
    
    @objc override func pickupLocationClick() {
        showPickupLocationModal(dismissOnTap: pickupScheduleState.rawValue >= SchedulePickupState.location.rawValue)
        super.pickupLocationClick()
    }
    
    @objc override func loanerClick() {
        showPickupLoanerModal(dismissOnTap: pickupScheduleState.rawValue >= SchedulePickupState.loaner.rawValue)
        super.loanerClick()
    }
    
    override func confirmButtonClick() {
        createBooking(loaner: RequestedServiceManager.sharedInstance.getLoaner())
    }
    
    override func showConfirmButtonIfNeeded() {
        
        if let _ = UserManager.sharedInstance.getCustomerId(),
            let _ = RequestedServiceManager.sharedInstance.getDealership(),
            let _ = RequestedServiceManager.sharedInstance.getPickupTimeSlot(),
            let _ = RequestedServiceManager.sharedInstance.getRepairOrder() {
            confirmButton.animateAlpha(show: true)
        } else {
            confirmButton.animateAlpha(show: false)
        }
    }
    
    private func createBooking(loaner: Bool) {
        
        guard let customerId = UserManager.sharedInstance.getCustomerId() else {
            return
        }
        
        if Config.sharedInstance.isMock {
            let booking = Booking.mockBooking(customer: UserManager.sharedInstance.getCustomer()!, vehicle: vehicle, dealership: RequestedServiceManager.sharedInstance.getDealership()!)
            if let realm = self.realm {
                try? realm.write {
                    realm.add(booking, update: true)
                }
            }
            self.createPickupRequest(customerId: customerId, booking: booking)
            
            return
        }
        
        guard let dealership = RequestedServiceManager.sharedInstance.getDealership() else {
            return
        }
        guard let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder() else {
            return
        }
        
        confirmButton.isLoading = true
        
        BookingAPI().createBooking(customerId: customerId, vehicleId: vehicle.id, dealershipId: dealership.id, loaner: loaner).onSuccess { result in
            if let booking = result?.data?.result {
                if let realm = self.realm {
                    try? realm.write {
                        if booking.customerId == -1 {
                            booking.customerId = customerId
                        }
                        realm.add(booking, update: true)
                    }
                }
                self.createRepairOrder(customerId: customerId, booking: booking, repairOrder: repairOrder)
            } else {
                // todo show error
                self.confirmButton.isLoading = false
            }
            
            }.onFailure { error in
                // todo show error
                self.confirmButton.isLoading = false
        }
    }
    
    private func createRepairOrder(customerId: Int, booking: Booking, repairOrder: RepairOrder) {
        
        if Config.sharedInstance.isMock {
            // if mock, skip service for now
            createPickupRequest(customerId: customerId, booking: booking)
            return
        }
        
        guard let repairOrderType = repairOrder.repairOrderType else {
            // todo show error
            return
        }
        
        guard let dealership = RequestedServiceManager.sharedInstance.getDealership() else {
            // todo show error
            return
        }
        
        guard let realm = self.realm else {
            // todo show error
            return
        }
        
        guard let dealershipRepairOrder = realm.objects(DealershipRepairOrder.self).filter("repairOrderTypeId = \(repairOrderType.id) AND dealershipId = \(dealership.id) AND enabled = true").first else {
            // todo show error
            return
        }
        
        RepairOrderAPI().createRepairOrder(customerId: customerId, bookingId: booking.id, dealershipRepairOrderId: dealershipRepairOrder.id, notes: repairOrder.notes).onSuccess { result in
            if let repairOrder = result?.data?.result {
                try? realm.write {
                    realm.add(repairOrder, update: true)
                    if booking.repairOrderRequests.count == 0 {
                        booking.repairOrderRequests.append(repairOrder)
                        realm.add(booking, update: true)
                    }
                }
                self.createPickupRequest(customerId: customerId, booking: booking)
                return
            } else {
                // todo show error
                self.confirmButton.isLoading = false
            }
            // todo show error
            self.confirmButton.isLoading = false
            }.onFailure { error in
                // todo show error
                self.confirmButton.isLoading = false
        }
        
    }
    
    private func createPickupRequest(customerId: Int, booking: Booking) {
        if let timeSlot = RequestedServiceManager.sharedInstance.getPickupTimeSlot(),
            let location = RequestedServiceManager.sharedInstance.getPickupLocation() {
            
            if Config.sharedInstance.isMock {
                let pickupRequest = Request.mockRequest(bookingId: booking.id, location: location, timeSlot: timeSlot)
                self.manageNewPickupRequest(pickupRequest: pickupRequest, booking: booking)
                return
            }
            
            var isDriver = true
            if let type = RequestedServiceManager.sharedInstance.getPickupRequestType(), type == .advisorPickup {
                isDriver = false
            }
            
            BookingAPI().createPickupRequest(customerId: customerId, bookingId: booking.id, timeSlotId: timeSlot.id, location: location, isDriver: isDriver).onSuccess { result in
                if let pickupRequest = result?.data?.result {
                    self.manageNewPickupRequest(pickupRequest: pickupRequest, booking: booking)
                    self.refreshFinalBooking(customerId: customerId, bookingId: booking.id)
                } else {
                    // todo show error
                    self.confirmButton.isLoading = false
                }
                // todo show error
                self.confirmButton.isLoading = false
                }.onFailure { error in
                    // todo show error
                    self.confirmButton.isLoading = false
                    // an error occured while creating the request, try again with same booking
                    self.showDialog(title: .Error, message: .GenericError, buttonTitle: String.Retry, completion: {
                        self.createPickupRequest(customerId: customerId, booking: booking)
                    })
            }
        }
    }
    
    private func manageNewPickupRequest(pickupRequest: Request, booking: Booking) {
        
        if let realm = self.realm {
            try? realm.write {
                realm.add(pickupRequest, update: true)
            }
            let realmPickupRequest = realm.objects(Request.self).filter("id = \(pickupRequest.id)").first
            
            if let booking = realm.objects(Booking.self).filter("id = \(booking.id)").first {
                
                try? realm.write {
                    booking.pickupRequest = realmPickupRequest
                    realm.add(booking, update: true)
                }
            }
        }
    }
    
    private func refreshFinalBooking(customerId: Int, bookingId: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        BookingAPI().getBooking(customerId: customerId, bookingId: bookingId).onSuccess { result in
            if let booking = result?.data?.result {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(booking, update: true)
                    }
                }
                UserManager.sharedInstance.addBooking(booking: booking)
                
                self.navigationController?.popToRootViewController(animated: false)
            }
            
            RequestedServiceManager.sharedInstance.reset()
            self.appDelegate?.showVehiclesView(animated: false)
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            }.onFailure { error in
                // retry
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showDialog(title: .Error, message: .GenericError, buttonTitle: .Retry, completion: {
                    self.refreshFinalBooking(customerId: customerId, bookingId: bookingId)
                })
        }
    }
    
}
