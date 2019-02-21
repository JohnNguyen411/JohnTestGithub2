//
//  RequestState.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/13/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class RequestState: Object {
    
    dynamic var id: Int = -1
    dynamic var bookingId: Int = -1
    dynamic var state: String = "requested"
    dynamic var type: String?
    dynamic var task: String?
    dynamic var driverId: Int = -1
    dynamic var vehicleId: Int = -1
    dynamic var loanerVehicleId: Int = -1
    dynamic var vehicleInspectionId: Int = -1
    dynamic var loanerInspectionId: Int = -1

    
    init(request: Request, driverId: Int) {
        self.id = request.id
        self.bookingId = request.bookingId
        self.state = request.state.rawValue
        self.type = request.type.rawValue
        self.task = request.task?.rawValue
        self.driverId = driverId
        self.vehicleId = request.booking?.vehicleId ?? -1
        self.loanerVehicleId = request.booking?.loanerVehicleId ?? -1
        self.vehicleInspectionId = request.vehicleInspectionId ?? -1
        self.loanerInspectionId = request.loanerInspectionId ?? -1
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func requestToRequestState(requests: [Request], driverId: Int) -> [RequestState] {
        var requestsState: [RequestState] = []
        for request in requests {
            requestsState.append(RequestState(request: request, driverId: driverId))
        }
        return requestsState
    }
    
    static func hasLoanerInspection(requestId: Int) -> Int? {
        guard let realm = try? Realm() else { return nil }
        if let request = realm.objects(RequestState.self).filter("id = %@", requestId).first {
            return request.loanerInspectionId
        }
        return nil
    }
    
    static func hasVehicleInspection(requestId: Int) -> Int? {
        guard let realm = try? Realm() else { return nil }
        if let request = realm.objects(RequestState.self).filter("id = %@", requestId).first {
            return request.vehicleInspectionId
        }
        return nil
    }
    
    private static func loanerInspection(requestId: Int) -> Inspection? {
        guard let realm = try? Realm() else { return nil }
        if let request = realm.objects(RequestState.self).filter("id = %@", requestId).first, request.loanerInspectionId > -1 {
            return Inspection(id: request.loanerInspectionId, requestId: requestId, vehicleId: request.vehicleId, notes: nil)
        }
        return nil
    }
    
    private static func vehicleInspection(requestId: Int) -> Inspection? {
        guard let realm = try? Realm() else { return nil }
        if let request = realm.objects(RequestState.self).filter("id = %@", requestId).first, request.vehicleInspectionId > -1 {
            return Inspection(id: request.vehicleInspectionId, requestId: requestId, vehicleId: request.vehicleId, notes: nil)
        }
        return nil
    }
    
    public static func inspection(for type: InspectionType, requestId: Int) -> Inspection? {
        if type == .loaner {
            return RequestState.loanerInspection(requestId: requestId)
        } else if type == .vehicle {
            return RequestState.vehicleInspection(requestId: requestId)
        }
        return nil
    }
}
