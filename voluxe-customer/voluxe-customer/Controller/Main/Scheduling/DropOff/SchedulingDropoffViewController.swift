//
//  SchedulingDropoffViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import MBProgressHUD

class SchedulingDropoffViewController: SchedulingViewController {
    
    var isSelfDrop = false
    
    let booking: Booking
    
    init(state: ServiceState, booking: Booking) {
        self.booking = booking
        super.init(vehicle: booking.vehicle!, state: state)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        
        super.setupViews()
        
        dealershipView.isUserInteractionEnabled = false
        
        loanerView.isHidden = true
    }
    
    override func fillViews() {
        super.fillViews()
        
        scheduledServiceView.setTitle(title: String.CompletedService, leftDescription: booking.getRepairOrderName(), rightDescription: "")
        
        scheduledPickupView.titleLabel.text = .ScheduledDelivery
        pickupLocationView.titleLabel.text = .DeliveryLocation
    }
    
    func hideDealership() {
        
        self.dealershipView.isHidden = true
        
        self.dealershipView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        scheduledPickupView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(descriptionButton.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        pickupLocationView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scheduledPickupView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
    }
    
    override func fillDealership() {
        var bookingDealership = RequestedServiceManager.sharedInstance.getDealership()
        if bookingDealership == nil {
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                bookingDealership = booking.dealership
            }
        }
        if let dealership = bookingDealership {
            self.dealershipView.setTitle(title: .Dealership, leftDescription: dealership.name!, rightDescription: "")
        }
    }
    
    func hideLocation() {
        
        self.pickupLocationView.isHidden = true
        
        self.pickupLocationView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        var bookingDealership = RequestedServiceManager.sharedInstance.getDealership()
        if bookingDealership == nil {
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                bookingDealership = booking.dealership
            }
        }
        
        if let dealership = bookingDealership {
            showDealershipAddress(dealership: dealership)
        }
        /*
        dealershipView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(pickupLocationView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        pickupLocationView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dealershipView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
         */
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        if let requestType = RequestedServiceManager.sharedInstance.getDropoffRequestType(), requestType == .advisorDropoff {
            isSelfDrop = true
        }
        loanerView.isEditable = false
        dealershipView.isEditable = false
        scheduledPickupView.isEditable = true
        pickupLocationView.isEditable = true
        
        if state == .schedulingDelivery {
            if isSelfDrop {
                hideLocation()
                self.dealershipView.animateAlpha(show: true)
            } else {
                hideDealership()
            }
            if dropoffScheduleState == .start {
                scheduledPickupClick()
            }
        }
        
    }
    
    
    @objc override func dealershipClick() {
    }
    
    @objc override func scheduledPickupClick() {
        showPickupDateTimeModal(dismissOnTap: dropoffScheduleState.rawValue >= ScheduleDropoffState.dateTime.rawValue)
        super.scheduledPickupClick()
    }
    
    @objc override func pickupLocationClick() {
        showPickupLocationModal(dismissOnTap: dropoffScheduleState.rawValue >= ScheduleDropoffState.location.rawValue)
        super.pickupLocationClick()
    }
    
    override func showDescriptionClick() {
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), booking.repairOrderRequests.count > 0 {
            self.navigationController?.pushViewController(ServiceDetailViewController(vehicle: vehicle, service: booking.repairOrderRequests[0]), animated: true)
        }
    }
    
    @objc override func loanerClick() {
    }
    
    override func onLocationSelected(customerAddress: CustomerAddress) {
        // need to check that location is within range
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.showBlockingLoading()
        })
        
        if dropoffScheduleState.rawValue < ScheduleDropoffState.location.rawValue {
            dropoffScheduleState = .location
        }
        
        super.onLocationSelected(customerAddress: customerAddress)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            
            self.fetchDealershipsForLocation(location: customerAddress.location?.getLocation(), completion: {
                // hide loader
                self.hideBlockingLoading()
                var bookingDealership = RequestedServiceManager.sharedInstance.getDealership()
                if bookingDealership == nil {
                    if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) {
                        bookingDealership = booking.dealership
                    }
                }
                
                if let dealerships = self.dealerships, dealerships.count > 0 {
                    for dealership in dealerships {
                        if dealership.id == bookingDealership?.id {
                            self.pickupLocationView.hideError()
                            self.showConfirmButtonIfNeeded()
                            return
                            // within zone
                        }
                    }
                }
                
                //todo: OUT OF ZONE ERROR
                self.pickupLocationView.showError(error: .OutOfPickupArea)
                self.showConfirmButtonIfNeeded()
            })
        })
        
        
    }
    
    override func onDateTimeSelected(timeSlot: DealershipTimeSlot?) {
        var openNext = false
        if dropoffScheduleState.rawValue < ScheduleDropoffState.dateTime.rawValue {
            dropoffScheduleState = .dateTime
            openNext = true
        }
        super.onDateTimeSelected(timeSlot: timeSlot)
        currentPresentrVC?.dismiss(animated: true, completion: {
            if openNext {
                if !self.isSelfDrop {
                    self.pickupLocationClick()
                } else {
                    self.showConfirmButtonIfNeeded()
                }
            }
        })
    }
    
    override func confirmButtonClick() {
        guard let customerId = UserManager.sharedInstance.getCustomerId() else {
            return
        }
        
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle),
            let timeSlot = RequestedServiceManager.sharedInstance.getDropoffTimeSlot(),
            let location = RequestedServiceManager.sharedInstance.getDropoffLocation() {
            
            confirmButton.isLoading = true
            
            var isDriver = true
            if let type = RequestedServiceManager.sharedInstance.getDropoffRequestType(), type == .advisorDropoff {
                isDriver = false
            }
            
            BookingAPI().createDropoffRequest(customerId: customerId, bookingId: booking.id, timeSlotId: timeSlot.id, location: location, isDriver: isDriver).onSuccess { result in
                if let dropOffRequest = result?.data?.result {
                    self.manageNewDropoffRequest(dropOffRequest: dropOffRequest, booking: booking)
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
    }
    
    private func manageNewDropoffRequest(dropOffRequest: Request, booking: Booking) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        if let realm = self.realm {
            try? realm.write {
                realm.add(dropOffRequest, update: true)
            }
            let realmDropOffRequest = realm.objects(Request.self).filter("id = \(dropOffRequest.id)").first
            
            if let booking = realm.objects(Booking.self).filter("id = \(booking.id)").first {
                
                try? realm.write {
                    booking.dropoffRequest = realmDropOffRequest
                    realm.add(booking, update: true)
                }
            }
            
            let bookings = realm.objects(Booking.self).filter("customerId = \(booking.customerId)")
            UserManager.sharedInstance.setBookings(bookings: Array(bookings))
            
            self.navigationController?.popToRootViewController(animated: false)
        }
        
        appDelegate?.showVehiclesView()
        MBProgressHUD.hide(for: self.view, animated: true)

    }
    
    
    override func showConfirmButtonIfNeeded() {
        
        if let _ = UserManager.sharedInstance.getCustomerId(),
            let _ = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle),
            let _ = RequestedServiceManager.sharedInstance.getDropoffTimeSlot(),
            RequestedServiceManager.sharedInstance.getDropoffLocation() != nil || RequestedServiceManager.sharedInstance.getDropoffRequestType() == .advisorDropoff {
                confirmButton.animateAlpha(show: true)
        } else {
            confirmButton.animateAlpha(show: false)
        }
    }
}
