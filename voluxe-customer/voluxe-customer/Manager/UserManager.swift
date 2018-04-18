//
//  UserManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import KeychainAccess
import SwiftEventBus

final class UserManager {
    
    static let sharedInstance = UserManager()
    
    public var tempCustomerId: Int?
    public var signupCustomer = SignupCustomer()
    private var customer: Customer?
    private var vehicles: [Vehicle]?
    private var vehicleBookings = [Int: [Booking]]() // bookings dict (Vehicle Id : Booking array)
    private var bookings = [Booking]() // bookings dict (Vehicle Id : Booking array)
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
        // logout from API
        _ = CustomerAPI().logout()
        saveAccessToken(token: nil, customerId: nil)
        self.customer = nil
        self.vehicles = nil
        self.vehicleBookings = [Int: [Booking]]()
        self.bookings = [Booking]()
        self.tempCustomerId = nil
        self.signupCustomer = SignupCustomer()
        RequestedServiceManager.sharedInstance.reset()
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
    
    public func getVehicleForId(vehicleId: Int) -> Vehicle? {
        if let vehicles = vehicles, vehicles.count > 0 {
            for vehicle in vehicles {
                if vehicle.id == vehicleId {
                    return vehicle
                }
            }
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
            
            self.vehicleBookings.removeAll()
            self.bookings.removeAll()
            
            for booking in bookings {
                // skipped cancelled and completed request, and request w/o any request
                if booking.getState() == .canceled || booking.getState() == .completed || (booking.pickupRequest == nil && booking.dropoffRequest == nil) {
                    continue
                }
                let vehicleId = booking.vehicleId
                var carBookings: [Booking]? = self.vehicleBookings[vehicleId]
                if carBookings != nil {
                    carBookings!.append(booking)
                } else {
                    carBookings = [booking]
                }
                self.bookings.append(booking)
                self.vehicleBookings[vehicleId] = carBookings
                StateServiceManager.sharedInstance.updateState(state: Booking.getStateForBooking(booking: booking), vehicleId: booking.vehicleId)
            }
            // empty array
            if bookings.count == 0 {
                self.vehicleBookings.removeAll()
                self.bookings.removeAll()
            }
            
        } else {
            self.vehicleBookings.removeAll()
            self.bookings.removeAll()
        }
        BookingSyncManager.sharedInstance.syncBookings()

        SwiftEventBus.post("setActiveBooking")
    }
    
    public func getBookings() -> [Booking] {
        return self.bookings
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
    
    public func getLastBookingForVehicle(vehicle: Vehicle) -> Booking? {
        if let bookings = getBookingsForVehicle(vehicle: vehicle), bookings.count > 0 {
            return bookings[bookings.count-1]
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
        self.bookings.append(booking)
        self.vehicleBookings[booking.vehicleId] = carBookings
        StateServiceManager.sharedInstance.updateState(state: Booking.getStateForBooking(booking: booking), vehicleId: booking.vehicleId)

        SwiftEventBus.post("setActiveBooking")
    }
    
    public func getActiveBookings() -> [Booking] {
        var todaysBookings: [Booking] = []
        for booking in bookings {
            if booking.isInvalidated {
                continue
            }
            
            if booking.hasUpcomingRequestToday() || (booking.getState() == .service || booking.getState() == .serviceCompleted
                || booking.getState() == .enRouteForDropoff || booking.getState() == .enRouteForPickup
                || booking.getState() == .nearbyForDropoff || booking.getState() == .nearbyForPickup
                || booking.getState() == .arrivedForDropoff || booking.getState() == .arrivedForPickup) {
                todaysBookings.append(booking)
            }
        }
        return todaysBookings
    }
    
    public func yourVolvoStringTitle() -> String {
        if let vehicles = vehicles, vehicles.count > 1 {
            return .YourVolvos
        }
        return .YourVolvo
    }
}
