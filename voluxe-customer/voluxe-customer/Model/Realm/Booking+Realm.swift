//
//  Booking.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Booking: VolvoRealmProtocol {
    
    internal typealias Realm = BookingRealm
    internal typealias Model = Booking
    
    func toRealmObject() -> BookingRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: BookingRealm) -> Booking {
        return Realm.convertToModel(element: realmObject)
    }
    
}


@objcMembers class BookingRealm: Object, RealmObjectConverter {
    
    typealias Model = Booking
    typealias Origin = BookingRealm
    
    dynamic var id: Int = -1
    dynamic var customerId: Int = -1
    dynamic var customer: CustomerRealm?
    dynamic var state: String = "created"
    dynamic var vehicleId: Int = -1
    dynamic var vehicle: VehicleRealm?
    dynamic var dealershipId: Int = -1
    dynamic var dealership: DealershipRealm?
    dynamic var loanerVehicleRequested: Bool = false
    dynamic var loanerVehicleId = RealmOptional<Int>()
    dynamic var loanerVehicle: VehicleRealm?
    dynamic var pickupRequest: RequestRealm?
    dynamic var pickupRequestId = RealmOptional<Int>()
    dynamic var dropoffRequest: RequestRealm?
    dynamic var dropoffRequestId = RealmOptional<Int>()
    dynamic var bookingFeedbackId = RealmOptional<Int>()
    dynamic var bookingFeedback: BookingFeedbackRealm?
    dynamic var repairOrderRequests = List<RepairOrderRealm>()
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return BookingRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: BookingRealm) -> Booking {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: Booking) -> BookingRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<BookingRealm>) -> [Booking] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [Booking]) -> [BookingRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
