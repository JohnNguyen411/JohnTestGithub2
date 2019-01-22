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
    
    init(vehicle: Vehicle, state: ServiceState) {
        super.init(vehicle: vehicle, state: state, screen:.pickupNew)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
            setTitle(title: .SelfDrop)
        } else {
            setTitle(title: .SchedulePickup)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        loanerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dealershipView.snp.bottom)
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
    
    override func onDealershipSelected(dealership: Dealership?) {
        var openNext = false
        if pickupScheduleState.rawValue < SchedulePickupState.dealership.rawValue {
            pickupScheduleState = .dealership
            openNext = true
        }
        let preselectedDealership = RequestedServiceManager.sharedInstance.getDealership()
        RequestedServiceManager.sharedInstance.setDealership(dealership: dealership)
        
        if let dealership = dealership {
            dealershipView.setLeftDescription(leftDescription: dealership.name ?? "")
            currentPresentrVC?.dismiss(animated: true, completion: {
                if openNext {
                    self.loanerClick()
                } else {
                    // timeslots already selected, need to invalidate them
                    if preselectedDealership == nil || preselectedDealership!.id != dealership.id {
                        self.onDateTimeSelected(timeSlot: nil)
                        self.scheduledPickupClick()
                    }
                    self.showConfirmButtonIfNeeded()
                }
            })
        } else {
            dealershipView.setLeftDescription(leftDescription: "")
        }
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
            self.showProgressHUD()
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
                self.hideProgressHUD()
                if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
                    self.pickupLocationView.hideError()
                    self.dealershipView.setLeftDescription(leftDescription: dealership.name ?? "")
                    
                    if self.pickupScheduleState.rawValue < SchedulePickupState.dealership.rawValue {
                        if let dealerships = self.dealerships, dealerships.count > 1 {
                            self.pickupScheduleState = .location
                        } else {
                            self.pickupScheduleState = .dealership
                        }
                        openNext = true
                    }
                    self.dealershipView.animateAlpha(show: true)
                    if openNext {
                        if self.pickupScheduleState == .location {
                            self.dealershipClick()
                        } else {
                            // show loaner
                            self.loanerClick()
                        }
                    }
                    
                } else {
                    RequestedServiceManager.sharedInstance.setPickupRequestLocation(requestLocation: nil)
                    
                    // clear dealership and datetime selection
                    self.onDateTimeSelected(timeSlot: nil)
                    self.onDealershipSelected(dealership: nil)
                    
                    self.scheduledPickupView.animateAlpha(show: false)
                    self.dealershipView.animateAlpha(show: false)
                    
                    self.pickupScheduleState = .start
                    
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
        if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.loanerFeatureEnabledKey) {
            showPickupLoanerModal(dismissOnTap: pickupScheduleState.rawValue >= SchedulePickupState.loaner.rawValue)
            super.loanerClick()
        } else {
            RequestedServiceManager.sharedInstance.setLoaner(loaner: true)
            pickupScheduleState = .loaner
            scheduledPickupClick()
        }
    }
    
    override func confirmButtonClick() {
        if let loaner = RequestedServiceManager.sharedInstance.getLoaner() {
            createBooking(loaner: loaner)
        }
    }
    
    override func showConfirmButtonIfNeeded() {
        
        if let _ = UserManager.sharedInstance.customerId(),
            let _ = RequestedServiceManager.sharedInstance.getDealership(),
            let _ = RequestedServiceManager.sharedInstance.getPickupTimeSlot(),
            let _ = RequestedServiceManager.sharedInstance.getRepairOrder() {
            confirmButton.animateAlpha(show: true)
        } else {
            confirmButton.animateAlpha(show: false)
        }
    }
    
    private func createBooking(loaner: Bool) {
        
        guard let customerId = UserManager.sharedInstance.customerId() else { return }
        guard let realm = self.realm else { return }
        guard let dealership = RequestedServiceManager.sharedInstance.getDealership() else { return }
        guard let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder() else { return }
        guard let repairOrderType = repairOrder.repairOrderType else { return }
        guard let timeSlot = RequestedServiceManager.sharedInstance.getPickupTimeSlot() else { return }
        guard let location = RequestedServiceManager.sharedInstance.getPickupLocation() else { return }

        var isDriver = true
        if let type = RequestedServiceManager.sharedInstance.getPickupRequestType(), type == .advisorPickup {
            isDriver = false
        }
       
        guard let dealershipRepairOrder = realm.objects(DealershipRepairOrder.self).filter("repairOrderTypeId = \(repairOrderType.id) AND dealershipId = \(dealership.id) AND enabled = true").first else { return }
        
        confirmButton.isLoading = true
        
        CustomerAPI.createBooking(customerId: customerId, vehicleId: vehicle.id, dealershipId: dealership.id, loaner: loaner, dealershipRepairId: dealershipRepairOrder.id, repairNotes: repairOrder.notes, repairTitle: repairOrder.title, vehicleDrivable: repairOrder.vehicleDrivable.value, timeSlotId: timeSlot.id, location: location, isDriver: isDriver) { booking, error in
            
            if let error = error {
                // 2 bookings for the same car, not currently handled
                if let code = error.code, code == .E4049 || code == .E4050 {
                    self.confirmButton.isLoading = false
                    self.showDialog(title: .Error, message: String(format: String.DuplicateRequestError, String.Pickup), buttonTitle: .Refresh, completion: {
                        BookingSyncManager.sharedInstance.syncBookings()
                        RequestedServiceManager.sharedInstance.reset()
                        AppController.sharedInstance.showVehiclesView(animated: false)
                    }, dialog: .error, screen: self.screen)
                    return
                } else {
                    self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
                    self.confirmButton.isLoading = false
                }
            } else {
                
                if let booking = booking {
                    if let realm = self.realm {
                        try? realm.write {
                            if booking.customerId == -1 {
                                booking.customerId = customerId
                            }
                            realm.add(booking, update: true)
                        }
                    }
                    self.refreshFinalBooking(customerId: customerId, bookingId: booking.id)
                }
                self.confirmButton.isLoading = false
            }
        }
    }
    
    
    private func createPickupRequest(customerId: Int, booking: Booking) {
        if let timeSlot = RequestedServiceManager.sharedInstance.getPickupTimeSlot(),
            let location = RequestedServiceManager.sharedInstance.getPickupLocation() {
            
            var isDriver = true
            if let type = RequestedServiceManager.sharedInstance.getPickupRequestType(), type == .advisorPickup {
                isDriver = false
            }
            
            CustomerAPI.createPickupRequest(customerId: customerId, bookingId: booking.id, timeSlotId: timeSlot.id, location: location, isDriver: isDriver) { request, error in
                
                if let error = error {
                    if let code = error.code, code == .E4049 || code == .E4050 {
                        self.confirmButton.isLoading = false
                        self.showDialog(title: .Error, message: String(format: String.DuplicateRequestError, String.Pickup), buttonTitle: .Refresh, completion: {
                            self.refreshFinalBooking(customerId: customerId, bookingId: booking.id)
                        }, dialog: .error, screen: self.screen)
                        return
                    } else {
                        // an error occured while creating the request, try again with same booking
                        self.showDialog(title: .Error, message: .GenericError, buttonTitle: String.Retry, completion: {
                            self.createPickupRequest(customerId: customerId, booking: booking)
                        }, dialog: .error, screen: self.screen)
                    }
                } else {
                    if let pickupRequest = request {
                        self.manageNewPickupRequest(pickupRequest: pickupRequest, booking: booking)
                        self.refreshFinalBooking(customerId: customerId, bookingId: booking.id)
                    }
                    self.confirmButton.isLoading = false
                }
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
        showProgressHUD()
        
        CustomerAPI.booking(customerId: customerId, bookingId: bookingId) { booking, error in
            if error != nil {
                // retry
                self.hideProgressHUD()
                self.showDialog(title: .Error, message: .GenericError, buttonTitle: .Retry, completion: {
                    self.refreshFinalBooking(customerId: customerId, bookingId: bookingId)
                }, dialog: .error, screen: self.screen)
            } else {
                if let booking = booking {
                    if let realm = self.realm {
                        try? realm.write {
                            realm.add(booking, update: true)
                        }
                    }
                    _ = UserManager.sharedInstance.addBooking(booking: booking)
                    BookingSyncManager.sharedInstance.syncBookings()
                }
                
                RequestedServiceManager.sharedInstance.reset()
                AppController.sharedInstance.showVehiclesView(animated: false)
                
                self.hideProgressHUD()
            }
        }
    }
    
}
