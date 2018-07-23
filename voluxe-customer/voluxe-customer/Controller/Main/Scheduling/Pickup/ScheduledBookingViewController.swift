//
//  ScheduledBookingViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import MBProgressHUD

class ScheduledBookingViewController: SchedulingViewController {
    
    let booking: Booking
    weak var delegate: ScheduledBookingDelegate?
    
    let leftButton: VLButton
    let rightButton: VLButton
    
    init(booking: Booking, delegate: ScheduledBookingDelegate?) {
        self.booking = booking
        self.delegate = delegate
        
        var event = AnalyticsEnums.Name.Button.inboundCancel
        if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
            event = .outboundCancel
        }

        leftButton = VLButton(type: .orangePrimary, title: (.CancelPickup as String).uppercased(), kern: UILabel.uppercasedKern(), event: event, screen: .bookingDetail)
        rightButton = VLButton(type: .bluePrimary, title: (.Done as String).uppercased(), kern: UILabel.uppercasedKern(), event: .done, screen: .bookingDetail)
        
        super.init(vehicle: booking.vehicle!, state: Booking.getStateForBooking(booking: booking), screen: .bookingDetail)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        var title = String.CancelPickup
        
        if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
            title = .CancelDropOff
            leftButton.setTitle(title: title.uppercased())
        }
        
        loanerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dealershipView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.loanerFeatureEnabledKey) {
            scheduledPickupView.snp.makeConstraints { make in
                make.left.right.equalTo(scheduledServiceView)
                make.top.equalTo(loanerView.snp.bottom)
                make.height.equalTo(SchedulingViewController.vlLabelHeight)
            }
        } else {
            scheduledPickupView.snp.makeConstraints { make in
                make.left.right.equalTo(scheduledServiceView)
                make.top.equalTo(dealershipView.snp.bottom)
                make.height.equalTo(SchedulingViewController.vlLabelHeight)
            }
        }
        
        
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
        
        leftButton.setActionBlock { [weak self] in
            self?.leftButtonClick()
        }
        rightButton.setActionBlock { [weak self] in
            self?.rightButtonClick()
        }
        
        confirmButton.animateAlpha(show: false)
        leftButton.animateAlpha(show: true)
        rightButton.animateAlpha(show: true)
        
        scheduledPickupView.animateAlpha(show: true)
        pickupLocationView.animateAlpha(show: true)
        dealershipView.animateAlpha(show: true)
        
        if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.loanerFeatureEnabledKey) {
            loanerView.animateAlpha(show: true)
        }
        
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
    
    override func stateDidChange(state: ServiceState) {
        // no need to update this view on state change
    }
    
    private func fillViewsForRequest(request: Request) {
        if let timeSlot = request.timeSlot, let date = timeSlot.from {
            let dateTime = formatter.string(from: date)
            var title = String.ScheduledPickup
            if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                title = .ScheduledDelivery
            }
            scheduledPickupView.setTitle(title: title, leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" )", rightDescription: "")
        }
        
        if let requestLocation = request.location {
            var title = String.PickupLocation
            if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                title = .DeliveryLocation
            }
            pickupLocationView.setTitle(title: title, leftDescription: requestLocation.address!, rightDescription: "")
        }
        
        if booking.repairOrderRequests.count > 0 {
            if ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                scheduledServiceView.setTitle(title: .SelectedService, leftDescription: booking.getRepairOrderName(), rightDescription: "")
            } else {
                scheduledServiceView.setTitle(title: .CompletedService, leftDescription: booking.getRepairOrderName(), rightDescription: "")
            }
        }
        
        if let dealership = booking.dealership {
            self.dealershipView.setTitle(title: .Dealership, leftDescription: dealership.name!, rightDescription: "")
        }
        
        loanerView.descLeftLabel.text = booking.loanerVehicleRequested ? .Yes : .No
    }
    
    func leftButtonClick() {
        var title = String.CancelPickup
        var message = String.AreYouSureCancelPickup
        
        if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
            title = .CancelDropOff
            message = .AreYouSureCancelDropOff
        }
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        // Submit button
        let backAction = UIAlertAction(title: .Back, style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        })
        
        // Submit button
        let deleteAction = UIAlertAction(title: title, style: .destructive, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            self.cancelRequest()
        })
        
        alert.addAction(backAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelRequest() {
        if let dropoffRequest = booking.dropoffRequest, let type = dropoffRequest.getType() {
            showProgressHUD()

            BookingAPI().cancelDropoffRequest(customerId: UserManager.sharedInstance.customerId()!, bookingId: booking.id, requestId: dropoffRequest.id, isDriver: type == .driverDropoff).onSuccess { result in

                self.onDelete()
                self.hideProgressHUD()
                
                }.onFailure { error in
                    self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
                    self.hideProgressHUD()
            }
            
            
        } else if let pickupRequest = booking.pickupRequest, let type = pickupRequest.getType() {
            showProgressHUD()

            BookingAPI().cancelPickupRequest(customerId: UserManager.sharedInstance.customerId()!, bookingId: booking.id, requestId: pickupRequest.id, isDriver: type == .driverPickup).onSuccess { result in
               
                self.onDelete()
                self.hideProgressHUD()

                }.onFailure { error in
                    self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
                    self.hideProgressHUD()

            }
        }
        
        
        
    }
    
    private func onDelete() {
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
            if let customerId = UserManager.sharedInstance.customerId() {
                let bookings = realm.objects(Booking.self).filter("customerId = %@", customerId)
                UserManager.sharedInstance.setBookings(bookings: Array(bookings))
            }
        }
        
        if let delegate = delegate {
            delegate.onCancelRequest()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func showDescriptionClick() {
        if let vehicle = booking.vehicle, booking.repairOrderRequests.count > 0 {
            let controller = ServiceDetailViewController(vehicle: vehicle, service: booking.repairOrderRequests[0])
            self.pushViewController(controller, animated: true)
        }
    }
    
}

// MARK: protocol PickupDealershipDelegate
protocol ScheduledBookingDelegate: class {
    func onCancelRequest()
}
