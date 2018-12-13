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

        leftButton = VLButton(type: .orangePrimary, title: (.cancelPickup as String).uppercased(), kern: UILabel.uppercasedKern(), event: event, screen: .bookingDetail)
        rightButton = VLButton(type: .bluePrimary, title: (.done as String).uppercased(), kern: UILabel.uppercasedKern(), event: .done, screen: .bookingDetail)
        
        super.init(vehicle: booking.vehicle!, state: Booking.getStateForBooking(booking: booking), screen: .bookingDetail)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        var title = String.cancelPickup
        
        if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
            title = .cancelDropoff
            leftButton.setTitle(title: title.uppercased())
        }
        
        loanerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dealershipView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.loanerFeatureEnabledKey) {
            scheduledPickupView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(scheduledServiceView)
                make.top.equalTo(loanerView.snp.bottom)
                make.height.equalTo(SchedulingViewController.vlLabelHeight)
            }
        } else {
            scheduledPickupView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(scheduledServiceView)
                make.top.equalTo(dealershipView.snp.bottom)
                make.height.equalTo(SchedulingViewController.vlLabelHeight)
            }
        }
        
        
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().dividedBy(2).offset(-20)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        rightButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-10)
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
            var title = String.scheduledPickup
            if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                title = .scheduledDelivery
            }
            scheduledPickupView.setTitle(title: title, leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" )", rightDescription: "")
        }
        
        if let requestLocation = request.location {
            var title = String.pickupLocation
            if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                title = .deliveryLocation
            }
            pickupLocationView.setTitle(title: title, leftDescription: requestLocation.address!, rightDescription: "")
        }
        
        if booking.repairOrderRequests.count > 0 {
            if ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                scheduledServiceView.setTitle(title: .selectedService, leftDescription: booking.getRepairOrderName(), rightDescription: "")
            } else {
                scheduledServiceView.setTitle(title: .completedService, leftDescription: booking.getRepairOrderName(), rightDescription: "")
            }
        }
        
        if let dealership = booking.dealership {
            self.dealershipView.setTitle(title: .dealership, leftDescription: dealership.name!, rightDescription: "")
        }
        
        loanerView.descLeftLabel.text = booking.loanerVehicleRequested ? .yes : .no
    }
    
    func leftButtonClick() {
        var title = String.cancelPickup
        var message = String.popupDefaultCancelPickupMessage
        
        if !ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
            title = .cancelDropoff
            message = .popupDefaultCancelDropoffMessage
        }
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        // Submit button
        let backAction = UIAlertAction(title: .back, style: .default, handler: { (action) -> Void in
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

            CustomerAPI.cancelDropoffRequest(customerId: UserManager.sharedInstance.customerId()!, bookingId: booking.id, requestId: dropoffRequest.id, isDriver: type == .driverDropoff) { error in
                if error != nil {
                    self.showOkDialog(title: .error, message: .errorUnknown, dialog: .error, screen: self.screen)
                    self.hideProgressHUD()
                } else {
                    self.onDelete()
                    self.hideProgressHUD()
                }
            }
            
        } else if let pickupRequest = booking.pickupRequest, let type = pickupRequest.getType() {
            showProgressHUD()

            CustomerAPI.cancelPickupRequest(customerId: UserManager.sharedInstance.customerId()!, bookingId: booking.id, requestId: pickupRequest.id, isDriver: type == .driverPickup) { error in
                if error != nil {
                    self.showOkDialog(title: .error, message: .errorUnknown, dialog: .error, screen: self.screen)
                    self.hideProgressHUD()
                } else {
                    self.onDelete()
                    self.hideProgressHUD()
                }
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
