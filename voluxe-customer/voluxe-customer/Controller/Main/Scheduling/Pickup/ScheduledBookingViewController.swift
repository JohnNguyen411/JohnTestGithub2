//
//  ScheduledBookingViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

class ScheduledBookingViewController: SchedulingViewController {
    
    let booking: Booking
    let delegate: ScheduledBookingDelegate?
    
    let leftButton = VLButton(type: .orangePrimary, title: (.CancelPickup as String).uppercased(), actionBlock: nil)
    let rightButton = VLButton(type: .bluePrimary, title: (.Done as String).uppercased(), actionBlock: nil)
    
    init(booking: Booking, delegate: ScheduledBookingDelegate?) {
        self.booking = booking
        self.delegate = delegate
        super.init(state: Booking.getStateForBooking(booking: booking))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().dividedBy(2).offset(-20)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        rightButton.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().offset(-10)
            make.width.equalToSuperview().dividedBy(2).offset(-20)
            make.height.equalTo(VLButton.primaryHeight)
        }
    }
    
    
    override func fillViews() {
        
        leftButton.setActionBlock {
            self.leftButtonClick()
        }
        rightButton.setActionBlock {
            self.rightButtonClick()
        }
        
        confirmButton.animateAlpha(show: false)
        leftButton.animateAlpha(show: true)
        rightButton.animateAlpha(show: true)
        
        scheduledPickupView.animateAlpha(show: true)
        pickupLocationView.animateAlpha(show: true)
        dealershipView.animateAlpha(show: true)
        loanerView.animateAlpha(show: true)
        
        scheduledPickupView.isUserInteractionEnabled = false
        pickupLocationView.isUserInteractionEnabled = false
        dealershipView.isUserInteractionEnabled = false
        loanerView.isUserInteractionEnabled = false
        
        if let pickupRequest = booking.pickupRequest, serviceState == .pickupScheduled {
            fillViewsForRequest(request: pickupRequest)
        } else if let dropoffRequest = booking.dropoffRequest {
            fillViewsForRequest(request: dropoffRequest)
        }
    }
    
    private func fillViewsForRequest(request: Request) {
        if let timeSlot = request.timeSlot, let date = timeSlot.from {
            let dateTime = formatter.string(from: date)
            scheduledPickupView.setTitle(title: .ScheduledPickup, leftDescription: "\(dateTime) \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" )", rightDescription: "")
        }
        
        if let requestLocation = request.location {
            pickupLocationView.setTitle(title: .PickupLocation, leftDescription: requestLocation.address!, rightDescription: "")
        }
        
        if booking.repairOrderRequests.count > 0 {
            scheduledServiceView.setTitle(title: .SelectedService, leftDescription: booking.getRepairOrderName(), rightDescription: "")
        }
        
        if let dealership = booking.dealership {
            self.dealershipView.setTitle(title: .Dealership, leftDescription: dealership.name!, rightDescription: "")
        }
        
        loanerView.descLeftLabel.text = booking.loanerVehicle != nil ? .Yes : .No
    }
    
    func leftButtonClick() {
        //todo alertview to cancel
        let alert = UIAlertController(title: .CancelPickup,
                                      message: .AreYouSureCancelPickup,
                                      preferredStyle: .alert)
        
        // Submit button
        let backAction = UIAlertAction(title: .Back, style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        })
        
        // Submit button
        let deleteAction = UIAlertAction(title: .CancelPickup, style: .destructive, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            self.cancelRequest()
            
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(backAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelRequest() {
        // todo submit cancel request with API && Refresh bookings
        
        if !Config.sharedInstance.isMock {
            return
        }
        if let realm = self.realm {
            
            if let pickupRequest = self.booking.pickupRequest, self.serviceState == .pickupScheduled {
                try? realm.write {
                    realm.delete(pickupRequest)
                    realm.delete(self.booking) // delete booking
                    
                }
                
            } else if let dropoffRequest = self.booking.dropoffRequest {
                try? realm.write {
                    realm.delete(dropoffRequest)
                }
                
            }
            
            // reload bookings from DB
            let bookings = realm.objects(Booking.self).filter("customerId = %@ AND (state = %@ OR state = %@)", UserManager.sharedInstance.getCustomerId()!, "created", "started")
            UserManager.sharedInstance.setBookings(bookings: Array(bookings))
        }
        
        if let delegate = delegate {
            delegate.onCancelRequest()
        }
    }
    
    func rightButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func showDescriptionClick() {
        if let vehicle = booking.vehicle, booking.repairOrderRequests.count > 0 {
            self.navigationController?.pushViewController(ServiceDetailViewController(vehicle: vehicle, service: booking.repairOrderRequests[0]), animated: true)
        }
    }
    
}

// MARK: protocol PickupDealershipDelegate
protocol ScheduledBookingDelegate {
    func onCancelRequest()
}
