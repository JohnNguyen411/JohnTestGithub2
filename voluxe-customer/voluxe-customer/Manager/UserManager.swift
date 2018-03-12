//
//  UserManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import KeychainAccess

final class UserManager {
    
    static let sharedInstance = UserManager()
    
    public var tempCustomerId: Int?
    public var signupCustomer = SignupCustomer()
    private var customer: Customer?
    private var vehicles: [Vehicle]?
    private var vehicleBookings = [Int: [Booking]]() // bookings dict (Vehicle Id : Booking array)
    private let serviceId: String
    private var accessToken: String?
    private var customerIdToken: Int?
    private let keychain: Keychain
    
    init() {
        let bundle = Bundle(for: type(of: self))
        serviceId = bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        keychain = Keychain(service: serviceId)
        loadAccessToken()
    }
    
    private func loadAccessToken() {
        accessToken = keychain["token"]
        if let customerIdString = keychain["customerId"] {
            customerIdToken = Int(customerIdString)
        } else {
            customerIdToken = nil
        }
    }
    
    private func saveAccessToken(token: String?, customerId: String?) {
        keychain["token"] = token
        keychain["customerId"] = customerId
        if let customerId = customerId {
            customerIdToken = Int(customerId)
        } else {
            customerIdToken = nil
        }
        accessToken = token
    }
    
    public func getAccessToken() -> String? {
        return accessToken
    }
    
    public func getCustomerId() -> Int? {
        return customerIdToken
    }
    
    public func loginSuccess(token: String, customerId: String?) {
        saveAccessToken(token: token, customerId: customerId)
    }
    
    public func logout() {
        saveAccessToken(token: nil, customerId: nil)
        self.customer = nil
        self.vehicles = nil
        self.vehicleBookings = [Int: [Booking]]()
        self.tempCustomerId = nil
        self.signupCustomer = SignupCustomer()
    }
    
    public func setCustomer(customer: Customer) {
        self.customer = customer
    }
    
    public func setVehicles(vehicles: [Vehicle]) {
        self.vehicles = vehicles
    }
    
    public func getVehicles() -> [Vehicle]? {
        return vehicles
    }
    
    public func getVehicle() -> Vehicle? {
        if let vehicles = vehicles, vehicles.count > 0 {
            return vehicles[0]
        }
        return nil
    }
    
    public func getVehicleId() -> Int? {
        if let vehicles = vehicles, vehicles.count > 0 {
            return vehicles[0].id
        }
        return nil
    }
    
    public func getCustomer() -> Customer? {
        if let customer = customer {
            return customer
        }
        return nil
    }
    
    public func setBookings(bookings: [Booking]?) {
        if let bookings = bookings {
            var hasUpcomingRequestToday = false
            for booking in bookings {
                if booking.getState() == .cancelled || booking.getState() == .completed {
                    continue
                }
                let vehicleId = booking.vehicleId
                var carBookings: [Booking]? = self.vehicleBookings[vehicleId]
                if carBookings != nil {
                    carBookings!.append(booking)
                } else {
                    carBookings = [booking]
                }
                self.vehicleBookings[vehicleId] = carBookings
                if booking.hasUpcomingRequestToday() || (booking.getState() == .service || booking.getState() == .serviceCompleted
                                                        || booking.getState() == .enRouteForDropoff || booking.getState() == .enRouteForPickup
                                                        || booking.getState() == .nearbyForDropoff || booking.getState() == .nearbyForPickup
                                                        || booking.getState() == .arrivedForDropoff || booking.getState() == .arrivedForPickup) {
                    hasUpcomingRequestToday = true
                    RequestedServiceManager.sharedInstance.setBooking(booking: booking, updateState: true) // set current booking
                }
            }
            if bookings.count == 0 || !hasUpcomingRequestToday {
                // empty array
                RequestedServiceManager.sharedInstance.setBooking(booking: nil, updateState: true) // no current booking
                self.vehicleBookings.removeAll()
            }
        } else {
            RequestedServiceManager.sharedInstance.setBooking(booking: nil, updateState: true) // no current booking
            self.vehicleBookings.removeAll()
        }
    }
    
    public func getBookingsForVehicle(vehicle: Vehicle) -> [Booking]? {
        return self.vehicleBookings[vehicle.id]
    }
    
    public func getFirstBookingForVehicle(vehicle: Vehicle) -> Booking? {
        if let bookings = getBookingsForVehicle(vehicle: vehicle), bookings.count > 0 {
            return bookings[0]
        }
        return nil
    }
    
    public func addBooking(booking: Booking) {
        var carBookings: [Booking]? = self.vehicleBookings[booking.vehicleId]
        if carBookings != nil {
            carBookings!.append(booking)
        } else {
            carBookings = [booking]
        }
        self.vehicleBookings[booking.vehicleId] = carBookings
        if booking.hasUpcomingRequestToday() {
            RequestedServiceManager.sharedInstance.setBooking(booking: booking, updateState: true) // set current booking
        }
    }
    
}
