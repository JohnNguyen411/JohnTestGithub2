//
//  ScheduledDropoffViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation
import GoogleMaps
import MBProgressHUD
import RealmSwift

class ScheduledDropoffViewController: ScheduledViewController, ScheduleSelfDropModalDelegate {
    
    convenience init(vehicle: Vehicle, state: ServiceState) {
        self.init(vehicle: vehicle, state: state, screen: .dropoffActive)
        stateDidChange(state: state)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driversLicenseInsuranceLabel.isHidden = true
        changeButton.addTarget(self, action: #selector(selfOBClick), for: .touchUpInside)
    }
    
    override func generateSteps() {
        let step1 = Step(id: ServiceState.serviceCompleted, text: .VehicleIsReady, state: .done)
        let step2 = Step(id: ServiceState.enRouteForDropoff, text: .DriverEnRoute)
        let step3 = Step(id: ServiceState.nearbyForDropoff, text: .DriverNearby)
        let step4 = Step(id: ServiceState.arrivedForDropoff, text: .DriverArrived)
        
        steps.append(step1)
        steps.append(step2)
        steps.append(step3)
        steps.append(step4)
    }
    
    override func updateBookingIfNeeded() {
        super.updateBookingIfNeeded()
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) else { return }
        
        if let dropoffRequest = booking.dropoffRequest, let location = dropoffRequest.location, let coordinates = location.getLocation() {
            mapVC.updateRequestLocation(location: coordinates)
            
            weak var weakSelf = self
            // force refresh camera update after 1 sec
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                weakSelf?.mapVC.updateRequestLocation(location: coordinates)
            })
            
            let state = StateServiceManager.sharedInstance.getState(vehicleId: vehicle.id)

            if let timeSlot = dropoffRequest.timeSlot, state == .dropoffScheduled {
                timeWindowView.setTimeWindows(timeWindows: timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "")
                self.timeWindowView.setSubtitle(text: .DeliveryWindow)
            }
        }
        
        if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfOBEnabledKey) {
            changeButton.isHidden = booking.getState() != .dropoffScheduled
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        driverLocationUpdate()
    }
    
    override func driverLocationUpdate() {
        super.driverLocationUpdate()
        
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) else { return }
        
        let state = StateServiceManager.sharedInstance.getState(vehicleId: vehicle.id)

        if let dropoffRequest = booking.dropoffRequest {
            var refreshTimeSlot = true
            
            if let driver = dropoffRequest.driver, let location = driver.location, let coordinates = location.getLocation(), state != .dropoffScheduled {
                self.mapVC.updateDriverLocation(location: coordinates, refreshTime: booking.getRefreshTime())
                if let dropoffRequestLocation = dropoffRequest.location, let dropoffRequestCoordinates = dropoffRequestLocation.getLocation() {
                    refreshTimeSlot = false
                    self.getEta(fromLocation: coordinates, toLocation: dropoffRequestCoordinates)
                    self.timeWindowView.setSubtitle(text: .EstimatedDeliveryTime)
                }
                newDriver(driver: driver)
            }
            if let timeSlot = dropoffRequest.timeSlot, refreshTimeSlot {
                timeWindowView.setTimeWindows(timeWindows: timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "")
                self.timeWindowView.setSubtitle(text: .DeliveryWindow)
            }
        }
    }
    
    
    @objc func selfOBClick() {
        let selfModalVC = ScheduleSelfDropModal(title: .YoureScheduledForDelivery, screen: .selfOBModal)
        selfModalVC.delegate = self
        selfModalVC.view.accessibilityIdentifier = "selfModalVC"
        currentPresentrVC = selfModalVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: true)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func onRescheduleClick() {
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
            RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .driverDropoff)
            self.pushViewController(SchedulingDropoffViewController(state: .schedulingDelivery, booking: booking), animated: true)
        }
    }
    
    func onSelfPickupClick() {
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) {
            RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .advisorDropoff)
            
            self.showProgressHUD()
            CustomerAPI.createDropoffRequest(customerId: booking.customerId, bookingId: booking.id, timeSlotId: nil, location: nil, isDriver: false) { request, error in
                if let dropOffRequest = request {
                    self.manageNewDropoffRequest(dropOffRequest: dropOffRequest, booking: booking)
                    self.refreshFinalBooking(customerId: booking.customerId, bookingId: booking.id)
                } else if error != nil {
                    self.hideProgressHUD()
                    self.showOkDialog(title: .Error, message: .GenericError)
                }
            }
            
        }
    }
    
    private func manageNewDropoffRequest(dropOffRequest: Request, booking: Booking) {
        
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(dropOffRequest, update: true)
            }
            let realmDropOffRequest = realm.objects(Request.self).filter("id = \(dropOffRequest.id)").first
            
            if let booking = realm.objects(Booking.self).filter("id = \(booking.id)").first {
                
                try? realm.write {
                    // update state to scheduled dropoff
                    booking.state = State.dropoffScheduled.rawValue
                    booking.dropoffRequest = realmDropOffRequest
                    realm.add(booking, update: true)
                }
            }
        }
    }
    
    private func refreshFinalBooking(customerId: Int, bookingId: Int) {
        CustomerAPI.booking(customerId: customerId, bookingId: bookingId) { booking, error in
            
            self.hideProgressHUD()
            
            if error != nil {
                self.showDialog(title: .Error, message: .GenericError, buttonTitle: .Retry, completion: {
                    self.refreshFinalBooking(customerId: customerId, bookingId: bookingId)
                }, dialog: .error, screen: self.screen)
            } else {
                
                if let booking = booking {
                    if let realm = try? Realm() {
                        try? realm.write {
                            realm.add(booking, update: true)
                        }
                    }
                }
                
                if let realm = try? Realm() {
                    let bookings = realm.objects(Booking.self).filter("customerId = \(customerId)")
                    UserManager.sharedInstance.setBookings(bookings: Array(bookings))
                }
                
                RequestedServiceManager.sharedInstance.reset()
                AppController.sharedInstance.showVehiclesView(animated: false)
                
            }
        }
    }
}
