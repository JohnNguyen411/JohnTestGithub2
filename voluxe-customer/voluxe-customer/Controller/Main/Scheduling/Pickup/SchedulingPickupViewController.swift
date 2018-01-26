//
//  SchedulingPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/3/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

class SchedulingPickupViewController: SchedulingViewController {
    
    override func setupViews() {
        super.setupViews()
        loanerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(pickupLocationView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
    }
    
    override func fillViews() {
        
        if let timeSlot = RequestedServiceManager.sharedInstance.getPickupTimeSlot(), let date = timeSlot.from {
            let dateTime = formatter.string(from: date)
            scheduledPickupView.setTitle(title: .ScheduledPickup, leftDescription: "\(dateTime) \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" ))", rightDescription: "")
        }
        
        if let requestLocation = RequestedServiceManager.sharedInstance.getPickupLocation() {
            pickupLocationView.setTitle(title: .PickupLocation, leftDescription: requestLocation.address!, rightDescription: "")
        }
        super.fillViews()
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
        if state == .schedulingService {
            // show dealership modal
            showDealershipModal()
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
    
    
    override func onLocationSelected(responseInfo: NSDictionary?, placemark: CLPlacemark?) {
        var openNext = false
        
        if scheduleState.rawValue < SchedulePickupState.location.rawValue {
            scheduleState = .location
            openNext = true
        }
        
        super.onLocationSelected(responseInfo: responseInfo, placemark: placemark)
        
        currentPresentrVC?.dismiss(animated: true, completion: {
            if openNext {
                self.loanerClick()
            }
        })
    }
    
    override func confirmButtonClick() {
        // StateServiceManager.sharedInstance.updateState(state: .pickupScheduled)
        createBooking(loaner: RequestedServiceManager.sharedInstance.getLoaner())
    }
    
    private func createBooking(loaner: Bool) {
        
        if Config.sharedInstance.isMock {
            //todo mock
            StateServiceManager.sharedInstance.updateState(state: .pickupScheduled)
            return
        }
        
        guard let customerId = UserManager.sharedInstance.getCustomerId() else {
            return
        }
        guard let vehicleId = UserManager.sharedInstance.getVehicleId() else {
            return
        }
        guard let dealership = RequestedServiceManager.sharedInstance.getDealership() else {
            return
        }
        confirmButton.isEnabled = false
        
        BookingAPI().createBooking(customerId: customerId, vehicleId: vehicleId, dealershipId: dealership.id, loaner: loaner).onSuccess { result in
            if let booking = result?.data?.result {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(booking, update: true)
                    }
                }
                RequestedServiceManager.sharedInstance.setBooking(booking: booking, updateState: false)
            }
            self.confirmButton.isEnabled = true
            
            }.onFailure { error in
                // todo show error
                self.confirmButton.isEnabled = true
        }
    }
    
    private func createPickupRequest(bookingId: Int) {
        if let timeSlot = RequestedServiceManager.sharedInstance.getPickupTimeSlot(),
            let location = RequestedServiceManager.sharedInstance.getPickupLocation() {
            BookingAPI().createPickupRequest(bookingId: bookingId, timeSlotId: timeSlot.id, location: location).onSuccess { result in
                if let pickupRequest = result?.data?.result {
                    if let realm = self.realm {
                        try? realm.write {
                            realm.add(pickupRequest)
                        }
                        let realmPickupRequest = realm.objects(Request.self).filter("id = \(pickupRequest.id)").first
                        
                        if let booking = realm.objects(Booking.self).filter("id = \(bookingId)").first {
                            
                            try? realm.write {
                                booking.pickupRequest = realmPickupRequest
                                realm.add(booking, update: true)
                            }
                            RequestedServiceManager.sharedInstance.setBooking(booking: booking, updateState: true)
                        }
                    }
                }
                self.confirmButton.isEnabled = true
                }.onFailure { error in
                    // todo show error
                    self.confirmButton.isEnabled = true
            }
        }
    }
    
}
