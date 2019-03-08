//
//  UserManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SwiftEventBus
import RealmSwift

final class UserManager {
    
    static let sharedInstance = UserManager()
    
    public var tempCustomerId: Int?
    public var signupCustomer = SignupCustomer()
    private var customer: Customer?
    private var vehicles: [Vehicle]?
    private var vehicleBookings = [Int: [Booking]]() // bookings dict (Vehicle Id : Booking array)
    private var bookings = [Booking]() // bookings dict (Vehicle Id : Booking array)
    
    public func loginSuccess(token: String, customerId: String?) {
        KeychainManager.sharedInstance.saveAccessToken(token: token, customerId: customerId)
    }
    
    public func logout() {
        // logout from API
        _ = CustomerAPI.logout()
        KeychainManager.sharedInstance.saveAccessToken(token: nil, customerId: nil)
        self.customer = nil
        self.vehicles = nil
        self.vehicleBookings = [Int: [Booking]]()
        self.bookings = [Booking]()
        self.tempCustomerId = nil
        self.signupCustomer = SignupCustomer()
        RequestedServiceManager.sharedInstance.reset()
        BookingSyncManager.sharedInstance.stopAllTimers()

        if let realm = try? Realm() {
            try? realm.write {
                realm.deleteAll()
            }
        }
    }
    
    public func isLoggedIn() -> Bool {
        // make sure to load keychain just in case
        _ = KeychainManager.sharedInstance
        
        // user loggedin if access token isn't nil and not empty
        if let accessToken = KeychainManager.sharedInstance.accessToken, !accessToken.isEmpty {
            return true
        }
        return false
    }
    
    public func customerId() -> Int? {
        return KeychainManager.sharedInstance.customerId
    }
    
    public func setCustomer(customer: Customer?) {
        self.customer = customer
    }
    
    public func setVehicles(vehicles: [Vehicle]) {
        self.vehicles = vehicles
        SwiftEventBus.post("setUserVehicles")
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
                StateServiceManager.sharedInstance.updateState(state: Booking.getStateForBooking(booking: booking), vehicleId: booking.vehicleId, booking: booking)
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
    
    // return true if it's a new booking
    public func addBooking(booking: Booking) -> Bool {
        if booking.getState() == .completed && booking.bookingFeedback != nil {
            // ignore
            SwiftEventBus.post("setActiveBooking")

            return false
        }
        
        var carBookings: [Booking]? = self.vehicleBookings[booking.vehicleId]
        if carBookings != nil {
            var indexBooking = -1
            for (index, carBook) in carBookings!.enumerated() {
                if carBook.id == booking.id {
                    // already exist
                    indexBooking = index
                    break
                }
            }
            if indexBooking >= 0 {
                carBookings!.remove(at: indexBooking)
            }
            carBookings!.append(booking)
        } else {
            carBookings = [booking]
        }
        
        var indexBooking = -1
        for (index, book) in self.bookings.enumerated() {
            if book.id == booking.id {
                // already exist
                indexBooking = index
                break
            }
        }
        if indexBooking >= 0 {
            self.bookings.remove(at: indexBooking)
        }
        
        self.bookings.append(booking)
        self.vehicleBookings[booking.vehicleId] = carBookings

        if indexBooking == -1 {
            // new booking
            SwiftEventBus.post("bookingAdded")
        }
        SwiftEventBus.post("setActiveBooking")
        
        return indexBooking == -1
    }
    
    public func getActiveBookings() -> [Booking] {
        var todaysBookings: [Booking] = []
        for booking in bookings {
            if booking.isActive() {
                todaysBookings.append(booking)
            }
        }
        return todaysBookings
    }
    
    public func updateBooking(updatedBooking: Booking) {
       /* var indexBooking = -1
        var indexVehicleBooking = -1
        for (index, booking) in self.bookings.enumerated() {
            if booking.id == updatedBooking.id {
                indexBooking = index
                break
            }
        }
        var carBookings: [Booking]? = self.vehicleBookings[booking.vehicleId]
        if carBookings != nil {
            var indexBooking = -1
            for (index, carBook) in carBookings!.enumerated() {
                if carBook.id == updatedBooking.id {
                    // already exist
                    indexVehicleBooking = index
                    break
                }
            }
            if indexVehicleBooking >= 0 {
                carBookings!.remove(at: indexVehicleBooking)
            }
            carBookings!.append(updatedBooking)
        }
        */
        _ = self.addBooking(booking: updatedBooking)
        
    }
    
    public func yourVolvoStringTitle() -> String {
        if let vehicles = vehicles, vehicles.count > 1 {
            return .localized(.yourVolvos)
        }
        return .localized(.yourVolvo)
    }
}

// MARK:- Useful utilities

extension UserManager {

    // UserManager will be either signing up a customer or has a logged in customer
    // this is provided as a convenience to get the current customer email
    var currentCustomerEmail: String? {
        let email = self.signupCustomer.email ?? self.customer?.email
        return email
    }
}
