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
    
    private var customer: Customer?
    private var vehicles: [Vehicle]?
    private var vehicleBookings = [Int: [Booking]]() // bookings dict (Vehicle Id : Booking array)
    private let serviceId: String
    private var accessToken: String?
    private let keychain: Keychain
    
    init() {
        let bundle = Bundle(for: type(of: self))
        serviceId = bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        keychain = Keychain(service: serviceId)
        loadAccessToken()
    }
    
    private func loadAccessToken() {
        accessToken = keychain["token"]
    }
    
    private func saveAccessToken(token: String?) {
        keychain["token"] = token
        accessToken = token
    }
    
    public func getAccessToken() -> String? {
        return accessToken
    }
    
    public func loginSuccess(token: String) {
        saveAccessToken(token: token)
    }
    
    public func logout() {
        saveAccessToken(token: nil)
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
    
    public func getCustomerId() -> Int? {
        if let customer = customer {
            return customer.id
        }
        return nil
    }
    
    public func setBookings(bookings: [Booking]?) {
        if let bookings = bookings {
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
                
                if booking.hasUpcomingRequestToday() {
                    RequestedServiceManager.sharedInstance.setBooking(booking: booking, updateState: true) // set current booking
                }
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
