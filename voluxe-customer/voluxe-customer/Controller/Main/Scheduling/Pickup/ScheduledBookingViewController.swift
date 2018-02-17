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
    
    let leftButton = VLButton(type: .OrangePrimary, title: (.CancelPickup as String).uppercased(), actionBlock: nil)
    let rightButton = VLButton(type: .BluePrimary, title: (.Done as String).uppercased(), actionBlock: nil)
    
    init(booking: Booking) {
        self.booking = booking
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
            make.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).offset(-10)
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
            scheduledPickupView.setTitle(title: .ScheduledPickup, leftDescription: "\(dateTime) \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" ))", rightDescription: "")
        }
        
        if let requestLocation = request.location {
            pickupLocationView.setTitle(title: .PickupLocation, leftDescription: requestLocation.address!, rightDescription: "")
        }
        
        //todo: unmock
        let service = Service.mockService()
        
        scheduledServiceView.setTitle(title: .SelectedService, leftDescription: service.name!, rightDescription: String(format: "$%.02f", service.price!))
        
        if let dealership = booking.dealership {
            self.dealershipView.setTitle(title: .Dealership, leftDescription: dealership.name!, rightDescription: "")
        }
        
        loanerView.descLeftLabel.text = booking.loanerVehicle != nil ? .Yes : .No
    }
    
    func leftButtonClick() {
    }
    
    func rightButtonClick() {
    }
    
    override func showDescriptionClick() {
    }
    
}
