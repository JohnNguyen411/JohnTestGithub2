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
        super.init(vehicle: booking.vehicle!, state: state, screen: .dropoffNew)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let requestType = RequestedServiceManager.sharedInstance.getDropoffRequestType(), requestType == .advisorDropoff {
            setTitle(title: .localized(.viewScheduleServiceOptionPickupSelfDeliveryDropoff))
        } else {
            setTitle(title: .localized(.scheduleDelivery))
        }
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
        
        scheduledServiceView.setTitle(title: String.localized(.completedService), leftDescription: booking.getRepairOrderName(), rightDescription: "")
        
        scheduledPickupView.titleLabel.text = .localized(.scheduledDelivery)
        pickupLocationView.titleLabel.text = .localized(.deliveryLocation)
    }
    
    func hideDealership() {
        
        self.dealershipView.isHidden = true
        
        self.dealershipView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        scheduledPickupView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionButton.snp.bottom).offset(10)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        pickupLocationView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
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
            self.dealershipView.setTitle(title: .localized(.dealership), leftDescription: dealership.name!, rightDescription: "")
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
            let controller = ServiceDetailViewController(vehicle: vehicle, service: booking.repairOrderRequests[0])
            self.pushViewController(controller, animated: true)
        }
    }
    
    @objc override func loanerClick() {
    }
    
    override func onLocationSelected(customerAddress: CustomerAddress) {
        // need to check that location is within range
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.showProgressHUD()
        })
        
        if dropoffScheduleState.rawValue < ScheduleDropoffState.location.rawValue {
            dropoffScheduleState = .location
        }
        
        super.onLocationSelected(customerAddress: customerAddress)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            
            self.fetchDealershipsForLocation(location: customerAddress.location?.getLocation(), completion: { error in
                // hide loader
                self.hideProgressHUD()
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
                
                RequestedServiceManager.sharedInstance.setDropoffRequestLocation(requestLocation: nil)
                if let error = error {
                    self.pickupLocationView.showError(error: error)
                } else {
                    self.pickupLocationView.showError(error: .localized(.errorLocationOutOfPickupArea))
                }
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
        guard let customerId = UserManager.sharedInstance.customerId() else { return }
        
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle),
            let timeSlot = RequestedServiceManager.sharedInstance.getDropoffTimeSlot(),
            let location = RequestedServiceManager.sharedInstance.getDropoffLocation() {
            
            confirmButton.isLoading = true
            
            VolvoValetCustomerAPI.createDropoffRequest(customerId: customerId, bookingId: booking.id, timeSlotId: timeSlot.id, location: location, isDriver: true) { request, error in
                if let dropOffRequest = request {
                    self.manageNewDropoffRequest(dropOffRequest: dropOffRequest, booking: booking)
                    self.refreshFinalBooking(customerId: customerId, bookingId: booking.id)
                }
                
                self.confirmButton.isLoading = false
                
                if (error != nil) {
                    if let code = error?.code, code == .E4049 || code == .E4050 {
                        self.showDialog(title: .localized(.error), message: String(format: .localized(.errorDuplicateRequest), String.localized(.delivery)), buttonTitle: .localized(.refresh), completion: {
                            self.refreshFinalBooking(customerId: customerId, bookingId: booking.id)
                        }, dialog: .error, screen: self.screen)
                        return
                    } else {
                        self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                    }
                }
            }
            
        }
    }
    
    private func manageNewDropoffRequest(dropOffRequest: Request, booking: Booking) {
        showProgressHUD()

        if let realm = self.realm {
            try? realm.write {
                realm.add(dropOffRequest, update: true)
            }
            let realmDropOffRequest = realm.objects(Request.self, "id == %@", dropOffRequest.id).first
            
            if let booking = realm.objects(Booking.self, "id == %@", booking.id).first {
                
                try? realm.write {
                    // update state to scheduled dropoff
                    booking.state = State.dropoffScheduled.rawValue
                    booking.dropoffRequest = realmDropOffRequest
                    realm.add(booking, update: true)
                }
            }
        }
        
        hideProgressHUD()

    }
    
    private func refreshFinalBooking(customerId: Int, bookingId: Int) {
        showProgressHUD()
        
        VolvoValetCustomerAPI.booking(customerId: customerId, bookingId: bookingId) { booking, error in
            self.hideProgressHUD()
            
            if error != nil {
                self.showDialog(title: .localized(.error), message: .localized(.errorUnknown), buttonTitle: .localized(.retry), completion: {
                    self.refreshFinalBooking(customerId: customerId, bookingId: bookingId)
                }, dialog: .error, screen: self.screen)
            } else {
                if let booking = booking {
                    if let realm = self.realm {
                        try? realm.write {
                            realm.add(booking, update: true)
                        }
                    }
                }
                
                if let realm = self.realm {
                    let bookings = realm.objects(Booking.self, "customerId == %@", self.booking.customerId)
                    UserManager.sharedInstance.setBookings(bookings: Array(bookings))
                }
                
                RequestedServiceManager.sharedInstance.reset()
                AppController.sharedInstance.showVehiclesView(animated: false)
            }
        }
    }
    
    
    override func showConfirmButtonIfNeeded() {
        
        if let _ = UserManager.sharedInstance.customerId(),
            let _ = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle),
            let _ = RequestedServiceManager.sharedInstance.getDropoffTimeSlot(),
            RequestedServiceManager.sharedInstance.getDropoffLocation() != nil || RequestedServiceManager.sharedInstance.getDropoffRequestType() == .advisorDropoff {
                confirmButton.animateAlpha(show: true)
        } else {
            confirmButton.animateAlpha(show: false)
        }
    }
}
