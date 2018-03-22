//
//  SchedulingDropoffViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

class SchedulingDropoffViewController: SchedulingViewController {
    
    var isSelfDrop = false
    
    let booking: Booking
    
    init(state: ServiceState, booking: Booking) {
        self.booking = booking
        super.init(state: state)
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
    
    func hideLocation() {
        
        self.pickupLocationView.isHidden = true
        
        self.pickupLocationView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
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
            scheduledPickupClick()
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
                
                if let dealerships = self.dealerships, dealerships.count > 0 {
                    for dealership in dealerships {
                        if dealership.id == RequestedServiceManager.sharedInstance.getDealership()?.id {
                            self.pickupLocationView.hideError()
                            self.confirmButton.animateAlpha(show: true)
                            return
                            // within zone
                        }
                    }
                }
                
                //todo: OUT OF ZONE ERROR
                self.pickupLocationView.showError(error: .OutOfPickupArea)
                self.confirmButton.animateAlpha(show: false)
            })
        })
        
        
    }
    
    override func onDateTimeSelected(timeSlot: DealershipTimeSlot) {
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
                    self.confirmButton.animateAlpha(show: true)
                }
            }
        })
    }
    
    override func confirmButtonClick() {
        guard let customerId = UserManager.sharedInstance.getCustomerId() else {
            return
        }
        
        if let booking = RequestedServiceManager.sharedInstance.getBooking(),
            let timeSlot = RequestedServiceManager.sharedInstance.getDropoffTimeSlot(),
            let location = RequestedServiceManager.sharedInstance.getDropoffLocation() {
            
            confirmButton.isLoading = true
            
            BookingAPI().createDropoffRequest(customerId: customerId, bookingId: booking.id, timeSlotId: timeSlot.id, location: location).onSuccess { result in
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
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
}
